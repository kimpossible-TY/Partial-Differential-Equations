#!/bin/bash

# ==============================================================================
# 📱 Mac 로컬 문서 작성 & 실시간 모바일 서빙 스크립트 📱
# typst watch + python http.server 의 조합으로 아이폰에서 안정적으로 렌더링합니다.
# ==============================================================================

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

MAIN_FILE="main.typ"
HTTP_PORT=8000
WORKDIR="$(cd "$(dirname "$0")" && pwd)"

# .env 파일이 있다면 환경변수로 미리 로드 (API Key를 OpenClaw 등에 전달하기 위함)
if [ -f "$WORKDIR/.env" ]; then
    export $(cat "$WORKDIR/.env" | grep -v '^#' | xargs)
fi

# 1. 예외 처리: main.typ 파일이 없으면 즉시 종료
if [ ! -f "$WORKDIR/$MAIN_FILE" ]; then
    echo -e "❌ 오류: '$WORKDIR'에 'main.typ' 파일이 없습니다."
    exit 1
fi

# 2. 기존 tmux 세션이 있으면 먼저 정리
if tmux has-session -t pde_workspace 2>/dev/null; then
    echo -e "${BLUE}▶ 기존 pde_workspace 세션을 종료합니다...${NC}"
    tmux kill-session -t pde_workspace
    sleep 1
fi

echo -e "${BLUE}▶ tmux 세션을 생성하고 서버를 가동합니다...${NC}"

# 3. tmux 세션 생성 (detached)
tmux new-session -d -s pde_workspace -c "$WORKDIR" -x 220 -y 50
tmux set-option -t pde_workspace default-shell /bin/zsh

# 4. 각 서버를 tmux 창(window)에서 실행 — 세션과 수명을 같이함
# window 0: typst watch
tmux rename-window -t pde_workspace:0 'typst'
tmux set-window-option -t pde_workspace:0 remain-on-exit off
tmux send-keys -t pde_workspace:0 "typst watch '$MAIN_FILE' --open /dev/null" C-m

# window 1: python http server
tmux new-window -t pde_workspace -n 'http-server' -c "$WORKDIR"
tmux send-keys -t pde_workspace:1 "python3 -m http.server $HTTP_PORT --bind 127.0.0.1" C-m

# window 2: openclaw gateway
tmux new-window -t pde_workspace -n 'openclaw' -c "$WORKDIR"
tmux send-keys -t pde_workspace:2 "openclaw gateway run --bind loopback" C-m

# window 3: NightWatch 컨테이너 샌드박스 (OrbStack)
tmux new-window -t pde_workspace -n 'nightwatch' -c "$WORKDIR"
tmux send-keys -t pde_workspace:3 "docker compose up --build nightwatch-agent" C-m

# 5. 서버 구동 대기 (포트 준비될 때까지 최대 10초)
echo -e "${BLUE}▶ 서버 포트 준비 대기 중...${NC}"
for i in $(seq 1 10); do
    if curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:$HTTP_PORT/ | grep -qv "^0"; then
        echo -e "${GREEN}✔ HTTP 서버(포트 ${HTTP_PORT}) 준비 완료${NC}"
        break
    fi
    sleep 1
done

for i in $(seq 1 10); do
    if curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:18789/ | grep -qv "^000"; then
        echo -e "${GREEN}✔ OpenClaw(포트 18789) 준비 완료${NC}"
        break
    fi
    sleep 1
done

# 컨테이너 기동 확인
if docker compose ps --status running 2>/dev/null | grep -q 'nightwatch-agent'; then
    echo -e "${GREEN}✔ NightWatch 컨테이너 기동 확인${NC}"
else
    echo -e "${BLUE}▷ NightWatch 컨테이너 빌드 중 (첫 실행 시 시간이 걸릴 수 있어요)${NC}"
fi

# 6. Tailscale Serve HTTPS 프록시 연결
tailscale serve --yes --bg --https=443 http://127.0.0.1:$HTTP_PORT > /dev/null 2>&1
tailscale serve --yes --bg --https=18789 http://127.0.0.1:18789 > /dev/null 2>&1

# 7. 모바일 접속 주소 안내
TAILNET_DOMAIN=$(tailscale status --json | python3 -c 'import sys, json; print(json.load(sys.stdin).get("CertDomains", [""])[0])')
SERVER_URL="https://${TAILNET_DOMAIN}/main.pdf"
OPENCLAW_URL="https://${TAILNET_DOMAIN}:18789"

# 8. 안내 창(window 4)을 메인 뷰로 생성하여 attach
tmux new-window -t pde_workspace -n 'info' -c "$WORKDIR"
cat <<EOF > "$WORKDIR/.pde_welcome.sh"
clear
echo -e "\n${GREEN}=====================================================${NC}"
echo -e "${GREEN}✨ 서버 구동 완료! Safari 북마크로 바로 열기 가능  ${NC}"
echo -e "   → 📄 PDF 뷰어: ${BLUE}${SERVER_URL}${NC}"
echo -e "   → 💬 AI 챗봇(OpenClaw): ${BLUE}${OPENCLAW_URL}${NC}"
echo -e "${GREEN}=====================================================${NC}"
echo -e "💡 이 창을 닫으면(exit) 세션이 종료되고 모든 서버가 중지됩니다.\n"
if [ -f "$WORKDIR/.env" ]; then
    echo -e "💡 .env 파일이 로드되었습니다. (API 키 적용됨)\n"
fi
echo -e "💡 다른 창 보기: Ctrl+B → 숫자(0=typst, 1=http, 2=openclaw, 3=nightwatch)\n"

# exit 시 세션 전체 + 컨테이너 종료
cleanup() {
    echo -e "\n${RED}▶ 서비스를 종료합니다...${NC}"
    docker compose -f "$WORKDIR/docker-compose.yml" down 2>/dev/null
    rm -f "$WORKDIR/.pde_welcome.sh"
    tmux kill-session -t pde_workspace
}
trap cleanup EXIT

/bin/zsh -l
EOF
tmux send-keys -t pde_workspace:4 "bash '$WORKDIR/.pde_welcome.sh'" C-m

# 9. info 창으로 포커스 후 attach
tmux select-window -t pde_workspace:4
tmux attach-session -t pde_workspace

echo -e "\n🛑 pde_workspace 세션이 종료되었습니다. 수고하셨습니다! 👋"
