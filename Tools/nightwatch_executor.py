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
        # 일부 에러는 무시해도 될 수 있으므로 호출부에서 판단하도록 함
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
        config['gateway']['remote'] = {'url': 'ws://openclaw-gateway:18789'}
        config['gateway']['mode'] = 'remote'

        # 1.5 Gateway 인증 설정 (토큰 방식)
        if openclaw_gateway_token:
            config['gateway']['auth'] = {
                "mode": "token",
                "token": openclaw_gateway_token
            }
        else:
            config.pop('auth', None)  # 인증 제거 (기본값)

        # 2. 모델 설정 및 API Key 주입
        # 태그에 따라 사용할 모델 결정
        target_model = 'google/gemini-3.1-pro-preview' if tag == 'PRO' else 'google/gemini-3.0-flash'
        print(f"🎯 타겟 모델 설정: {target_model}")

        # 기본 모델 설정 (Primary)
        agents_config = config.setdefault('agents', {})
        defaults = agents_config.setdefault('defaults', {})
        model_defaults = defaults.setdefault('model', {})
        model_defaults['primary'] = target_model

        models_config = config.setdefault('models', {})
        providers = models_config.setdefault('providers', {})
        google_prov = providers.setdefault('google', {})
        google_prov['baseUrl'] = 'https://generativelanguage.googleapis.com/v1beta'
        google_prov['apiKey'] = gemini_api_key

        # 필수 모델 목록 보정
        google_models = google_prov.setdefault('models', [])
        # 중복 제거 후 target_model을 가장 앞에 추가
        google_models = [m for m in google_models if m.get('id') != target_model]
        google_models.insert(0, {'id': target_model, 'name': target_model.split('/')[-1]})
        google_prov['models'] = google_models

        # 3. 모든 경로를 /workspace 기준으로 치환
        # 기존 workspace 경로를 자동으로 찾아 치환
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

                # write: 섹션 아래의 항목을 "../../**/*" 로 치환
                # 정규표현식으로 'write:' 다음 줄의 리스트 항목('- ...')을 찾아 바꿈
                new_content = re.sub(
                    r'(write:\s*\n\s*-\s*).+',
                    r'\1"../../**/*"',
                    content
                )

                with open(manifest_path, 'w') as f:
                    f.write(new_content)
                print(f"🔓 에이전트 권한 승격 완료: {agent_id}")
            except Exception as e:
                print(f"⚠️ 에이전트 {agent_id} 권한 승격 중 오류: {e}")


def main():
    # 환경 변수 로드
    tag = os.getenv('TAG', 'FLASH')
    title = os.getenv('TITLE', 'Untitled Task')
    gemini_api_key = os.getenv('GEMINI_API_KEY')

    try:
        with open('task_body.txt', 'r') as f:
            task_body = f.read().strip()
    except FileNotFoundError:
        task_body = "No task body found."

    if not gemini_api_key:
        print("❌ GEMINI_API_KEY 환경 변수가 설정되지 않았습니다.")
        sys.exit(1)

    print(f"🚀 NightWatch Executor 시작: [{tag}] {title}")

    # 1. 공통 준비: 에이전트 권한 승격 및 설정 디렉토리 준비
    elevate_agent_permissions()
    os.makedirs('.openclaw_config', exist_ok=True)
    run_command("chmod 777 .openclaw_config")
    run_command("cp .openclaw/openclaw.json .openclaw_config/openclaw.json")

    # 2. 설정 패치 (태그에 따른 모델 주입 포함)
    openclaw_gateway_token = secrets.token_hex(24) # openclaw_gateway_token이라는 변수명은 변경하면 안됨. 이유는 로컬에서 docker-compose를 할 때 해당 이름의 token을 가져오기 때문.
    patch_openclaw_config(gemini_api_key, tag, openclaw_gateway_token)

    # 3. Gateway 서비스 시작
    run_command(f"OPENCLAW_GATEWAY_TOKEN={openclaw_gateway_token} docker compose up -d openclaw-gateway")
    run_command("sleep 5")

    # 4. Agent 실행
    # PRO든 FLASH든 실제 에이전트를 실행하여 TASKS.md의 지시사항을 완수하도록 함
    print(f"⚡ OpenClaw 실행 중... (Tag: {tag}, Title: {title})")
    agent_cmd = [
        "docker compose run --rm -T",
        f"-e GEMINI_API_KEY={shlex.quote(gemini_api_key)}",
        f"-e TASK_BODY={shlex.quote(task_body)}",
        "-e OPENCLAW_ACCEPT_RISK=true",
        "nightwatch-agent",
        f"openclaw agent --agent tool-architect --message {shlex.quote(task_body)}"
    ]
    rc, _ = run_command(" ".join(agent_cmd))

    # 5. 사후 처리
    run_command("docker compose stop openclaw-gateway")
    run_command("sudo chown -R $USER:$USER .")

    # 변경 사항 커밋
    print("📂 변경 사항 확인 및 커밋 중...")
    
    # 1. Git 유저 정보 확인 및 설정
    run_command("git config user.name 'NightWatch Bot'")
    run_command("git config user.email 'nightwatch@kimpossible-ty'")
    
    # 2. 모든 변경 사항 스테이징
    run_command("git add .")
    
    # 3. 변경 내용 상세 로깅 (디버깅용)
    _, status_output = run_command("git status --porcelain")
    if status_output.strip():
        print("📝 변경된 파일 목록:")
        print(status_output)
    
    # 4. 커밋 실행
    rc_diff, _ = run_command("git diff --cached --quiet")
    if rc_diff != 0:  # 변경 사항이 있으면
        print(f"✅ 변경 사항 발견: 커밋 생성 중... ([{tag}] {title})")
        run_command(f'git commit -m "feat: [{tag}] {title}"')
    else:
        print("ℹ️ 변경 사항 없음 — 자동 PR 생성을 위해 빈 커밋을 생성합니다.")
        run_command(f'git commit --allow-empty -m "feat: [{tag}] {title} (no code changes)"')

    print("✅ NightWatch Executor 완료")


if __name__ == "__main__":
    main()
