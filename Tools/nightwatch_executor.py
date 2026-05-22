import json
import os
import sys
import secrets
import shlex

from nightwatch.context_extractors import (
    classify_task_type,
    extract_relevant_paths,
    infer_recent_files,
    summarize_file,
    summarize_plan_file,
)
from nightwatch.context_packer import build_context_pack, format_quota_debug
from nightwatch_utils import prune_context_via_lite
from nightwatch.gateway import patch_openclaw_config, setup_docker_symlinks
from nightwatch.memory_store import MemoryStore
from nightwatch.permissions import elevate_agent_permissions, restore_agent_permissions
from nightwatch.shell import run_command

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

    memory = MemoryStore()
    memory.init_store()

    elevate_agent_permissions()

    try:
        for i, task in enumerate(tasks, 1):
            title = task.get("title", "Untitled Task")
            raw_task_body = task.get("body", "No task body found.")
            task_type = classify_task_type(title, raw_task_body)
            task_body = prune_context_via_lite(raw_task_body, gemini_api_key)
            relevant_paths = infer_recent_files(extract_relevant_paths(title, task_body))
            memory.update_session_state(
                active_task=title,
                recent_files=relevant_paths,
                known_constraints=[
                    "Use packed context instead of raw long prompts",
                    "Prefer summaries over full logs/files",
                ],
            )
            for path in relevant_paths[:4]:
                summary = summarize_file(path)
                if summary:
                    memory.append_file_summary(path, summary, task_type=task_type)

            memory.append_task_summary(title, task_body, task_type, files=relevant_paths)
            memory.write_working_summary(f"Current task: {title}\nType: {task_type}\nFiles: {', '.join(relevant_paths) or 'none'}")
            retrieved = memory.retrieve(f"{title}\n{task_body}", task_type=task_type, paths=relevant_paths)
            retrieval_debug = memory.format_retrieval_debug(retrieved)
            if retrieval_debug:
                print(f"🔎 Retrieval ranking for '{title}':\n{retrieval_debug}")
            packed_task_context, pack_meta = build_context_pack(
                title=title,
                body=task_body,
                task_type=task_type,
                session_state=memory.read_session_state(),
                working_summary=memory.read_working_summary(),
                retrieved=retrieved,
                relevant_paths=relevant_paths,
                budget_tokens=14000,
            )
            print(
                f"📦 Context pack built for '{title}' "
                f"(est. {pack_meta['used_tokens_estimate']} tokens, omitted: {', '.join(pack_meta['omitted_sections']) or 'none'}, "
                f"quota: {format_quota_debug(pack_meta['quota'])})"
            )

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

            planning_prompt = (
                "Analyze the following packed task context and create a detailed plan in `/workspace/plan.md`.\n"
                "Use the retrieved context as supporting memory, but only act on details that are consistent with the current task.\n\n"
                f"{packed_task_context}"
            )

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

            plan_summary = summarize_plan_file("plan.md")
            if plan_summary:
                memory.append_decision(f"Plan summary for {title}: {plan_summary}", task_type, files=relevant_paths)
                memory.write_working_summary(
                    f"Current task: {title}\nType: {task_type}\nPlan summary:\n{plan_summary}"
                )

            print(f"\n--- Phase 2: Working (WORKER: Local Qwen2.5) for: {title} ---")
            patch_openclaw_config(gemini_api_key, "WORKER", openclaw_gateway_token, GATEWAY_PORT)

            work_retrieved = memory.retrieve(f"{title}\n{task_body}\n{plan_summary}", task_type=task_type, paths=relevant_paths)
            work_retrieval_debug = memory.format_retrieval_debug(work_retrieved)
            if work_retrieval_debug:
                print(f"🔎 Work-phase retrieval for '{title}':\n{work_retrieval_debug}")
            work_context, work_meta = build_context_pack(
                title=title,
                body=task_body,
                task_type=task_type,
                session_state=memory.read_session_state(),
                working_summary=memory.read_working_summary(),
                retrieved=work_retrieved,
                plan_summary=plan_summary,
                relevant_paths=relevant_paths,
                budget_tokens=14000,
            )
            print(
                f"📦 Work context refreshed for '{title}' "
                f"(est. {work_meta['used_tokens_estimate']} tokens, omitted: {', '.join(work_meta['omitted_sections']) or 'none'}, "
                f"quota: {format_quota_debug(work_meta['quota'])})"
            )
            working_prompt = (
                "Implement the task based on `/workspace/plan.md` and the packed context below.\n"
                "Keep changes focused and avoid re-reading unrelated workspace history.\n\n"
                f"{work_context}"
            )

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
            else:
                memory.append_decision(f"Executed work phase for {title} using packed context.", task_type, files=relevant_paths)

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
