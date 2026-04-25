#!/bin/bash
# ==============================================================================
# 📱 PDE Workspace: Mac 로컬 문서 작성 & 실시간 모바일 서빙
# ==============================================================================

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

MAIN_FILE="Typst_project/main.typ"
HTTP_PORT=8000
WORKDIR="$(cd "$(dirname "$0")" && pwd)"
LOG_DIR="$WORKDIR/logs/start_workspace"
NIGHTWATCH_PORT="${OPENCLAW_GATEWAY_PORT:-18789}"
NIGHTWATCH_STARTUP_TIMEOUT="${NIGHTWATCH_STARTUP_TIMEOUT:-180}"
MLX_STARTUP_TIMEOUT="${MLX_STARTUP_TIMEOUT:-60}"

mkdir -p "$LOG_DIR"

wait_for_http_service() {
    local name="$1"
    local url="$2"
    local timeout="$3"
    local interval="${4:-2}"
    local elapsed=0

    echo -e "${BLUE}▶ ${name} 대기 중 (최대 ${timeout}초)...${NC}"
    while [ "$elapsed" -lt "$timeout" ]; do
        if curl -s -o /dev/null "$url"; then
            echo -e "${GREEN}✔ ${name} 준비 완료${NC}"
            return 0
        fi
        elapsed=$((elapsed + interval))
        echo -ne "\r   대기 중... (${elapsed}s/${timeout}s)"
        sleep "$interval"
    done
    echo ""
    return 1
}

compose_services_up() {
    local ps_output
    ps_output=$(docker compose -f "$WORKDIR/docker-compose.yml" ps --format json 2>/dev/null)
    [ -n "$ps_output" ] || return 1

    printf '%s\n' "$ps_output" | $PY -c '
import json, sys
lines = [line.strip() for line in sys.stdin if line.strip()]
if not lines:
    raise SystemExit(1)
records = [json.loads(line) for line in lines]
services = {record.get("Service"): record.get("State") for record in records}
required = {"openclaw-gateway", "nightwatch-agent"}
if not required.issubset(services):
    raise SystemExit(1)
if any(services[name] != "running" for name in required):
    raise SystemExit(1)
' >/dev/null 2>&1
}

nightwatch_gateway_ready() {
    docker compose -f "$WORKDIR/docker-compose.yml" logs --no-color --tail=200 openclaw-gateway 2>/dev/null | grep -q "\\[gateway\\] ready"
}

wait_for_nightwatch_service() {
    local timeout="$1"
    local interval="${2:-2}"
    local elapsed=0

    echo -e "${BLUE}▶ [Index 2] NightWatch 통합 센터 대기 중 (최대 ${timeout}초)...${NC}"
    while [ "$elapsed" -lt "$timeout" ]; do
        if compose_services_up && nightwatch_gateway_ready; then
            echo -e "${GREEN}✔ [Index 2] NightWatch 통합 센터 준비 완료${NC}"
            return 0
        fi
        elapsed=$((elapsed + interval))
        echo -ne "\r   대기 중... (${elapsed}s/${timeout}s)"
        sleep "$interval"
    done
    echo ""
    return 1
}

capture_nightwatch_diagnostics() {
    local diagnostics_file="$LOG_DIR/nightwatch-diagnostics.log"
    {
        echo "===== $(date '+%Y-%m-%d %H:%M:%S') docker compose ps ====="
        docker compose -f "$WORKDIR/docker-compose.yml" ps
        echo ""
        echo "===== $(date '+%Y-%m-%d %H:%M:%S') docker compose logs --tail=200 ====="
        docker compose -f "$WORKDIR/docker-compose.yml" logs --tail=200
    } > "$diagnostics_file" 2>&1
}

# ==============================================================================
# [STEP 1] 초기화 및 Mac 키체인 잠금 해제 🔑
# ==============================================================================
echo -e "${BLUE}▶ Docker 인증 정보를 가져오기 위해 Mac 키체인 잠금을 해제합니다.${NC}"
echo -n "Mac 로그인 비밀번호 입력: "
read -s KEYCHAIN_PASS
echo ""

if security unlock-keychain -p "$KEYCHAIN_PASS" ~/Library/Keychains/login.keychain-db 2>/dev/null; then
    echo -e "${GREEN}✔ 키체인 잠금이 해제되었습니다.${NC}"
