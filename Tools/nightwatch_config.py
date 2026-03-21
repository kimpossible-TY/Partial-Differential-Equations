import os
import json
import subprocess

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

def setup_docker_symlinks():
    """Ensure the Docker symlink logic (.openclaw_config/agents/...) is set up."""
    try:
        os.makedirs('.openclaw_config/agents/tool-architect', exist_ok=True)
        run_command("ln -sfn /workspace/agents/tool-architect .openclaw_config/agents/tool-architect/agent")
        os.makedirs('.openclaw_config/agents/math-typst-specialist', exist_ok=True)
        run_command("ln -sfn /workspace/agents/math-typst-specialist .openclaw_config/agents/math-typst-specialist/agent")
        print("✅ 에이전트 디스커버리용 심볼릭 링크 생성 완료")
    except Exception as e:
        print(f"⚠️ 심볼릭 링크 생성 중 오류: {e}")

def patch_openclaw_config(gemini_api_key, tag, openclaw_gateway_token=None):
    path = '.openclaw_config/openclaw.json'
    
    # Ensure config dir exists
    os.makedirs('.openclaw_config', exist_ok=True)
    run_command("chmod 777 .openclaw_config")

    # If it doesn't exist, create default
    if not os.path.exists(path):
        print(f"ℹ️ {path} 가 존재하지 않습니다. 기본 설정을 생성합니다.")
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
        with open(path, 'w') as f:
            json.dump(default_config, f, indent=2)

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
