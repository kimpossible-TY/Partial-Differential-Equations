"""Context extraction and lightweight summarization helpers."""

from __future__ import annotations

import os
import re
from pathlib import Path


PATH_PATTERN = re.compile(r"(?<!\S)([A-Za-z0-9_.\-/]+(?:\.[A-Za-z0-9_]+))(?!\S)")
KEYWORD_PATTERN = re.compile(r"[A-Za-z][A-Za-z0-9_\-]{2,}")
ERROR_PATTERN = re.compile(
    r"(error|exception|traceback|failed|failure|cannot|can't|undefined|missing)",
    re.IGNORECASE,
)


def estimate_tokens(text: str) -> int:
    return max(1, len(text) // 4)


def clean_whitespace(text: str) -> str:
    return re.sub(r"\n{3,}", "\n\n", text.strip())


def truncate_text(text: str, limit: int) -> str:
    if len(text) <= limit:
        return text
    return text[: max(0, limit - 3)].rstrip() + "..."


def extract_keywords(text: str, limit: int = 12) -> list[str]:
    seen: list[str] = []
    for match in KEYWORD_PATTERN.findall(text.lower()):
        if match in {"the", "and", "that", "with", "from", "this", "task", "plan"}:
            continue
        if match not in seen:
            seen.append(match)
        if len(seen) >= limit:
            break
    return seen


def extract_relevant_paths(*texts: str) -> list[str]:
    paths: list[str] = []
    for text in texts:
        for match in PATH_PATTERN.findall(text or ""):
            if "/" not in match and "." not in match:
                continue
            candidate = match.strip("`'\"()[]{}")
            if candidate not in paths:
                paths.append(candidate)
    return paths


def summarize_text(text: str, max_lines: int = 8, max_chars: int = 700) -> str:
    lines = [line.strip() for line in text.splitlines() if line.strip()]
    if not lines:
        return ""
    summary = "\n".join(lines[:max_lines])
    return truncate_text(summary, max_chars)


def summarize_file(path: str | Path, max_chars: int = 700) -> str:
    file_path = Path(path)
    if not file_path.exists() or not file_path.is_file():
        return ""
    try:
        content = file_path.read_text(encoding="utf-8", errors="ignore")
    except OSError:
        return ""

    lines = [line.rstrip() for line in content.splitlines()]
    non_empty = [line for line in lines if line.strip()]
    head = "\n".join(non_empty[:10])
    return truncate_text(head, max_chars)


def summarize_plan_file(path: str | Path = "plan.md", max_chars: int = 900) -> str:
    plan_path = Path(path)
    if not plan_path.exists():
        return ""
    return summarize_text(plan_path.read_text(encoding="utf-8", errors="ignore"), max_lines=12, max_chars=max_chars)


def extract_log_excerpt(log_text: str, context_lines: int = 20, max_chars: int = 2500) -> str:
    lines = log_text.splitlines()
    if not lines:
        return ""

    hit_indexes = [idx for idx, line in enumerate(lines) if ERROR_PATTERN.search(line)]
    if not hit_indexes:
        excerpt = "\n".join(lines[-80:])
        return truncate_text(excerpt, max_chars)

    chunks: list[str] = []
    used_ranges: list[tuple[int, int]] = []
    for idx in hit_indexes[:3]:
        start = max(0, idx - context_lines)
        end = min(len(lines), idx + context_lines + 1)
        if any(not (end < a or start > b) for a, b in used_ranges):
            continue
        used_ranges.append((start, end))
        chunks.append("\n".join(lines[start:end]))

    return truncate_text(clean_whitespace("\n\n".join(chunks)), max_chars)


def classify_task_type(title: str, body: str) -> str:
    haystack = f"{title}\n{body}".lower()
    if any(token in haystack for token in ("ci", "workflow", "github actions", "build failed")):
        return "ci_fix"
    if any(token in haystack for token in ("typst", "math", "pde", "riemann")):
        return "math_typst"
    return "general"


def infer_recent_files(paths: list[str]) -> list[str]:
    existing: list[str] = []
    for path in paths:
        if os.path.exists(path) and path not in existing:
            existing.append(path)
    return existing[:8]

