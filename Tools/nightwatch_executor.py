#!/usr/bin/env python3
import json
import os
import subprocess
import sys
import secrets
import re
import shlex


def run_command(command, shell=True, env=None):
    """실행 중인 명령어를 실시간으로 출력하며 실행"""
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
    """OpenClaw 구성을 CI 환경에 맞게 동적 패치"""
    path = '.openclaw_config/openclaw.json'
    if not os.path.exists(path):
        print(f"⚠️ {path} 를 찾을 수 없습니다. 패치를 건너뜜")
        return False

    try:
        with open(path, 'r') as f:
            config = json.load(f)

        # 1. Gateway 설정 보정
        config['gateway'] = config.get('gateway', {})
        config['gateway']['remote'] = {'url': 'ws://127.0.0.1:18789'}
        config['gateway']['mode'] = 'remote'

        # 1.5 Gateway 인증 설정 (토큰 방식)
        if openclaw_gateway_token:
            config['gateway']['auth'] = {
                "mode": "token",
                "token": openclaw_gateway_token
            }
        else:
            config.pop('auth', None)

        # 2. 모델 설정 및 API Key 주입
        model_map = {
            'PRO': 'google/gemini-3.1-pro-preview',
            'FLASH': 'google/gemini-3.0-flash',
            'LITE': 'google/gemini-3.1-flash-lite-preview'
        }
        target_model = model_map.get(tag, 'google/gemini-3.0-flash')
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
    """CI 환경에서 에이전트에게 전체 파일 쓰기 권한 부여"""
    agents_dir = 'agents'
    if not os.path.exists(agents_dir):
        return

    for agent_id in os.listdir(agents_dir):
        manifest_path = os.path.join(agents_dir, agent_id, 'manifest.yaml')
        if os.path.exists(manifest_path):
            try:
                with open(manifest_path, 'r') as f:
                    content = f.read()

                # 구조적이고 안전한 단순 문자열 치환
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
    """CI 환경 종료 시 에이전트의 파일 쓰기 권한을 기본(TASKS.md)으로 복구"""
    agents_dir = 'agents'
    if not os.path.exists(agents_dir):
        return

    for agent_id in os.listdir(agents_dir):
        manifest_path = os.path.join(agents_dir, agent_id, 'manifest.yaml')
        if os.path.exists(manifest_path):
            try:
                with open(manifest_path, 'r') as f:
                    content = f.read()

                # 구조적이고 안전한 단순 문자열 치환
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
            # 큐 파일을 삭제하고 git rm 처리 (커밋 시 포함되지 않도록 함)
            os.remove(bulk_file)
            run_command(f"git rm {bulk_file} || true")
        except Exception as e:
            print(f"❌ {bulk_file} 읽기/삭제 중 오류: {e}")
            sys.exit(1)
    else:
        # 파일이 없으면 기존처럼 단일 환경변수로 fallback
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

    # Git 유저 정보 확인 및 설정 (루프 시작 전 한 번)
    run_command("git config user.name 'NightWatch Bot'")
    run_command("git config user.email 'nightwatch@kimpossible-ty'")
    run_command("git config --global user.name 'NightWatch Bot'")
    run_command("git config --global user.email 'nightwatch@kimpossible-ty'")

    # 권한 승격 (루프 시작 전 한 번)
    elevate_agent_permissions()

    try:
        os.makedirs('.openclaw_config', exist_ok=True)
        run_command("chmod 777 .openclaw_config")

        # 핵심 루프: 각 태스크마다 실행
        for i, task in enumerate(tasks, 1):
            tag = task.get("tag", "FLASH")
            title = task.get("title", "Untitled Task")
            task_body = task.get("body", "No task body found.")

            print("\n==============================================")
            print(f"▶️ [태스크 {i}/{len(tasks)}] 시작: [{tag}] {title}")
            print("==============================================")

                        # .openclaw_config 매번 초기화
            # .openclaw_config 매번 초기화 (기존 로컬 설정 의존 제거)
            # CI 환경을 위한 기본 설정 동적 생성 (단일 진실의 원천)
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
            patch_openclaw_config(gemini_api_key, tag, openclaw_gateway_token)

<<<<<<< HEAD
            # 에이전트 자동 디스커버리를 위한 심볼릭 링크 생성 (로컬-컨테이너 간 일관된 경로 매핑)
            try:
                os.makedirs('.openclaw_config/agents', exist_ok=True)
                # OpenClaw가 직접 찾을 수 있도록 중첩 없이 디렉토리 직접 링크
                run_command("ln -sfn /workspace/agents/tool-architect .openclaw_config/agents/tool-architect")
                run_command("ln -sfn /workspace/agents/math-typst-specialist .openclaw_config/agents/math-typst-specialist")
=======
            # 에이전트 자동 디스커버리를 위한 심볼릭 링크 생성 (OpenClaw 모든 버전 호환)
            try:
                os.makedirs('.openclaw_config/agents/tool-architect', exist_ok=True)
                run_command("ln -sfn /workspace/agents/tool-architect .openclaw_config/agents/tool-architect/agent")
                os.makedirs('.openclaw_config/agents/math-typst-specialist', exist_ok=True)
                run_command("ln -sfn /workspace/agents/math-typst-specialist .openclaw_config/agents/math-typst-specialist/agent")
>>>>>>> 5cbd3cf (fix: enforce agent discovery via symlinks in CI)
                print("✅ 에이전트 디스커버리용 심볼릭 링크 생성 완료")
            except Exception as e:
                print(f"⚠️ 심볼릭 링크 생성 중 오류: {e}")

            # Gateway 실행
            run_command(f"OPENCLAW_GATEWAY_TOKEN={openclaw_gateway_token} OPENCLAW_CONFIG_DIR=/workspace/.openclaw_config docker compose up --build -d openclaw-gateway")
            run_command("sleep 5")

            # Agent 실행 (중복 호출 제거)
            print(f"⚡ OpenClaw 실행 중... (Tag: {tag}, Title: {title})")
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

            rc, _ = run_command(" ".join(agent_cmd))

            # 사후 처리
            run_command("docker compose stop openclaw-gateway")
            run_command("sudo chown -R $USER:$USER .")

            # 현재 태스크 결과 커밋
            print(f"📂 변경 사항 커밋 중... ([{tag}] {title})")
            run_command("git add .")

            _, status_output = run_command("git status --porcelain")
            if status_output.strip():
                print("📝 변경된 파일 목록:")
                print(status_output)

            rc_diff, _ = run_command("git diff --cached --quiet")
            if rc_diff != 0:
                print(f"✅ 변경 사항 발견: 커밋 생성 중... ([{tag}] {title})")
                run_command(f'git commit -m "feat: [{tag}] {title}"')
            else:
                print("ℹ️ 변경 사항 없음 — 자동 PR 생성을 위해 빈 커밋을 생성합니다.")
                run_command(f'git commit --allow-empty -m "feat: [{tag}] {title} (no code changes)"')

    finally:
        # 권한 복구는 루프가 끝나거나 오류가 발생하더라도 반드시 마지막에 수행
        restore_agent_permissions()

    print("\n✅ NightWatch Executor 전체 완료")


if __name__ == "__main__":
    main()