else
    echo -e "${RED}❌ 실패: 비밀번호가 틀렸습니다. 스크립트를 중단합니다.${NC}"
    exit 1
fi

# ==============================================================================
# [STEP 2] 환경 변수 로드 및 프로젝트 검증 ⚙️
# ==============================================================================
if [ -f "$WORKDIR/.env" ]; then
    export $(cat "$WORKDIR/.env" | grep -v '^#' | xargs)
fi
export OPENCLAW_CONFIG_DIR="$WORKDIR/.openclaw"
NIGHTWATCH_PORT="${OPENCLAW_GATEWAY_PORT:-$NIGHTWATCH_PORT}"

# uv 환경 설정 (강제 사용)
PY="uv run python"
echo -e "${GREEN}✔ uv 환경을 사용하여 실행합니다.${NC}"

# ==============================================================================
# [STEP 3] 프로세스 정리 및 준비 🧹
# ==============================================================================
echo -e "${BLUE}▶ 기존 프로세스 정리 중...${NC}"

# 1. Docker Compose 기반의 기존 컨테이너 및 네트워크 완벽 정리
if [ -f "$WORKDIR/docker-compose.yml" ]; then
    echo -e "${BLUE}▶ 기존 Docker 컨테이너를 내립니다...${NC}"
    docker compose -f "$WORKDIR/docker-compose.yml" down -v --remove-orphans > /dev/null 2>&1
fi

# 3. 환경 변수 설정
export OC_VERSION=$(npm view openclaw version 2>/dev/null || echo "latest")

pkill -9 -f "Runner.Listener" > /dev/null 2>&1
pkill -9 -f "Runner.Worker" > /dev/null 2>&1
pkill -f "typst watch" > /dev/null 2>&1
pkill -f "mlx_lm server" > /dev/null 2>&1
pkill -f "mlx_lm.server" > /dev/null 2>&1

MLX_PID=$(lsof -ti:8080)
if [ -n "$MLX_PID" ]; then
    kill -9 $MLX_PID 2>/dev/null
fi

echo -e "${BLUE}▶ GitHub Runner 세션 정리를 위해 잠시 대기합니다...${NC}"
sleep 5

chmod +x "$WORKDIR/Tools/patch_openclaw_config.py"
$PY "$WORKDIR/Tools/patch_openclaw_config.py" "$WORKDIR"

# ==============================================================================
# [STEP 4] Tmux 세션 생성 및 서비스 구동 🚀
# ==============================================================================
echo -e "${BLUE}▶ tmux 세션을 생성하고 서버를 가동합니다...${NC}"

# 0. Typst
tmux new-session -d -s pde_workspace -n 'typst' -c "$WORKDIR" "zsh -c \"typst watch '$MAIN_FILE' --open /dev/null 2>&1 | tee '$LOG_DIR/typst.log'\""
tmux set-option -t pde_workspace default-shell /bin/zsh

# 1. HTTP Server
tmux new-window -t pde_workspace:1 -n 'http-server' -c "$WORKDIR" "zsh -c \"$PY -m http.server $HTTP_PORT --bind 127.0.0.1 2>&1 | tee '$LOG_DIR/http-server.log'\""

# 2. OpenClaw
tmux new-window -t pde_workspace:2 -n 'nightwatch' -c "$WORKDIR" "zsh -c \"export OC_VERSION='$OC_VERSION'; export OPENCLAW_GATEWAY_PORT='$NIGHTWATCH_PORT'; { docker compose up --build -d; docker compose ps; docker compose logs -f; } 2>&1 | tee '$LOG_DIR/nightwatch.log'\""
tmux set-window-option -t pde_workspace:2 remain-on-exit on

# 3. GitHub Runner
tmux new-window -t pde_workspace:3 -n 'github-runner' -c "$WORKDIR/actions-runner" "zsh -c \"./run.sh 2>&1 | tee '$LOG_DIR/github-runner.log'\""

# 4. Local MLX-LM
tmux new-window -t pde_workspace:4 -n 'mlx-server' -c "$WORKDIR" "zsh -c \"$PY -m mlx_lm server --model mlx-community/Qwen2.5-Coder-3B-Instruct-4bit --port 8080 2>&1 | tee '$LOG_DIR/mlx-server.log'\""
tmux set-window-option -t pde_workspace:4 remain-on-exit on

