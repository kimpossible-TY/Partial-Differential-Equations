import json
import os
import sys
import secrets
import shlex
import time

# --- Module Extraction ---
from nightwatch_utils import prune_context_via_lite
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
    
    try:
        for i, task in enumerate(tasks, 1):
            original_tag = task.get("tag", "FLASH")
            title = task.get("title", "Untitled Task")
            raw_task_body = task.get("body", "No task body found.")

            # Pruning
            task_body = prune_context_via_lite(raw_task_body, gemini_api_key)

            # --- Phase 1: Planning (Gemini Pro) ---
            print(f"\n--- Phase 1: Planning (PLANNER: Gemini Pro) for: {title} ---")
            planning_tag = "PLANNER"
            openclaw_gateway_token = secrets.token_hex(24)
            patch_openclaw_config(gemini_api_key, planning_tag, openclaw_gateway_token)
            setup_docker_symlinks()

            run_command(f"OPENCLAW_GATEWAY_TOKEN={openclaw_gateway_token} OPENCLAW_CONFIG_PATH=/workspace/.openclaw_config/openclaw.json OPENCLAW_STATE_DIR=/workspace/.openclaw_config docker compose up --build -d openclaw-gateway")
            run_command("sleep 5")

            planning_prompt = (
                f"Analyze the following task and create a detailed, rich, and practical implementation plan in `/workspace/plan.md`. "
                f"Explain exactly how to execute the task, which files to modify, and what logic to implement. "
                f"Do not modify any other files yet. Just write the comprehensive plan to `plan.md`.\n\n"
                f"Task Title: {title}\n"
                f"Task Description: {task_body}"
            )

            agent_plan_cmd = [
                "docker compose run --rm -T",
                f"-e GEMINI_API_KEY={shlex.quote(gemini_api_key)}",
                "-e OPENCLAW_ACCEPT_RISK=true",
                f"-e OPENCLAW_GATEWAY_TOKEN={openclaw_gateway_token}",
                "-e OPENCLAW_CONFIG_PATH=/workspace/.openclaw_config/openclaw.json",
                "-e OPENCLAW_STATE_DIR=/workspace/.openclaw_config",
                "nightwatch-agent",
                f"openclaw agent --agent tool-architect --message {shlex.quote(planning_prompt)}"
            ]

            rc_plan, _ = run_command(" ".join(agent_plan_cmd))
            if rc_plan != 0:
                print(f"❌ Planning phase failed for task: {title}")
                run_command("docker compose stop openclaw-gateway")
                continue

            # --- Phase 2: Working (Local Qwen2.5-Coder) ---
            print(f"\n--- Phase 2: Working (WORKER: Local Qwen2.5) for: {title} ---")
            working_tag = "WORKER"
            patch_openclaw_config(gemini_api_key, working_tag, openclaw_gateway_token)
            
            working_prompt = (
                f"Now implement the task based on the detailed implementation plan in `/workspace/plan.md`. "
                f"You are running on a local model optimized for coding. "
                f"Modify the necessary files to complete the task according to the plan.\n\n"
                f"Task Title: {title}\n"
                f"Task Description: {task_body}"
            )

            agent_work_cmd = [
                "docker compose run --rm -T",
                f"-e GEMINI_API_KEY={shlex.quote(gemini_api_key)}",
                "-e OPENCLAW_ACCEPT_RISK=true",
                f"-e OPENCLAW_GATEWAY_TOKEN={openclaw_gateway_token}",
                "-e OPENCLAW_CONFIG_PATH=/workspace/.openclaw_config/openclaw.json",
                "-e OPENCLAW_STATE_DIR=/workspace/.openclaw_config",
                "nightwatch-agent",
                f"openclaw agent --agent tool-architect --message {shlex.quote(working_prompt)}"
            ]

            rc_work, _ = run_command(" ".join(agent_work_cmd))
            if rc_work != 0:
                print(f"❌ Working phase failed for task: {title}")

            run_command("docker compose stop openclaw-gateway")
            run_command("sudo chown -R $(id -u):$(id -g) .")

            print(f"📂 변경 사항 커밋 중... ({title})")
            run_command("git add .")

            _, status_output = run_command("git status --porcelain")
            if status_output.strip():
                print("📝 변경된 파일 목록:")
                print(status_output)

            rc_diff, _ = run_command("git diff --cached --quiet")
            if rc_diff != 0:
                print(f"✅ 변경 사항 발견: 커밋 생성 중... ({title})")
                run_command(f'git commit -m "feat: {title}"')
            else:
                print("ℹ️ 변경 사항 없음 — 자동 PR 생성을 위해 빈 커밋을 생성합니다.")
                run_command(f'git commit --allow-empty -m "feat: {title} (no code changes)"')

    finally:
        restore_agent_permissions()

    print("\n✅ NightWatch Executor 전체 완료")


if __name__ == "__main__":
    main()
