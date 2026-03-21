import json
import os
import subprocess
import sys
import secrets
import re
import shlex
import time
import urllib.request

try:
    import tiktoken
except ImportError:
    tiktoken = None

# --- 1. Budget Watchdog & 2. Adaptive Throttling ---
class RateLimitWatchdog:
    def __init__(self, tpm_limit=4_000_000, rpm_limit=300, max_budget=10_000_000):
        self.tpm_limit = tpm_limit
        self.rpm_limit = rpm_limit
        self.max_budget = max_budget
        
        self.total_tokens_used = 0
        self.minute_start = time.time()
        self.requests_this_minute = 0
        self.tokens_this_minute = 0
        if tiktoken:
            try:
                self.tokenizer = tiktoken.get_encoding("cl100k_base")
            except Exception:
                self.tokenizer = None
        else:
            self.tokenizer = None

    def estimate_tokens(self, text: str) -> int:
        if self.tokenizer:
            return len(self.tokenizer.encode(text))
        return len(text) // 4  # Fallback approximation

    def check_and_throttle(self, estimated_task_tokens: int):
        now = time.time()
        if now - self.minute_start > 60:
            self.minute_start = now
            self.requests_this_minute = 0
            self.tokens_this_minute = 0

        # Halt if we exceed the global session budget
        if self.total_tokens_used + estimated_task_tokens > self.max_budget:
            print(f"🚨 Watchdog Alert: Task exceeds global budget ({self.max_budget} tokens). Halting execution.")
            sys.exit(1)

        # Adaptive Throttling: Check 80% threshold
        if (self.requests_this_minute >= self.rpm_limit * 0.8) or \
           (self.tokens_this_minute + estimated_task_tokens >= self.tpm_limit * 0.8):
            sleep_time = max(0, 60 - (now - self.minute_start)) + 2
            print(f"⚠️ [Throttling] Approaching 80% of RPM/TPM limit. Delaying execution by {sleep_time:.1f}s...")
            time.sleep(sleep_time)
            
            # Reset minute trackers after sleep
            self.minute_start = time.time()
            self.requests_this_minute = 0
            self.tokens_this_minute = 0

        self.requests_this_minute += 1
        self.tokens_this_minute += estimated_task_tokens
        self.total_tokens_used += estimated_task_tokens

watchdog = RateLimitWatchdog()

# --- [3단계 추가] 경량 모델을 활용한 선제적 컨텍스트 가지치기 ---
def prune_context_via_lite(task_body: str, api_key: str, threshold: int = 30000) -> str:
    # 텍스트가 임계치보다 작으면 원본을 그대로 유지
    if len(task_body) < threshold:
        return task_body
        
    print("✂️ [Pruning] 컨텍스트가 너무 방대합니다. Gemini Flash Lite를 사용하여 핵심 구조만 압축합니다...")
    # OpenClaw 설정의 LITE 모델과 통일
    url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-flash-lite-preview:generateContent?key={api_key}"
    
    # 너무 큰 텍스트로 압축기 자체가 터지는 것을 막기 위해 최대 10만 자로 자름
    safe_body = task_body[:100000]
    prompt = (
        "You are an expert context optimizer. Summarize the following project context, logs, or file contents. "
        "Keep all essential code structures, file paths, and error messages, but remove redundant logs, "
        "whitespace, and irrelevant comments to minimize token usage for the next agent.\n\n"
        f"{safe_body}"
    )

    data = {
        "contents": [{"parts": [{"text": prompt}]}]
    }
    
    req = urllib.request.Request(
        url, 
        data=json.dumps(data).encode('utf-8'), 
        headers={'Content-Type': 'application/json'}
    )
    
    try:
        with urllib.request.urlopen(req) as response:
            result = json.loads(response.read().decode())
            pruned_text = result['candidates'][0]['content']['parts'][0]['text']
            print(f"✅ [Pruning] 압축 완료: 원본 {len(task_body)}자 -> 압축 {len(pruned_text)}자")
            return pruned_text
    except Exception as e:
        print(f"⚠️ [Pruning] 압축 실패. 정규식을 통한 강제 공백 제거로 대체합니다: {e}")
        # API 호출 실패 시 무식하지만 확실한 정규식 압축 (빈 줄 및 연속된 공백 제거)
        return re.sub(r'\n\s*\n', '\n', task_body)

