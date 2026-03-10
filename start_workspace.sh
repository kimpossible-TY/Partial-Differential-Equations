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
# (127.0.0.1로 바인딩하여 안전하게 실행)
python3 -m http.server $HTTP_PORT --bind 127.0.0.1 > /dev/null 2>&1 &
SERVER_PID=$!

# 3.1. OpenClaw WebChat Gateway 실행 (백그라운드)
# (--bind loopback 을 사용하여 안전하게 실행)
openclaw gateway run --bind loopback > /dev/null 2>&1 &
OPENCLAW_PID=$!

# 3.2. Tailscale Serve HTTPS 프록시 연결 (경고창 방지)
tailscale serve --yes --bg --https=443 http://127.0.0.1:$HTTP_PORT > /dev/null 2>&1
tailscale serve --yes --bg --https=18789 http://127.0.0.1:18789 > /dev/null 2>&1

# 4. 모바일 접속 주소 안내 (HTTPS 최적화)
TAILNET_DOMAIN=$(tailscale status --json | python3 -c 'import sys, json; print(json.load(sys.stdin).get("CertDomains", [""])[0])')
SERVER_URL="https://${TAILNET_DOMAIN}/main.pdf"
OPENCLAW_URL="https://${TAILNET_DOMAIN}:18789"

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
echo -e "   → 📄 PDF 뷰어: ${BLUE}${SERVER_URL}${NC}"
echo -e "   → 💬 AI 챗봇(OpenClaw): ${BLUE}${OPENCLAW_URL}${NC}"
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
kill $OPENCLAW_PID 2>/dev/null
echo "수고하셨습니다! 👋"
