"""Build token-bounded context packs from task input and memory retrieval."""

from __future__ import annotations

from typing import Iterable

from nightwatch.context_extractors import estimate_tokens, truncate_text


TASK_TYPE_QUOTAS = {
    "ci_fix": {
        "decisions": {"min": 1, "max": 2},
        "files": {"min": 1, "max": 2},
        "logs": {"min": 1, "max": 2},
        "tasks": {"min": 0, "max": 1},
        "other": {"min": 0, "max": 0},
    },
    "math_typst": {
        "decisions": {"min": 0, "max": 1},
        "files": {"min": 2, "max": 3},
        "logs": {"min": 0, "max": 0},
        "tasks": {"min": 1, "max": 2},
        "other": {"min": 0, "max": 1},
    },
    "general": {
        "decisions": {"min": 0, "max": 2},
        "files": {"min": 1, "max": 2},
        "logs": {"min": 0, "max": 1},
        "tasks": {"min": 0, "max": 2},
        "other": {"min": 0, "max": 1},
    },
}


def _render_lines(items: Iterable[str], prefix: str = "- ") -> str:
    lines = [prefix + item for item in items if item]
    return "\n".join(lines)


def _trim_to_tokens(text: str, token_cap: int) -> str:
    if estimate_tokens(text) <= token_cap:
        return text
    char_cap = max(80, token_cap * 4)
    return truncate_text(text, char_cap)


def _select_entries(task_type: str, retrieved: dict) -> tuple[dict, dict]:
    quotas = TASK_TYPE_QUOTAS.get(task_type, TASK_TYPE_QUOTAS["general"])
    selected: dict[str, list[dict]] = {}
    quota_meta: dict[str, dict] = {}

    for kind in ("decisions", "files", "logs", "tasks", "other"):
        items = list(retrieved.get(kind, []))
        max_items = quotas.get(kind, {}).get("max", len(items))
        min_items = quotas.get(kind, {}).get("min", 0)
        chosen = items[:max_items]
        selected[kind] = chosen
        quota_meta[kind] = {
            "available": len(items),
            "selected": len(chosen),
            "min": min_items,
            "max": max_items,
        }

    return selected, quota_meta


def format_quota_debug(quota_meta: dict) -> str:
    parts = []
    for kind in ("decisions", "files", "logs", "tasks", "other"):
        meta = quota_meta.get(kind)
        if not meta:
            continue
        parts.append(
            f"{kind}={meta['selected']}/{meta['available']} (min={meta['min']}, max={meta['max']})"
        )
    return " | ".join(parts)


def build_context_pack(
    title: str,
    body: str,
    task_type: str,
    session_state: dict | None = None,
    working_summary: str = "",
    retrieved: dict | None = None,
    log_excerpt: str = "",
    plan_summary: str = "",
    relevant_paths: list[str] | None = None,
    budget_tokens: int = 18000,
) -> tuple[str, dict]:
    session_state = session_state or {}
    retrieved = retrieved or {"decisions": [], "files": [], "logs": [], "tasks": [], "other": []}
    relevant_paths = relevant_paths or []
    selected_retrieved, quota_meta = _select_entries(task_type, retrieved)

    sections: list[tuple[str, str, int]] = []
    sections.append(("GOAL", f"Task: {title}\nType: {task_type}", 800))

    if session_state:
        current_state_lines = []
        if session_state.get("active_task"):
            current_state_lines.append(f"Active task: {session_state['active_task']}")
        if session_state.get("recent_files"):
            current_state_lines.append(f"Recent files: {', '.join(session_state['recent_files'][:6])}")
        if session_state.get("known_constraints"):
            current_state_lines.extend(session_state["known_constraints"][:4])
        sections.append(("CURRENT_STATE", "\n".join(current_state_lines), 1200))

    if working_summary:
        sections.append(("WORKING_SUMMARY", working_summary.strip(), 1200))

    if relevant_paths:
        sections.append(("RELEVANT_PATHS", _render_lines(relevant_paths), 800))

    if selected_retrieved.get("decisions"):
        sections.append(
            (
                "RETRIEVED_DECISIONS",
                _render_lines(entry["summary"] for entry in selected_retrieved["decisions"]),
                1800,
            )
        )

    if selected_retrieved.get("files"):
        sections.append(
            (
                "RELEVANT_FILE_SUMMARIES",
                _render_lines(
                    f"{entry.get('path', 'unknown')}: {entry['summary']}" for entry in selected_retrieved["files"]
                ),
                2200,
            )
        )

    if selected_retrieved.get("tasks"):
        sections.append(
            ("RELATED_TASK_MEMORY", _render_lines(entry["summary"] for entry in selected_retrieved["tasks"]), 1400)
        )

    if selected_retrieved.get("logs"):
        sections.append(("RELATED_LOG_MEMORY", _render_lines(entry["summary"] for entry in selected_retrieved["logs"]), 1200))

    if selected_retrieved.get("other"):
        sections.append(("OTHER_MEMORY", _render_lines(entry["summary"] for entry in selected_retrieved["other"]), 900))

    if plan_summary:
        sections.append(("PLAN_SUMMARY", plan_summary.strip(), 1600))

    if log_excerpt:
        sections.append(("LOG_EXCERPT", log_excerpt.strip(), 2600))

    sections.append(("TASK_BODY", body.strip(), 2600))

    packed_sections: list[str] = []
    used_tokens = 0
    omitted: list[str] = []

    for name, content, token_cap in sections:
        if not content.strip():
            continue
        trimmed = _trim_to_tokens(content.strip(), token_cap)
        section_text = f"[{name}]\n{trimmed}"
        section_tokens = estimate_tokens(section_text)
        if used_tokens + section_tokens > budget_tokens:
            omitted.append(name)
            continue
        packed_sections.append(section_text)
        used_tokens += section_tokens

    metadata = {
        "used_tokens_estimate": used_tokens,
        "budget_tokens": budget_tokens,
        "omitted_sections": omitted,
        "quota": quota_meta,
    }
    return "\n\n".join(packed_sections), metadata
