#!/bin/bash
# ==============================================================================
# 📱 PDE Workspace: Mac 로컬 문서 작성 & 실시간 모바일 서빙
#
# [주요 파이프라인]
# - Typst: 실시간 문서 컴파일 (watch)
# - Python HTTP: 렌더링된 PDF 로컬 서빙
# - Docker: NightWatch 통합 센터 컨테이너 구동
# - Tailscale: 외부 기기용 안전한 HTTPS 터널 프록시 연결
# ==============================================================================

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

MAIN_FILE="Typst_project/main.typ"
HTTP_PORT=8000
WORKDIR="$(cd "$(dirname "$0")" && pwd)"

# ==============================================================================
# [STEP 1] 초기화 및 Mac 키체인 잠금 해제 🔑
# ==============================================================================
echo -e "${BLUE}▶ Docker 인증 정보를 가져오기 위해 Mac 키체인 잠금을 해제합니다.${NC}"
echo -n "Mac 로그인 비밀번호 입력: "
read -s KEYCHAIN_PASS  # -s 옵션으로 입력 중인 비번이 화면에 보이지 않게 처리
echo ""

# 입력받은 비밀번호로 키체인 해제 시도
if security unlock-keychain -p "$KEYCHAIN_PASS" ~/Library/Keychains/login.keychain-db 2>/dev/null; then
    echo -e "${GREEN}✔ 키체인 잠금이 해제되었습니다.${NC}"
else
    echo -e "${RED}❌ 실패: 비밀번호가 틀렸습니다. 스크립트를 중단합니다.${NC}"
    exit 1
fi

# ==============================================================================
# [STEP 2] 환경 변수 로드 및 프로젝트 검증 ⚙️
# ==============================================================================
# .env 파일이 있다면 환경변수로 미리 로드 (API Key를 OpenClaw 등에 전달하기 위함)
if [ -f "$WORKDIR/.env" ]; then
    export $(cat "$WORKDIR/.env" | grep -v '^#' | xargs)
fi

# 호스트 CLI가 프로젝트 디렉토리의 설정을 사용하도록 강제
export OPENCLAW_CONFIG_DIR="$WORKDIR/.openclaw"

# 예외 처리: main.typ 파일이 없으면 즉시 종료
if [ ! -f "$WORKDIR/$MAIN_FILE" ]; then
    echo -e "❌ 오류: '$WORKDIR'에 'main.typ' 파일이 없습니다."
    exit 1
fi

# ==============================================================================
# [STEP 3] 버전 체크 및 기존 프로세스 정리 🧹
# ==============================================================================
echo -e "${BLUE}▶ OpenClaw 최신 버전을 확인 중입니다...${NC}"
# npm이 설치되어 있어야 함. 실패 시 기본값 'latest'
LATEST_OC_VER=$(npm view openclaw version 2>/dev/null || echo "latest")
export OC_VERSION=$LATEST_OC_VER
echo -e "${GREEN}✔ 확인된 버전: $OC_VERSION${NC}"

# 기존 tmux 세션 종료
if tmux has-session -t pde_workspace 2>/dev/null; then
    echo -e "${BLUE}▶ 기존 pde_workspace 세션을 종료합니다...${NC}"
    tmux kill-session -t pde_workspace
    sleep 1
fi

# 로컬 백그라운드 Gateway 프로세스 종료
openclaw gateway stop > /dev/null 2>&1
killall openclaw > /dev/null 2>&1

# OpenClaw 컨테이너 환경 준비 (원본 보안 패치)
echo -e "${BLUE}▶ OpenClaw 컨테이너 보안 패치 중...${NC}"
chmod +x "$WORKDIR/Tools/patch_openclaw_config.py"
python3 "$WORKDIR/Tools/patch_openclaw_config.py" "$WORKDIR"

# ==============================================================================
# [STEP 4] Tmux 세션 생성 및 서비스 구동 🚀
# ==============================================================================
echo -e "${BLUE}▶ tmux 세션을 생성하고 서버를 가동합니다...${NC}"

# tmux 세션 생성 (detached) 및 Window 0: Typst 실시간 문서 컴파일러
tmux new-session -d -s pde_workspace -n 'typst' -c "$WORKDIR" -x 220 -y 50 "zsh -c \"typst watch '$MAIN_FILE' --open /dev/null\""
tmux set-option -t pde_workspace default-shell /bin/zsh
tmux set-window-option -t pde_workspace:0 remain-on-exit off

# ------------------------------------------------------------------------------
# Window 1: 로컬 정적 파일 서버 (PDF 서빙)
# ------------------------------------------------------------------------------
tmux new-window -t pde_workspace -n 'http-server' -c "$WORKDIR" "zsh -c \"python3 -m http.server $HTTP_PORT --bind 127.0.0.1\""

# ------------------------------------------------------------------------------
# Window 2: NightWatch 통합 센터 컨테이너 (Docker Compose)
# ------------------------------------------------------------------------------
tmux new-window -t pde_workspace -n 'nightwatch' -c "$WORKDIR" "zsh -c \"export OC_VERSION=$OC_VERSION; docker compose up --build -d && docker compose logs -f\""

# ------------------------------------------------------------------------------
# Window 3: GitHub Self-hosted Runner
# ------------------------------------------------------------------------------
tmux new-window -t pde_workspace -n 'github-runner' -c "$WORKDIR/actions-runner" "zsh -c \"./run.sh\""

# ------------------------------------------------------------------------------
# Window 4: Local MLX-LM Server (Qwen2.5-Coder)
# ------------------------------------------------------------------------------
tmux new-window -t pde_workspace -n 'mlx-server' -c "$WORKDIR" "zsh -c \"python3 -m mlx_lm.server --model mlx-community/Qwen2.5-Coder-3B-Instruct-4bit --port 8080\""

# ==============================================================================
# [STEP 5] 서비스 구동 완료 대기 ⏳
# ==============================================================================
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
        echo -e "${GREEN}✔ NightWatch 통합 센터(포트 18789) 준비 완료${NC}"
        break
    fi
    sleep 1
done

# ==============================================================================
# [STEP 6] Tailscale 보안 터널 프록시 연결 🌐
# ==============================================================================
tailscale serve --yes --bg --https=443 http://127.0.0.1:$HTTP_PORT > /dev/null 2>&1
tailscale serve --yes --bg --https=18789 http://127.0.0.1:18789 > /dev/null 2>&1

# ==============================================================================
# [STEP 7] 모바일 접속 URL 생성 📱
# ==============================================================================
TAILNET_DOMAIN=$(tailscale status --json | python3 -c 'import sys, json; print(json.load(sys.stdin).get("CertDomains", [""])[0])')
SERVER_URL="https://${TAILNET_DOMAIN}/Typst_project/main.pdf"
OPENCLAW_URL="https://${TAILNET_DOMAIN}:18789"

# ==============================================================================
# [STEP 8] 정보 패널 생성 및 작업 공간 진입 💻
# ==============================================================================
export OC_VERSION SERVER_URL OPENCLAW_URL WORKDIR

# ------------------------------------------------------------------------------
# Window 5: 전용 정보 패널 스크립트 구동 (show_info.sh)
# ------------------------------------------------------------------------------
tmux new-window -t pde_workspace -n 'info' -c "$WORKDIR" "zsh '$WORKDIR/Tools/show_info.sh'"

# info 창으로 포커스 후 attach
tmux select-window -t pde_workspace:5
tmux attach-session -t pde_workspace

echo -e "\n🛑 pde_workspace 세션이 종료되었습니다. 수고하셨습니다! 👋"
