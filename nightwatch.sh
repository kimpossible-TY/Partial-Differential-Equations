#!/bin/bash
# ==============================================================================
# Project NightWatch — Handoff Automation Script
# 📋 TASKS.md의 내용을 기반으로 자율 실행 루프를 자동으로 트리거합니다.
# ==============================================================================

set -e

# 설정
TASKS_FILE="TASKS.md"
WORKFLOW_NAME="nightwatch-loop.yml"

# 1. TASKS.md 확인
if [ ! -f "$TASKS_FILE" ]; then
    echo "❌ 에러: $TASKS_FILE 파일을 찾을 수 없습니다."
    exit 1
fi

# 2. 모든 대기 중인 태스크 추출 (task_runner.py 사용)
TASKS_JSON=$(python3 Tools/task_runner.py --all --json 2>/dev/null)
if [ -z "$TASKS_JSON" ] || echo "$TASKS_JSON" | grep -q '"error"'; then
    echo "ℹ️ 알림: 대기 중인 태스크가 없습니다. TASKS.md를 확인해주세요."
    exit 0
fi

# 태스크 개수 확인
TASK_COUNT=$(echo "$TASKS_JSON" | python3 -c 'import sys,json; print(len(json.load(sys.stdin)))')

TIMESTAMP=$(date +%Y%m%d%H%M%S)
CURRENT_BRANCH=$(git branch --show-current)

# 브랜치 생성 및 전환 로직 (선택형)
switch_branch() {
    local suggested=$1
    if [ "$CURRENT_BRANCH" == "main" ]; then
        echo "⚠️  경고: 현재 'main' 브랜치에 있습니다. 자율 작업은 별도의 브랜치에서 진행해야 합니다."
        echo "💡 추천 브랜치명: $suggested"
        read -p "🆕 새로운 브랜치 이름 (엔터 시 추천 이름 사용): " BRANCH_INPUT
        
        NEW_BRANCH=${BRANCH_INPUT:-$suggested}
        if [[ ! "$NEW_BRANCH" =~ ^nightwatch/ ]]; then
            NEW_BRANCH="nightwatch/$NEW_BRANCH"
        fi
        echo "🌱 브랜치 설정: $NEW_BRANCH"
        git checkout -B "$NEW_BRANCH"
        CURRENT_BRANCH="$NEW_BRANCH"
    else
        read -p "❓ 새로운 작업을 위한 브랜치를 생성/전환하시겠습니까? (y/n, 기본 n): " CREATE_NEW
        if [[ "$CREATE_NEW" =~ ^[Yy]$ ]]; then
            echo "💡 추천 브랜치명: $suggested"
            read -p "🆕 새로운 브랜치 이름 (엔터 시 추천 이름 사용): " BRANCH_INPUT
            
            NEW_BRANCH=${BRANCH_INPUT:-$suggested}
            if [[ ! "$NEW_BRANCH" =~ ^nightwatch/ ]]; then
                NEW_BRANCH="nightwatch/$NEW_BRANCH"
            fi
            echo "🌱 브랜치 설정: $NEW_BRANCH"
            git checkout -B "$NEW_BRANCH"
            CURRENT_BRANCH="$NEW_BRANCH"
        else
            echo "✅ 현재 브랜치($CURRENT_BRANCH)를 그대로 유지하며 작업을 진행합니다."
        fi
    fi
}

# ---------------------------------------------------------
# 단일 태스크 처리
# ---------------------------------------------------------
if [ "$TASK_COUNT" -eq 1 ]; then
    TITLE=$(echo "$TASKS_JSON" | python3 -c 'import sys,json; print(json.load(sys.stdin)[0]["title"])')
    TAG=$(echo "$TASKS_JSON" | python3 -c 'import sys,json; print(json.load(sys.stdin)[0]["tag"])')
    echo "🔍 발견된 단일 태스크: [$TAG] $TITLE"
    
    SUGGESTED_SUFFIX=$(echo "$TITLE" | tr ' ' '-' | tr -cd '[:alnum:]-' | cut -c1-50 | tr '[:upper:]' '[:lower:]')
    SUGGESTED_BRANCH="nightwatch/$SUGGESTED_SUFFIX"
    
    switch_branch "$SUGGESTED_BRANCH"
    
    echo "💾 변경 사항 저장 중..."
    git add .
    if git diff --cached --quiet; then
        echo "ℹ️ 변경 사항 없음 — 푸시를 시도합니다."
    else
        git commit -m "plan: trigger NightWatch for '$TITLE'"
    fi
    
    echo "🚀 GitHub에 푸시 중..."
    git push origin "$CURRENT_BRANCH"

    echo "🌙 NightWatch 루프를 깨우는 중..."
    gh workflow run "$WORKFLOW_NAME" --ref "$CURRENT_BRANCH" -f branch_name="$CURRENT_BRANCH"

