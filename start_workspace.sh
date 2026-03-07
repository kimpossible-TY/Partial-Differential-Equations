#!/bin/bash

# ==============================================================================
# 📱 Mac 로컬 문서 작성 & 실시간 모바일 서빙 스크립트 📱
# typst watch + python http.server 의 조합으로 아이폰에서 안정적으로 렌더링합니다.
# ==============================================================================

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

MAIN_FILE="main.typ"
HTTP_PORT=8000

# 1. 예외 처리: main.typ 파일이 없으면 즉시 종료
if [ ! -f "$MAIN_FILE" ]; then
    echo -e "❌ 오류: 현재 디렉토리에 'main.typ' 파일이 없습니다."
    exit 1
fi

echo -e "${BLUE}▶ 백그라운드 서버를 가동합니다...${NC}"

# 2. Typst 실시간 컴파일 실행 (저장 시 자동으로 main.pdf 갱신)
typst watch "$MAIN_FILE" --open /dev/null > /dev/null 2>&1 &
TYPST_PID=$!

# 3. Python 로컬 웹서버 실행 (viewer.html과 main.pdf 서빙)
python3 -m http.server $HTTP_PORT > /dev/null 2>&1 &
SERVER_PID=$!

# 4. 모바일 접속 주소 안내
TAILSCALE_IP=$(tailscale ip -4)
SERVER_URL="http://${TAILSCALE_IP}:${HTTP_PORT}/main.pdf"

# .env 파일이 있다면 로드하여 환경변수로 적용 (API Key 등)
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# 5. tmux 세션 시작 및 안내 메시지 출력 (화면 도배 방지)
tmux new-session -d -s pde_workspace 2>/dev/null || true

# 안내 메시지를 임시 셸 스크립트로 생성하여 실행 (문자열 깨짐 방지)
cat << EOF > .pde_welcome.sh
clear
echo -e "\n${GREEN}=====================================================${NC}"
echo -e "${GREEN}✨ 서버 구동 완료! Safari 북마크로 바로 열기 가능  ${NC}"
echo -e "   → ${BLUE}${SERVER_URL}${NC}"
echo -e "${GREEN}=====================================================${NC}"
echo -e "💡 작업 후 'exit'를 입력하면 모든 서버가 자동 종료됩니다.\n"
if [ -f .env ]; then
    echo -e "💡 .env 파일이 로드되었습니다. (API 키 적용됨)\n"
fi
EOF

tmux send-keys -t pde_workspace "bash .pde_welcome.sh && rm .pde_welcome.sh" C-m

tmux attach-session -t pde_workspace

# 6. tmux 종료 시 모든 백그라운드 서버 정리
echo -e "\n🛑 서버를 종료합니다..."
kill $TYPST_PID 2>/dev/null
kill $SERVER_PID 2>/dev/null
echo "수고하셨습니다! 👋"
