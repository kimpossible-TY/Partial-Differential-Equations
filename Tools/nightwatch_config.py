"""
NightWatch Configuration Module

This module provides tools for managing the OpenClaw environment, patching gateway
configurations, managing agent file system permissions, and setting up necessary
infrastructure (symlinks) for agent discovery.
"""

import os
import json
import subprocess

def run_command(command, shell=True, env=None):
    """
    Executes a shell command and logs output.

    Args:
        command (str): The shell command string.
        shell (bool): Whether to run via shell (default: True).
        env (dict): Environment variable overrides.

    Returns:
        (int, str): Tuple containing return code and output text.
    """
    current_env = os.environ.copy()
    if env:
        current_env.update(env)

    process = subprocess.Popen(
        command,
        shell=shell,
        env=current_env,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        bufsize=1, # Line-buffered
        universal_newlines=True
    )

    output = []
    if process.stdout:
        for line in process.stdout:
            print(line, end="", flush=True)
            output.append(line)

    process.wait()
    if process.returncode != 0:
        print(f"❌ Command failed with return code {process.returncode}")
    return process.returncode, "".join(output)

def setup_docker_symlinks():
    """
    Sets up mandatory agent discovery symlinks for the Docker containers.

    These symlinks allow the OpenClaw gateway to discover and mount the local
    agent workspace correctly within the containerized environment.
    """
    try:
        os.makedirs('.openclaw_config/agents/tool-architect', exist_ok=True)
        run_command("ln -sfn /workspace/agents/tool-architect .openclaw_config/agents/tool-architect/agent")
        os.makedirs('.openclaw_config/agents/math-typst-specialist', exist_ok=True)
        run_command("ln -sfn /workspace/agents/math-typst-specialist .openclaw_config/agents/math-typst-specialist/agent")
        os.makedirs('.openclaw_config/agents/ci-fixer', exist_ok=True)
        run_command("ln -sfn /workspace/agents/ci-fixer .openclaw_config/agents/ci-fixer/agent")
        print("✅ 에이전트 디스커버리용 심볼릭 링크 생성 완료")
    except Exception as e:
        print(f"⚠️ 심볼릭 링크 생성 중 오류: {e}")

def patch_openclaw_config(gemini_api_key, tag, openclaw_gateway_token=None):
    """
    Updates the OpenClaw configuration file with the correct model and API keys.

    Args:
        gemini_api_key (str): The Google Gemini API key.
        tag (str): The model tag (e.g., 'PRO', 'FLASH', 'LITE').
        openclaw_gateway_token (str): Optional token for gateway authentication.

    Returns:
        bool: True if patching succeeded, False otherwise.

    Note:
        To update available model mappings, modify the `model_map` dictionary inside
        this function.
    """
    path = '.openclaw_config/openclaw.json'

    # Ensure config dir exists
    os.makedirs('.openclaw_config', exist_ok=True)
    run_command("chmod 777 .openclaw_config")

    # If it doesn't exist, create default structure
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
                    },
                    {
                        "id": "ci-fixer",
                        "name": "CI Fixer",
                        "workspace": "/workspace/agents/ci-fixer",
                        "agentDir": "/workspace/agents/ci-fixer"
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
        # Note: In Docker network, refer to the gateway by its service name
        config['gateway']['remote'] = {'url': 'ws://openclaw-gateway:18789'}
        config['gateway']['mode'] = 'remote'

        if openclaw_gateway_token:
            config['gateway']['auth'] = {
                "mode": "token",
                "token": openclaw_gateway_token
            }
            # 클라이언트(에이전트)가 게이트웨이에 접속할 때 사용할 토큰도 설정
            remote_cfg = config['gateway'].setdefault('remote', {})
            remote_cfg['token'] = openclaw_gateway_token
        else:
            if 'auth' in config['gateway']:
                config['gateway'].pop('auth')
            if 'remote' in config['gateway']:
                config['gateway']['remote'].pop('token', None)

        # Update model mapping: Role-based tags for Hybrid Workflow
        model_map = {
            'PLANNER': 'google/gemini-3.1-pro-preview', # Frontier model for strategy
            'WORKER': 'openai/mlx-community/Qwen2.5-Coder-3B-Instruct-4bit',       # Local model for code execution

            # Aliases for backward compatibility
            'PRO': 'google/gemini-3.1-pro-preview',
            'FLASH': 'google/gemini-3-flash-preview',
            'LOCAL': 'openai/mlx-community/Qwen2.5-Coder-3B-Instruct-4bit'
        }
        target_model = model_map.get(tag, 'google/gemini-3-flash-preview')
        print(f"🎯 타겟 모델 설정: {target_model} (Role/Tag: {tag})")

        agents_config = config.setdefault('agents', {})
        defaults = agents_config.setdefault('defaults', {})
        model_defaults = defaults.setdefault('model', {})
        model_defaults['primary'] = target_model

        models_config = config.setdefault('models', {})
        providers = models_config.setdefault('providers', {})

        # Google Provider (Strategic Planner)
        google_prov = providers.setdefault('google', {})
        google_prov['baseUrl'] = 'https://generativelanguage.googleapis.com/v1beta'
        google_prov['apiKey'] = gemini_api_key
        google_models = google_prov.setdefault('models', [])
        if 'google/' in target_model:
            google_models = [m for m in google_models if m.get('id') != target_model]
            google_models.insert(0, {'id': target_model, 'name': target_model.split('/')[-1]})
        google_prov['models'] = google_models

        # Local MLX-LM Provider (Practical Worker via OpenAI compatible API)
        openai_prov = providers.setdefault('openai', {})
        # Note: host.docker.internal is used to reach Mac host from inside Docker container
        openai_prov['baseUrl'] = 'http://host.docker.internal:8080/v1'
        openai_prov['apiKey'] = 'not-needed'
        openai_models = openai_prov.setdefault('models', [])
        if 'openai/' in target_model:
            # mlx_lm.server can be picky about model names, but usually accepts the local name
            openai_models = [m for m in openai_models if m.get('id') != target_model]
            openai_models.insert(0, {'id': target_model, 'name': 'Local Qwen2.5 Coder'})
        openai_prov['models'] = openai_models

        # Ensure absolute workspace paths are correctly mapped
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
    """
    Expands agent manifest permissions to allow write access to the entire
    workspace instead of just TASKS.md.
    """
    agents_dir = 'agents'
    if not os.path.exists(agents_dir):
        return

    for agent_id in os.listdir(agents_dir):
        manifest_path = os.path.join(agents_dir, agent_id, 'manifest.yaml')
        if os.path.exists(manifest_path):
            try:
                with open(manifest_path, 'r') as f:
                    content = f.read()

                # Regex replacement to allow wide-scope write access
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
    """
    Restores agent manifest permissions, restricting write access back to
    only TASKS.md.
    """
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

