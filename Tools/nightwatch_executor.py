import json
import os
import sys
import secrets
import shlex

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
    PROJECT_ID = f"executor-{secrets.token_hex(4)}"
    GATEWAY_PORT = 18791 # 엑스큐터 전용 포트 대역

    if os.path.exists(bulk_file):
        try:
            with open(bulk_file, 'r') as f:
                tasks = json.load(f)
            os.remove(bulk_file)
            run_command(f"git rm {bulk_file} || true")
        except Exception as e:
            sys.exit(1)
    else:
        tag = os.getenv('TAG', 'FLASH')
        title = os.getenv('TITLE', 'Untitled Task')
        try:
            with open('task_body.txt', 'r') as f:
                task_body = f.read().strip()
        except FileNotFoundError:
            task_body = "No task body found."
        tasks.append({"tag": tag, "title": title, "body": task_body})

    run_command("git config --global user.name 'kimpossible-TY'")
    run_command("git config --global user.email '95904582+kimpossible-TY@users.noreply.github.com'")

    elevate_agent_permissions()

    try:
        for i, task in enumerate(tasks, 1):
            title = task.get("title", "Untitled Task")
            raw_task_body = task.get("body", "No task body found.")
            task_body = prune_context_via_lite(raw_task_body, gemini_api_key)

            print(f"\n--- Phase 1: Planning (PLANNER: Gemini Pro) for: {title} ---")
            openclaw_gateway_token = secrets.token_hex(24)
            patch_openclaw_config(gemini_api_key, "PLANNER", openclaw_gateway_token, GATEWAY_PORT)
            setup_docker_symlinks()

            gw_cmd = (
                f"OPENCLAW_GATEWAY_PORT={GATEWAY_PORT} "
                f"OPENCLAW_GATEWAY_TOKEN={openclaw_gateway_token} "
                f"OPENCLAW_CONFIG_PATH=/workspace/.openclaw_config/openclaw.json "
                f"OPENCLAW_STATE_DIR=/workspace/.openclaw_config "
                f"docker compose -p {PROJECT_ID} up --build -d openclaw-gateway"
            )
            run_command(gw_cmd)
            run_command("sleep 5")

            planning_prompt = f"Analyze the following task and create a detailed plan in `/workspace/plan.md`.\nTask: {title}\nDesc: {task_body}"

            agent_plan_cmd = [
                "docker", "compose", "-p", PROJECT_ID, "run", "--rm", "-T",
                f"-e", f"GEMINI_API_KEY={shlex.quote(gemini_api_key)}",
                "-e", "OPENCLAW_ACCEPT_RISK=true",
                "-e", f"OPENCLAW_GATEWAY_URL=ws://127.0.0.1:{GATEWAY_PORT}",
                f"-e", f"OPENCLAW_GATEWAY_TOKEN={openclaw_gateway_token}",
                "-e", "OPENCLAW_CONFIG_PATH=/workspace/.openclaw_config/openclaw.json",
                "-e", "OPENCLAW_STATE_DIR=/workspace/.openclaw_config",
                "nightwatch-agent",
                f"openclaw agent --agent tool-architect --message {shlex.quote(planning_prompt)}"
            ]

            rc_plan, _ = run_command(" ".join(agent_plan_cmd))
            if rc_plan != 0:
                print(f"❌ Planning phase failed for task: {title}")
                run_command(f"docker compose -p {PROJECT_ID} down -v")
                continue

            print(f"\n--- Phase 2: Working (WORKER: Local Qwen2.5) for: {title} ---")
            patch_openclaw_config(gemini_api_key, "WORKER", openclaw_gateway_token, GATEWAY_PORT)

            working_prompt = f"Implement the task based on `/workspace/plan.md`.\nTask: {title}\nDesc: {task_body}"

            agent_work_cmd = [
                "docker", "compose", "-p", PROJECT_ID, "run", "--rm", "-T",
                f"-e", f"GEMINI_API_KEY={shlex.quote(gemini_api_key)}",
                "-e", "OPENCLAW_ACCEPT_RISK=true",
                "-e", f"OPENCLAW_GATEWAY_URL=ws://127.0.0.1:{GATEWAY_PORT}",
                f"-e", f"OPENCLAW_GATEWAY_TOKEN={openclaw_gateway_token}",
                "-e", "OPENCLAW_CONFIG_PATH=/workspace/.openclaw_config/openclaw.json",
                "-e", "OPENCLAW_STATE_DIR=/workspace/.openclaw_config",
                "nightwatch-agent",
                f"openclaw agent --agent tool-architect --message {shlex.quote(working_prompt)}"
            ]

            rc_work, _ = run_command(" ".join(agent_work_cmd))
            if rc_work != 0:
                print(f"❌ Working phase failed for task: {title}")

            run_command(f"docker compose -p {PROJECT_ID} down -v")
            run_command("sudo chown -R $(id -u):$(id -g) .")

            run_command("git add .")
            rc_diff, _ = run_command("git diff --cached --quiet")
            if rc_diff != 0:
                run_command(f'git commit -m "feat: {title}"')
            else:
                run_command(f'git commit --allow-empty -m "feat: {title} (no code changes)"')

    finally:
        restore_agent_permissions()

if __name__ == "__main__":
    main()