# --- 3. 모델 라우팅 (방어적 용도로 유지) ---
def route_model_by_context(tag: str, task_body: str, estimated_tokens: int) -> str:
    if estimated_tokens > 30_000 and tag == "PRO":
        print("📉 [Router] Massive context detected (>30k tokens). Downgrading PRO to FLASH to preserve budget.")
        return "FLASH"
    if estimated_tokens > 100_000:
        print("✂️ [Router] Context exceeds 100k tokens. Forcing LITE and truncating body...")
        return "LITE"
    return tag

def run_command(command, shell=True, env=None):
    current_env = os.environ.copy()
    if env:
        current_env.update(env)

    process = subprocess.Popen(
        command,
        shell=shell,
        env=current_env,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True
    )

    output = []
    for line in process.stdout:
        print(line, end="")
        output.append(line)

    process.wait()
    if process.returncode != 0:
        print(f"❌ Command failed with return code {process.returncode}")
    return process.returncode, "".join(output)

def patch_openclaw_config(gemini_api_key, tag, openclaw_gateway_token=None):
    path = '.openclaw_config/openclaw.json'
    if not os.path.exists(path):
        print(f"⚠️ {path} 를 찾을 수 없습니다. 패치를 건너뜜")
        return False

    try:
        with open(path, 'r') as f:
            config = json.load(f)

        config['gateway'] = config.get('gateway', {})
        config['gateway']['remote'] = {'url': 'ws://127.0.0.1:18789'}
        config['gateway']['mode'] = 'remote'

        if openclaw_gateway_token:
            config['gateway']['auth'] = {
                "mode": "token",
                "token": openclaw_gateway_token
            }
        else:
            config.pop('auth', None)

        model_map = {
            'PRO': 'google/gemini-3.1-pro-preview',
            'FLASH': 'google/gemini-3-flash-preview',
            'LITE': 'google/gemini-3.1-flash-lite-preview'
        }
        target_model = model_map.get(tag, 'google/gemini-3-flash-preview')
        print(f"🎯 타겟 모델 설정: {target_model} (Tag: {tag})")

        agents_config = config.setdefault('agents', {})
        defaults = agents_config.setdefault('defaults', {})
        model_defaults = defaults.setdefault('model', {})
        model_defaults['primary'] = target_model

        models_config = config.setdefault('models', {})
        providers = models_config.setdefault('providers', {})
        google_prov = providers.setdefault('google', {})
        google_prov['baseUrl'] = 'https://generativelanguage.googleapis.com/v1beta'
        google_prov['apiKey'] = gemini_api_key

        # --- [2단계 추가] OpenClaw Gateway 수준의 재시도(Retry) 파라미터 강제 주입 ---
        google_prov['retryParams'] = {
            "maxRetries": 5,
            "initialDelayMs": 5000,
            "backoffMultiplier": 2,
            "maxDelayMs": 120000,
            "retryableStatusCodes": [429, 500, 502, 503, 504]
        }
        # ------------------------------------------------------------------------

        google_models = google_prov.setdefault('models', [])
        google_models = [m for m in google_models if m.get('id') != target_model]
        google_models.insert(0, {'id': target_model, 'name': target_model.split('/')[-1]})
        google_prov['models'] = google_models

        old_ws = config.get('agents', {}).get('defaults', {}).get('workspace')
        if old_ws:
            config_str = json.dumps(config)
            config = json.loads(config_str.replace(old_ws, '/workspace'))

        with open(path, 'w') as f:
            json.dump(config, f, indent=2)
        print("✅ OpenClaw 설정 패치 완료")
        return True
    except Exception as e:
        print(f"❌ 설정 패치 중 오류 발생: {e}")
        return False