# 5. Info Panel
tmux new-window -t pde_workspace:5 -n 'info' -c "$WORKDIR" "zsh '$WORKDIR/Tools/show_info.sh'"

# ==============================================================================
# [STEP 5] 서비스 구동 완료 대기 및 검증 ⏳
# ==============================================================================
echo -e "${BLUE}▶ 모든 서비스 기동 확인 중...${NC}"

ERROR_FOUND=0

# 0. Typst Check
sleep 2
if pgrep -f "typst watch" > /dev/null; then
    echo -e "${GREEN}✔ [Index 0] Typst Watcher 가동 중${NC}"
else
    echo -e "${RED}❌ [Index 0] Typst Watcher 기동 실패${NC}"
    ERROR_FOUND=1
fi

# 1. HTTP Server Check
if curl --retry 5 --retry-delay 1 -s -o /dev/null http://127.0.0.1:$HTTP_PORT/; then
    echo -e "${GREEN}✔ [Index 1] HTTP 서버 준비 완료${NC}"
else
    echo -e "${RED}❌ [Index 1] HTTP 서버 응답 없음${NC}"
    ERROR_FOUND=1
fi

# 2. NightWatch (OpenClaw) Check
if wait_for_nightwatch_service "$NIGHTWATCH_STARTUP_TIMEOUT"; then
    OC_READY=1
else
    echo -e "${RED}❌ [Index 2] NightWatch 통합 센터가 ${NIGHTWATCH_STARTUP_TIMEOUT}초 내에 준비되지 않았습니다.${NC}"
    capture_nightwatch_diagnostics
    echo -e "진단 로그: ${BLUE}$LOG_DIR/nightwatch-diagnostics.log${NC}"
    ERROR_FOUND=1
fi

# 3. GitHub Runner Check
if pgrep -f "Runner.Listener" > /dev/null; then
    echo -e "${GREEN}✔ [Index 3] GitHub Runner 연결됨${NC}"
else
    echo -e "${RED}❌ [Index 3] GitHub Runner 프로세스 미감지${NC}"
    ERROR_FOUND=1
fi

# 4. MLX-LM Server Check
if wait_for_http_service "[Index 4] Local MLX-LM 서버(Qwen2.5)" "http://127.0.0.1:8080/v1/models" "$MLX_STARTUP_TIMEOUT"; then
    MLX_READY=1
else
    echo -e "${RED}❌ [Index 4] MLX 서버가 ${MLX_STARTUP_TIMEOUT}초 내에 응답하지 않습니다.${NC}"
    ERROR_FOUND=1
fi

# ==============================================================================
# [STEP 6] 외부 노출 및 진입/종료
# ==============================================================================
if [ "$ERROR_FOUND" -eq 1 ]; then
    echo -e "\n${RED}🚨 오류가 발견되었습니다. 서비스를 중단하고 로그를 확인합니다.${NC}"
    echo -e "상세 로그 디렉토리: ${BLUE}$LOG_DIR${NC}"
   # tmux kill-session -t pde_workspace
   # exit 1
fi

tailscale serve --yes --bg --https=443 http://127.0.0.1:$HTTP_PORT > /dev/null 2>&1
tailscale serve --yes --bg --https="$NIGHTWATCH_PORT" "http://127.0.0.1:$NIGHTWATCH_PORT" > /dev/null 2>&1

TAILNET_DOMAIN=$(tailscale status --json | $PY -c 'import sys, json; print(json.load(sys.stdin).get("CertDomains", [""])[0])')
SERVER_URL="https://${TAILNET_DOMAIN}/Typst_project/main.pdf"
OPENCLAW_URL="https://${TAILNET_DOMAIN}:$NIGHTWATCH_PORT"
export OC_VERSION SERVER_URL OPENCLAW_URL WORKDIR

echo -e "\n${GREEN}✨ 모든 기동 프로세스가 성공적으로 완료되었습니다!${NC}"
echo -e "자동으로 작업 공간(tmux: info)으로 진입합니다."
sleep 1

tmux attach-session -t pde_workspace
