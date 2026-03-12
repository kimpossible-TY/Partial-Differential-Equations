#!/bin/bash
# ==============================================================================
# Project NightWatch — Handoff Automation Script
# 📋 TASKS.md의 내용을 기반으로 자율 실행 루프를 자동으로 트리거합니다.
# ==============================================================================

set -e

# 설정
TASKS_FILE="TASKS.md"
WORKFLOW_NAME="NightWatch Autonomous Loop"

# 1. TASKS.md 확인
if [ ! -f "$TASKS_FILE" ]; then
    echo "❌ 에러: $TASKS_FILE 파일을 찾을 수 없습니다."
    exit 1
fi

# 2. 첫 번째 대기 중인 태스크 제목 추출
# 포맷: ## [TAG] 제목
NEXT_TASK=$(grep -m 1 "^## \[" "$TASKS_FILE" || true)

if [ -z "$NEXT_TASK" ]; then
    echo "ℹ️ 알림: 대기 중인 태스크가 없습니다. TASKS.md를 확인해주세요."
    exit 0
fi

# 제목 정제 (## [FLASH] -> [FLASH])
TITLE=$(echo "$NEXT_TASK" | sed 's/^## //')

echo "🔍 발견된 태스크: $TITLE"

# 3. Git 및 브랜치 상태 확인
CURRENT_BRANCH=$(git branch --show-current)
echo "🌿 현재 브랜치: $CURRENT_BRANCH"

# 브랜치 관리 로직
if [ "$CURRENT_BRANCH" == "main" ]; then
    echo "⚠️  경고: 현재 'main' 브랜치에 있습니다. 자율 작업은 별도의 브랜치에서 진행해야 합니다."
    read -p "🆕 새로운 브랜치 이름 (nightwatch/ 이후의 이름 입력): " BRANCH_SUFFIX
    NEW_BRANCH="nightwatch/$BRANCH_SUFFIX"
    echo "🌱 새 브랜치 생성 및 전환: $NEW_BRANCH"
    git checkout -b "$NEW_BRANCH"
    CURRENT_BRANCH="$NEW_BRANCH"
else
    read -p "❓ 새로운 작업을 위한 브랜치를 생성하시겠습니까? (y/n, 기본 n): " CREATE_NEW
    if [[ "$CREATE_NEW" =~ ^[Yy]$ ]]; then
        read -p "🆕 새로운 브랜치 이름 (nightwatch/ 이후의 이름 입력): " BRANCH_SUFFIX
        NEW_BRANCH="nightwatch/$BRANCH_SUFFIX"
        echo "🌱 새 브랜치 생성 및 전환: $NEW_BRANCH"
        git checkout -b "$NEW_BRANCH"
        CURRENT_BRANCH="$NEW_BRANCH"
    else
        echo "✅ 현재 브랜치($CURRENT_BRANCH)를 그대로 유지합니다."
    fi
fi

# 4. 변경 사항 커밋 및 푸시
echo "💾 변경 사항 저장 중..."
git add "$TASKS_FILE"

# 만약 다른 파일들도 변경되었다면 포함할지 확인 (기본적으로는 TASKS.md만 안전하게)
# git add . # 모든 변경사항을 포함하려면 이 주석을 해제하세요.

if git diff --cached --quiet; then
    echo "ℹ️ 변경 사항 없음 — 푸시를 시도합니다."
else
    git commit -m "plan: trigger NightWatch for '$TITLE'"
fi

echo "🚀 GitHub에 푸시 중..."
git push origin "$CURRENT_BRANCH"

# 5. NightWatch Workflow 트리거
echo "🌙 NightWatch 루프를 깨우는 중..."
gh workflow run "$WORKFLOW_NAME" --ref "$CURRENT_BRANCH"

echo "✅ 완료! 성공적으로 NightWatch에게 작업을 넘겼습니다."
echo "→ 모니터링: gh run watch"
echo "→ 브라우저: gh run view --web"
