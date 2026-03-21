import json
import os
import sys
import secrets
import shlex
import time

# --- Module Extraction ---
from nightwatch_utils import RateLimitWatchdog, prune_context_via_lite, route_model_by_context
from nightwatch_config import (
    run_command, 
    patch_openclaw_config, 
    elevate_agent_permissions, 
    restore_agent_permissions,
    setup_docker_symlinks
)

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

    # Git Config 
    run_command("git config --global user.name 'kimpossible-TY'")
    run_command("git config --global user.email '95904582+kimpossible-TY@users.noreply.github.com'")
    run_command("git config user.name 'kimpossible-TY'")
    run_command("git config user.email '95904582+kimpossible-TY@users.noreply.github.com'")

    elevate_agent_permissions()
    
    watchdog = RateLimitWatchdog()

    try:
        for i, task in enumerate(tasks, 1):
            original_tag = task.get("tag", "FLASH")
            title = task.get("title", "Untitled Task")
            raw_task_body = task.get("body", "No task body found.")

            # Pruning
            task_body = prune_context_via_lite(raw_task_body, gemini_api_key)

            # Token estimation & Watchdog
            estimated_tokens = watchdog.estimate_tokens(task_body) + 5000
            
            # Dynamic Routing
            routed_tag = route_model_by_context(original_tag, task_body, estimated_tokens)
            
            # Throttle
            watchdog.check_and_throttle(estimated_tokens)

            print("\n==============================================")
            print(f"▶️ [태스크 {i}/{len(tasks)}] 시작: [{routed_tag}] {title} (Est. Tokens: {estimated_tokens})")
            print("==============================================")

            openclaw_gateway_token = secrets.token_hex(24)
            patch_openclaw_config(gemini_api_key, routed_tag, openclaw_gateway_token)
            setup_docker_symlinks()

            run_command(f"OPENCLAW_GATEWAY_TOKEN={openclaw_gateway_token} OPENCLAW_CONFIG_DIR=/workspace/.openclaw_config docker compose up --build -d openclaw-gateway")
            run_command("sleep 5")

            print(f"⚡ OpenClaw 실행 중... (Tag: {routed_tag}, Title: {title})")
            
            # Agent command execution with retries
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

            max_retries = 5
            base_delay = 5
            
            for attempt in range(max_retries):
                rc, output = run_command(" ".join(agent_cmd))
                if rc == 0:
                    break
                    
                # 429 Too Many Requests detection
                if "429" in output or "Too Many Requests" in output or "quota" in output.lower():
                    delay = base_delay * (2 ** attempt)
                    print(f"⚠️ [Rate Limit] 429 오류 발생. {delay}초 후 재시도합니다... (시도: {attempt + 1}/{max_retries})")
                    time.sleep(delay)
                else:
                    print(f"❌ Task failed or interrupted. Return code: {rc}")
                    break
            else:
                print(f"🚨 [Error] 최대 재시도 횟수({max_retries}) 초과. 태스크 실패.")

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