def elevate_agent_permissions():
    agents_dir = 'agents'
    if not os.path.exists(agents_dir):
        return

    for agent_id in os.listdir(agents_dir):
        manifest_path = os.path.join(agents_dir, agent_id, 'manifest.yaml')
        if os.path.exists(manifest_path):
            try:
                with open(manifest_path, 'r') as f:
                    content = f.read()

                new_content = content.replace(
                    '    write:\n      - "../../TASKS.md"',
                    '    write:\n      - "../../**/*"'
                )

                with open(manifest_path, 'w') as f:
                    f.write(new_content)
                print(f"🔓 에이전트 권한 승격 완료: {agent_id}")
            except Exception as e:
                print(f"⚠️ 에이전트 {agent_id} 권한 승격 중 오류: {e}")

def restore_agent_permissions():
    agents_dir = 'agents'
    if not os.path.exists(agents_dir):
        return

    for agent_id in os.listdir(agents_dir):
        manifest_path = os.path.join(agents_dir, agent_id, 'manifest.yaml')
        if os.path.exists(manifest_path):
            try:
                with open(manifest_path, 'r') as f:
                    content = f.read()

                new_content = content.replace(
                    '    write:\n      - "../../**/*"',
                    '    write:\n      - "../../TASKS.md"'
                )

                with open(manifest_path, 'w') as f:
                    f.write(new_content)
                print(f"🔒 에이전트 권한 복구 완료: {agent_id}")
            except Exception as e:
                print(f"⚠️ 에이전트 {agent_id} 권한 복구 중 오류: {e}")

