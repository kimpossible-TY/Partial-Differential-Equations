"""Permission mutation helpers for NightWatch agents."""

from __future__ import annotations

import os


def _rewrite_permissions(old_snippet: str, new_snippet: str, action_label: str) -> None:
    agents_dir = "agents"
    if not os.path.exists(agents_dir):
        return

    for agent_id in os.listdir(agents_dir):
        manifest_path = os.path.join(agents_dir, agent_id, "manifest.yaml")
        if not os.path.exists(manifest_path):
            continue

        try:
            with open(manifest_path, "r", encoding="utf-8") as handle:
                content = handle.read()

            new_content = content.replace(old_snippet, new_snippet)

            with open(manifest_path, "w", encoding="utf-8") as handle:
                handle.write(new_content)
            print(f"{action_label}: {agent_id}")
        except Exception as exc:
            print(f"⚠️ 에이전트 {agent_id} 권한 변경 중 오류: {exc}")


def elevate_agent_permissions() -> None:
    _rewrite_permissions(
        "    write:\n      - \"../../TASKS.md\"",
        "    write:\n      - \"../../**/*\"",
        "🔓 에이전트 권한 승격 완료",
    )


def restore_agent_permissions() -> None:
    _rewrite_permissions(
        "    write:\n      - \"../../**/*\"",
        "    write:\n      - \"../../TASKS.md\"",
        "🔒 에이전트 권한 복구 완료",
    )

