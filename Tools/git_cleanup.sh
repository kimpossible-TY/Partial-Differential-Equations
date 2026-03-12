#!/bin/bash
# git-cleanup: 안전하게 머지된 로컬 브랜치만 청소하는 스크립트

# 1. 기본 브랜치(main 또는 master) 감지
DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
if [ -z "$DEFAULT_BRANCH" ]; then
    # 감지 실패 시 흔히 사용되는 이름 확인
    if git show-ref --verify --quiet refs/heads/main; then
        DEFAULT_BRANCH="main"
    elif git show-ref --verify --quiet refs/heads/master; then
        DEFAULT_BRANCH="master"
    else
        DEFAULT_BRANCH="main"
    fi
fi

echo "🚀 [1/3] $DEFAULT_BRANCH 브랜치로 전환 및 최신화 중..."
git checkout "$DEFAULT_BRANCH"
git pull origin "$DEFAULT_BRANCH"

echo "🔍 [2/3] 원격에서 사라진 브랜치 정보 정리(Prune) 중..."
git remote prune origin

echo "🧹 [3/3] 머지 완료된 로컬 브랜치 삭제 중..."
# 현재 브랜치(*), 기본 브랜치들(main, master, develop)을 제외하고
# 이미 머지된 브랜치 목록을 가져와서 소문자 -d (안전 삭제)로 처리
MERGED_BRANCHES=$(git branch --merged | grep -v "^\*" | grep -vE "^(\s*(main|master|develop)\s*$)")

if [ -z "$MERGED_BRANCHES" ]; then
    echo "✨ 삭제할 머지된 브랜치가 없습니다."
else
    echo "$MERGED_BRANCHES" | xargs -n 1 git branch -d
    echo "✅ 정리 완료!"
fi
