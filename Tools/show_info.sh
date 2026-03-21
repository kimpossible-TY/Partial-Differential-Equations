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

MAX_RETRIES=30
RETRY_COUNT=0

# 한계점(Timeout)이 존재하는 안전한 루프
while ! curl -s localhost:18789 > /dev/null; do
    if [ "$RETRY_COUNT" -ge "$MAX_RETRIES" ]; then
        echo -e "\n\n${RED}❌ 치명적 오류: OpenClaw 통합 센터(포트 18789)가 응답하지 않습니다.${NC}"
        echo -e "${RED}컨테이너 빌드가 실패했거나 내부 런타임 에러가 발생했습니다.${NC}"
        echo -e "터미널에서 ${BLUE}'docker compose logs openclaw-gateway'${NC}를 실행하여 정확한 원인을 확인하십시오."
        # 사용자가 에러를 읽을 수 있도록 잠시 대기 후 강제 종료
        sleep 5
        exit 1
    fi
    
    echo -ne "\r 🔨 컨테이너 빌드 및 가동 중... 잠시만 기다려 주세요 (${RETRY_COUNT}/${MAX_RETRIES})"
    sleep 2
    ((RETRY_COUNT++))
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
    tmux kill-session -t pde_workspace 2>/dev/null
}
trap cleanup EXIT

/bin/zsh -l