def main():
    gemini_api_key = os.getenv('GEMINI_API_KEY')
    if not gemini_api_key:
        print("❌ GEMINI_API_KEY 환경 변수가 설정되지 않았습니다.")
        sys.exit(1)

    tasks = []
    bulk_file = 'nightwatch_bulk_tasks.json'

    if os.path.exists(bulk_file):
        print(f"📂 {bulk_file} 발견: 다중/병렬 태스크 실행 모드")
        try:
            with open(bulk_file, 'r') as f:
                tasks = json.load(f)
            os.remove(bulk_file)
            run_command(f"git rm {bulk_file} || true")
        except Exception as e:
            print(f"❌ {bulk_file} 읽기/삭제 중 오류: {e}")
            sys.exit(1)
    else:
        tag = os.getenv('TAG', 'FLASH')
        title = os.getenv('TITLE', 'Untitled Task')
        try:
            with open('task_body.txt', 'r') as f:
                task_body = f.read().strip()
        except FileNotFoundError:
            task_body = "No task body found."

        tasks.append({
            "tag": tag,
            "title": title,
            "body": task_body
        })

    print(f"🚀 NightWatch Executor 시작: 총 {len(tasks)} 개의 태스크")

    # --- [1단계 적용] Git Config 통일 및 봇 명칭 제거 ---
    run_command("git config --global user.name 'kimpossible-TY'")
    run_command("git config --global user.email '95904582+kimpossible-TY@users.noreply.github.com'")
    run_command("git config user.name 'kimpossible-TY'")
    run_command("git config user.email '95904582+kimpossible-TY@users.noreply.github.com'")

    elevate_agent_permissions()

    try:
        os.makedirs('.openclaw_config', exist_ok=True)
        run_command("chmod 777 .openclaw_config")

        for i, task in enumerate(tasks, 1):
            original_tag = task.get("tag", "FLASH")
            title = task.get("title", "Untitled Task")
            raw_task_body = task.get("body", "No task body found.")

            # --- [3단계 적용] 에이전트에 넘기기 전 컨텍스트 압축 ---
            task_body = prune_context_via_lite(raw_task_body, gemini_api_key)

            # 1. Estimate Tokens & Watchdog Check (압축된 텍스트 기반으로 계산)
            # 맹목적인 15000 버퍼를 5000으로 축소
            estimated_tokens = watchdog.estimate_tokens(task_body) + 5000
            
            # 2. Dynamic Routing
            routed_tag = route_model_by_context(original_tag, task_body, estimated_tokens)
            
            # 3. Throttle
            watchdog.check_and_throttle(estimated_tokens)

            print("\n==============================================")
            print(f"▶️ [태스크 {i}/{len(tasks)}] 시작: [{routed_tag}] {title} (Est. Tokens: {estimated_tokens})")
            print("==============================================")

            default_config = {
                "agents": {
                    "defaults": {"workspace": "/workspace"},
                    "list": [
                        {
                            "id": "tool-architect",
                            "name": "Tool Architect",
                            "workspace": "/workspace/agents/tool-architect",
                            "agentDir": "/workspace/agents/tool-architect"
                        },
                        {
                            "id": "math-typst-specialist",
                            "name": "Math & Typst Specialist",
                            "workspace": "/workspace/agents/math-typst-specialist",
                            "agentDir": "/workspace/agents/math-typst-specialist"
                        }
                    ]
                }
            }
            with open('.openclaw_config/openclaw.json', 'w') as f:
                json.dump(default_config, f, indent=2)

            openclaw_gateway_token = secrets.token_hex(24)
            patch_openclaw_config(gemini_api_key, routed_tag, openclaw_gateway_token)

            try:
                os.makedirs('.openclaw_config/agents/tool-architect', exist_ok=True)
                run_command("ln -sfn /workspace/agents/tool-architect .openclaw_config/agents/tool-architect/agent")
                os.makedirs('.openclaw_config/agents/math-typst-specialist', exist_ok=True)
                run_command("ln -sfn /workspace/agents/math-typst-specialist .openclaw_config/agents/math-typst-specialist/agent")
                print("✅ 에이전트 디스커버리용 심볼릭 링크 생성 완료")
            except Exception as e:
                print(f"⚠️ 심볼릭 링크 생성 중 오류: {e}")

            run_command(f"OPENCLAW_GATEWAY_TOKEN={openclaw_gateway_token} OPENCLAW_CONFIG_DIR=/workspace/.openclaw_config docker compose up --build -d openclaw-gateway")
            run_command("sleep 5")

            print(f"⚡ OpenClaw 실행 중... (Tag: {routed_tag}, Title: {title})")
            
            # --- 재시도 래퍼를 제거하고 평범한 run_command 사용 ---
            # OpenClaw 내부에서 429 핸들링을 수행하므로 외부에서 컨테이너를 죽일 필요 없음
            agent_cmd = [
                "docker compose run --rm -T",
                f"-e GEMINI_API_KEY={shlex.quote(gemini_api_key)}",
                f"-e TASK_BODY={shlex.quote(task_body)}",
                "-e OPENCLAW_ACCEPT_RISK=true",
                f"-e OPENCLAW_GATEWAY_TOKEN={openclaw_gateway_token}",
                "-e OPENCLAW_CONFIG_PATH=/workspace/.openclaw_config/openclaw.json",
                "-e OPENCLAW_STATE_DIR=/workspace/.openclaw_config",
                "nightwatch-agent",
                f"openclaw agent --agent tool-architect --message {shlex.quote(task_body)}"
            ]

            rc, output = run_command(" ".join(agent_cmd))
            
            if rc != 0:
                print(f"❌ Task failed or interrupted. Return code: {rc}")
                # 실패하더라도 다음 태스크를 위해 멈추지 않음

            run_command("docker compose stop openclaw-gateway")
            run_command("sudo chown -R $USER:$USER .")

            print(f"📂 변경 사항 커밋 중... ([{routed_tag}] {title})")
            run_command("git add .")

            _, status_output = run_command("git status --porcelain")
            if status_output.strip():
                print("📝 변경된 파일 목록:")
                print(status_output)

            rc_diff, _ = run_command("git diff --cached --quiet")
            if rc_diff != 0:
                print(f"✅ 변경 사항 발견: 커밋 생성 중... ([{routed_tag}] {title})")
                run_command(f'git commit -m "feat: [{routed_tag}] {title}"')
            else:
                print("ℹ️ 변경 사항 없음 — 자동 PR 생성을 위해 빈 커밋을 생성합니다.")
                run_command(f'git commit --allow-empty -m "feat: [{routed_tag}] {title} (no code changes)"')

    finally:
        restore_agent_permissions()

    print("\n✅ NightWatch Executor 전체 완료")


if __name__ == "__main__":
    main()

