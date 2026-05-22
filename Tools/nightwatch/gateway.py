"""OpenClaw gateway and config patch helpers."""

from __future__ import annotations

import json
import os

from nightwatch.shell import run_command


AGENT_SPECS = [
    {
        "id": "tool-architect",
        "name": "Tool Architect",
        "workspace": "/workspace/agents/tool-architect",
    },
    {
        "id": "math-typst-specialist",
        "name": "Math & Typst Specialist",
        "workspace": "/workspace/agents/math-typst-specialist",
    },
    {
        "id": "ci-fixer",
        "name": "CI Fixer",
        "workspace": "/workspace/agents/ci-fixer",
    },
]

MODEL_MAP = {
    "PLANNER": "google/gemini-3.1-pro-preview",
    "WORKER": "openai/mlx-community/Qwen2.5-Coder-3B-Instruct-4bit",
    "PRO": "google/gemini-3.1-pro-preview",
    "FLASH": "google/gemini-3-flash-preview",
    "LOCAL": "openai/mlx-community/Qwen2.5-Coder-3B-Instruct-4bit",
}


def setup_docker_symlinks() -> None:
    """Expose workspace agents through the generated OpenClaw config directory."""
    try:
        for spec in AGENT_SPECS:
            target_dir = f".openclaw_config/agents/{spec['id']}"
            os.makedirs(target_dir, exist_ok=True)
            run_command(f"ln -sfn /workspace/agents/{spec['id']} {target_dir}/agent")
        print("✅ 에이전트 디스커버리용 심볼릭 링크 생성 완료")
    except Exception as exc:
        print(f"⚠️ 심볼릭 링크 생성 중 오류: {exc}")


def _default_openclaw_config() -> dict:
    return {
        "agents": {
            "defaults": {"workspace": "/workspace"},
            "list": [
                {
                    "id": spec["id"],
                    "name": spec["name"],
                    "workspace": spec["workspace"],
                    "agentDir": spec["workspace"],
                }
                for spec in AGENT_SPECS
            ],
        }
    }


def patch_openclaw_config(
    gemini_api_key: str,
    tag: str,
    openclaw_gateway_token: str | None = None,
    gateway_port: int = 18790,
) -> bool:
    """Create or patch ``.openclaw_config/openclaw.json`` for the runtime role."""
    path = ".openclaw_config/openclaw.json"

    os.makedirs(".openclaw_config", exist_ok=True)
    run_command("chmod 777 .openclaw_config")

    if os.path.exists(path):
        run_command(f"chmod 666 {path}")

    if not os.path.exists(path):
        print(f"ℹ️ {path} 가 존재하지 않습니다. 기본 설정을 생성합니다.")
        with open(path, "w", encoding="utf-8") as handle:
            json.dump(_default_openclaw_config(), handle, indent=2)

    try:
        with open(path, "r", encoding="utf-8") as handle:
            config = json.load(handle)

        config["gateway"] = config.get("gateway", {})
        config["gateway"]["remote"] = {"url": f"ws://127.0.0.1:{gateway_port}"}
        config["gateway"]["mode"] = "remote"

        if openclaw_gateway_token:
            config["gateway"]["auth"] = {"mode": "token", "token": openclaw_gateway_token}
            remote_cfg = config["gateway"].setdefault("remote", {})
            remote_cfg["token"] = openclaw_gateway_token
        else:
            config["gateway"].pop("auth", None)
            config.get("gateway", {}).get("remote", {}).pop("token", None)

        target_model = MODEL_MAP.get(tag, "google/gemini-3-flash-preview")
        print(f"🎯 타겟 모델 설정: {target_model} (Role/Tag: {tag})")

        agents_config = config.setdefault("agents", {})
        defaults = agents_config.setdefault("defaults", {})
        model_defaults = defaults.setdefault("model", {})
        model_defaults["primary"] = target_model

        for agent in agents_config.get("list", []):
            agent_model = agent.setdefault("model", {})
            agent_model["primary"] = target_model

        providers = config.setdefault("models", {}).setdefault("providers", {})

        google_prov = providers.setdefault("google", {})
        google_prov["baseUrl"] = "https://generativelanguage.googleapis.com/v1beta"
        google_prov["apiKey"] = gemini_api_key
        google_models = google_prov.setdefault("models", [])
        if target_model.startswith("google/"):
            google_models = [m for m in google_models if m.get("id") != target_model]
            google_models.insert(0, {"id": target_model, "name": target_model.split("/")[-1]})
        google_prov["models"] = google_models

        worker_base_url = os.getenv("WORKER_BASE_URL", "http://127.0.0.1:8080/v1")
        openai_prov = providers.setdefault("openai", {})
        openai_prov["baseUrl"] = worker_base_url
        openai_prov["apiKey"] = os.getenv("WORKER_API_KEY", "not-needed")
        openai_models = openai_prov.setdefault("models", [])
        if target_model.startswith("openai/"):
            actual_model_id = target_model.replace("openai/", "", 1)
            openai_models = [m for m in openai_models if m.get("id") != actual_model_id]
            openai_models.insert(0, {"id": actual_model_id, "name": "Local Qwen2.5 Coder"})
        openai_prov["models"] = openai_models

        old_ws = config.get("agents", {}).get("defaults", {}).get("workspace")
        if old_ws:
            config_str = json.dumps(config)
            config = json.loads(config_str.replace(old_ws, "/workspace"))

        config["models"]["providers"] = providers

        with open(path, "w", encoding="utf-8") as handle:
            json.dump(config, handle, indent=2)
        print(f"✅ OpenClaw 설정 패치 완료 (포트: {gateway_port}, 워커 URL: {worker_base_url})")
        return True
    except Exception as exc:
        print(f"❌ 설정 패치 중 오류 발생: {exc}")
        return False

