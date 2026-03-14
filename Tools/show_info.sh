#!/bin/zsh
# ------------------------------------------------------------------------------
# 🖥️ NightWatch Status & Info Display Script
# ------------------------------------------------------------------------------

# 환경 변수 체크 (부모 스크립트에서 export 되어야 함)
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

while ! curl -s localhost:18789 > /dev/null; do
    echo -ne "\r 🔨 컨테이너 빌드 및 가동 중... 잠시만 기다려 주세요"
    sleep 2
done

clear
echo -e "\n${GREEN}=====================================================${NC}"
echo -e "${GREEN} ✨ 모든 서버 구동 완료! (v${OC_VERSION} 적용됨) ${NC}"
echo -e "   → 📄 PDF 뷰어: ${BLUE}${SERVER_URL}${NC}"
echo -e "   → 💬 AI 챗봇(OpenClaw): ${BLUE}${OPENCLAW_URL}${NC}"
echo -e "${GREEN}=====================================================${NC}"
echo -e " 💡 이 창(exit)을 닫으면 모든 서비스가 자동 종료됩니다.\n"

# 종료 트랩 (부모 세션 정리를 위함)
cleanup() {
    echo -e "\n${RED}▶ 서비스를 종료합니다...${NC}"
    # 부모 세션에 종료 신호를 보내기 위해 tmux 사용
    tmux kill-session -t pde_workspace
}
trap cleanup EXIT

/bin/zsh -l

