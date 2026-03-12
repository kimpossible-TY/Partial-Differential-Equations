#!/usr/bin/env python3
import json
import os
import subprocess
import sys
from datetime import datetime

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

def patch_openclaw_config(gemini_api_key):
    """OpenClaw 구성을 CI 환경에 맞게 동적 패치"""
    path = '.openclaw_config/openclaw.json'
    if not os.path.exists(path):
        print(f"⚠️ {path} 를 찾을 수 없습니다. 패치를 건너뜁니다.")
        return False
        
    try:
        with open(path, 'r') as f:
            config = json.load(f)
            
        # 1. Gateway 설정 보정
        config['gateway'] = config.get('gateway', {})
        config['gateway']['remote'] = {'url': 'ws://openclaw-gateway:18789'}
        config['gateway']['mode'] = 'remote'
        config.pop('auth', None) # 인증 제거 (로컬 게이트웨이용)
        
        # 2. Google Provider 설정 및 API Key 주입
        models_config = config.setdefault('models', {})
        providers = models_config.setdefault('providers', {})
        google_prov = providers.setdefault('google', {})
        google_prov['apiKey'] = gemini_api_key
        
        # 필수 모델(gemini-3.0-flash) 확인 및 추가
        google_models = google_prov.setdefault('models', [])
        if not any(m.get('id') == 'gemini-3.0-flash' for m in google_models):
            google_models.insert(0, {'id': 'gemini-3.0-flash', 'name': 'Gemini 3.0 Flash'})
            
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

    if tag == "PRO":
        print("🧠 [PRO] 태스크 진행: Architecture Plan 작성")
        plan_content = f"""# Architecture Plan: {title}

## 태스크 설명
{task_body}

## 제안 설계
> 이 파일을 인간이 검토하고 PR을 Approve하면 다음 야간 사이클에서 구현됩니다.

## 작성일
{datetime.utcnow().strftime('%Y-%m-%d %H:%M UTC')}
"""
        with open('Architecture_Plan.md', 'w') as f:
            f.write(plan_content)
        
        run_command("git add Architecture_Plan.md")
        run_command(f'git commit -m "plan: [PRO] {title}"')
        
    else:
        print("⚡ [FLASH] 태스크 진행: OpenClaw 실행 (Sandbox)")
        
        # 1. 설정 디렉토리 준비 및 템플릿 복사
        os.makedirs('.openclaw_config', exist_ok=True)
        run_command("chmod 777 .openclaw_config")
        run_command("cp .openclaw/openclaw.json .openclaw_config/openclaw.json")
        
        # 2. 설정 패치 (컨테이너 외부에서 실행)
        patch_openclaw_config(gemini_api_key)
        
        # 3. Gateway 서비스 시작
        run_command("docker compose up -d openclaw-gateway")
        run_command("sleep 5")
        
        # 4. Agent 실행
        # docker compose run 내에서 GEMINI_API_KEY가 전달되도록 설정 (이미 YAML/Compose에 있음)
        agent_cmd = [
            "docker compose run --rm -T",
            f"-e GEMINI_API_KEY=\"{gemini_api_key}\"",
            f"-e \"TASK_BODY={task_body}\"",
            "-e OPENCLAW_ACCEPT_RISK=true",
            "nightwatch-agent",
            f"openclaw agent --agent tool-architect --message \"{task_body}\""
        ]
        rc, _ = run_command(" ".join(agent_cmd))
        
        # 5. 사후 처리
        run_command("docker compose stop openclaw-gateway")
        run_command("sudo chown -R $USER:$USER .")
        
        # 변경 사항 커밋
        run_command("git add .")
        rc_diff, _ = run_command("git diff --cached --quiet")
        if rc_diff != 0: # 변경 사항이 있으면
            run_command(f'git commit -m "feat: [FLASH] {title}"')
        else:
            print("ℹ️ 변경 사항 없음 — 빈 커밋 생성")
            run_command(f'git commit --allow-empty -m "feat: [FLASH] {title} (no changes)"')

    print("✅ NightWatch Executor 완료")

if __name__ == "__main__":
    main()