# ---------------------------------------------------------
# 다중 태스크 처리
# ---------------------------------------------------------
else
    echo "🔍 여러 개의 태스크($TASK_COUNT)가 대기 중입니다. 어떻게 실행하시겠습니까?"
    echo "[P]arallel: 병렬 실행 (각 태스크마다 독립된 브랜치/VM 생성)"
    echo "[S]eries  : 순차 실행 (하나의 브랜치에서 일괄 처리)"
    read -p "선택 (P/S): " EXEC_MODE

    # 병렬(Parallel) 모드
    if [[ "$EXEC_MODE" =~ ^[Pp]$ ]]; then
        echo "⚡ 병렬 실행 모드를 시작합니다..."
        ORIGINAL_BRANCH=$CURRENT_BRANCH
        
        for i in $(seq 0 $((TASK_COUNT - 1))); do
            TITLE=$(echo "$TASKS_JSON" | python3 -c "import sys,json; print(json.load(sys.stdin)[$i]['title'])")
            TAG=$(echo "$TASKS_JSON" | python3 -c "import sys,json; print(json.load(sys.stdin)[$i]['tag'])")
            
            SUGGESTED_SUFFIX=$(echo "$TITLE" | tr ' ' '-' | tr -cd '[:alnum:]-' | cut -c1-50 | tr '[:upper:]' '[:lower:]')
            TARGET_BRANCH="nightwatch/${SUGGESTED_SUFFIX}-${TIMESTAMP}"
            
            echo "🌱 [태스크 $((i+1))/$TASK_COUNT] 브랜치 생성: $TARGET_BRANCH"
            git checkout -b "$TARGET_BRANCH"
            
            # 각 태스크마다 해당 정보만 담은 임시 파일 생성
            echo "$TASKS_JSON" | python3 -c "import sys,json; print(json.dumps([json.load(sys.stdin)[$i]], ensure_ascii=False))" > nightwatch_bulk_tasks.json
            
            git add nightwatch_bulk_tasks.json
            git commit -m "plan: trigger NightWatch for '$TITLE' (Parallel)" || true
            
            echo "🚀 GitHub에 푸시 중... ($TARGET_BRANCH)"
            git push origin "$TARGET_BRANCH"
            
            echo "🌙 NightWatch 루프를 깨우는 중... ($TARGET_BRANCH)"
            gh workflow run "$WORKFLOW_NAME" --ref "$TARGET_BRANCH" -f branch_name="$TARGET_BRANCH"
            
            git checkout "$ORIGINAL_BRANCH"
        done
        CURRENT_BRANCH=$ORIGINAL_BRANCH

    # 순차(Series) 모드
    else
        echo "🔄 순차 실행 모드를 시작합니다..."
        SUGGESTED_BRANCH="nightwatch/bulk-run-${TIMESTAMP}"
        
        switch_branch "$SUGGESTED_BRANCH"
        
        # 전체 태스크 JSON 저장
        echo "$TASKS_JSON" > nightwatch_bulk_tasks.json
        
        echo "💾 변경 사항 저장 중..."
        git add nightwatch_bulk_tasks.json
        git commit -m "plan: trigger NightWatch for bulk tasks (Series)" || true
        
        echo "🚀 GitHub에 푸시 중..."
        git push origin "$CURRENT_BRANCH"

        echo "🌙 NightWatch 루프를 깨우는 중..."
        gh workflow run "$WORKFLOW_NAME" --ref "$CURRENT_BRANCH" -f branch_name="$CURRENT_BRANCH"
    fi
fi

echo "✅ 완료! 성공적으로 NightWatch에게 작업을 넘겼습니다."
echo "→ 모니터링: gh run watch"
echo "→ 브라우저: gh run view --web"
