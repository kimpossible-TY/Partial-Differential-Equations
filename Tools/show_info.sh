#!/bin/zsh
# ------------------------------------------------------------------------------
# 🖥️ NightWatch Status & Info Display Script
# ------------------------------------------------------------------------------

: "${OC_VERSION:=latest}"
: "${SERVER_URL:=https://your-domain.ts.net/main.pdf}"
: "${OPENCLAW_URL:=https://your-domain.ts.net:18789}"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

clear
echo -e "${BLUE}=====================================================${NC}"
echo -e " 🏗️  NightWatch 작업 환경을 구성하고 있습니다..."
echo -e " 📦 타겟 버전: OpenClaw v${OC_VERSION}"
echo -e "${BLUE}=====================================================${NC}"
echo -e "\n${GREEN}=====================================================${NC}"
echo -e "${GREEN} ✨ 모든 서버 구동 완료! (v${OC_VERSION} 적용됨) ${NC}"
echo -e "   → 📄 PDF 뷰어: ${BLUE}${SERVER_URL}${NC}"
echo -e "   → 💬 AI 챗봇(OpenClaw): ${BLUE}${OPENCLAW_URL}${NC}"
echo -e "${GREEN}=====================================================${NC}"
echo -e " 💡 창을 이동하려면 tmux 단축키(Ctrl+B, 번호)를 사용하세요.\n"

cleanup() {
    if [[ -n "$TMUX" ]]; then
        local session_name
        session_name=$(tmux display-message -p '#S' 2>/dev/null)
        if [[ -n "$session_name" ]]; then
            tmux kill-session -t "$session_name" 2>/dev/null
        fi
    fi
}

trap cleanup EXIT HUP INT TERM

/bin/zsh -l
