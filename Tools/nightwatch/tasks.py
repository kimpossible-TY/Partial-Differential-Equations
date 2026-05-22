"""Task parsing and completion helpers for NightWatch."""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path


WORKSPACE_ROOT = Path(__file__).resolve().parents[2]
TASKS_FILE = WORKSPACE_ROOT / "TASKS.md"

MODEL_ROUTES = {
    "LITE": "google/gemini-3.1-flash-lite-preview",
    "FLASH": "google/gemini-3-flash-preview",
    "PRO": "google/gemini-3.1-pro-preview",
}

MODEL_COSTS = {
    "LITE": 500,
    "FLASH": 2000,
    "PRO": 15000,
}

TASK_PATTERN = re.compile(
    r"^##\s+(?:\[(?:LITE|FLASH|PRO)\]\s+)?(.+?)$",
    re.MULTILINE,
)


def parse_tasks(tasks_path: Path, get_all: bool = False) -> list | dict | None:
    """Parse unfinished tasks from ``TASKS.md``."""
    if not tasks_path.exists():
        print(f"❌ TASKS.md 파일을 찾을 수 없습니다: {tasks_path}", file=sys.stderr)
        return [] if get_all else None

    content = tasks_path.read_text(encoding="utf-8")
    tasks: list[dict] = []

    for match in TASK_PATTERN.finditer(content):
        preceding = content[:match.start()].rstrip()
        prev_lines = preceding.split("\n")
        last_meaningful = next((line.strip() for line in reversed(prev_lines) if line.strip()), "")
        if last_meaningful.startswith("# [x]") or last_meaningful.startswith("[x]"):
            continue

        title = match.group(1).strip()
        body_start = match.end()
        next_section = re.search(r"^##\s", content[body_start:], re.MULTILINE)
        body_end = body_start + next_section.start() if next_section else len(content)
        body = content[body_start:body_end].strip()

        task = {
            "tag": "HYBRID",
            "title": title,
            "body": body,
            "model": "google/gemini-3.1-pro-preview",
        }

        if not get_all:
            return task
        tasks.append(task)

    return tasks if get_all else None


def mark_task_done(tasks_path: Path, title: str) -> None:
    """Mark a matching task section as completed."""
    content = tasks_path.read_text(encoding="utf-8")
    pattern = re.compile(
        r"(##\s+(?:\[(?:LITE|FLASH|PRO)\]\s+)?" + re.escape(title) + r")",
        re.MULTILINE,
    )
    updated = pattern.sub(r"# [x] \1", content, count=1)
    tasks_path.write_text(updated, encoding="utf-8")
    print(f"✅ 태스크 완료 마킹: {title}")


def main() -> None:
    get_all = "--all" in sys.argv
    result = parse_tasks(TASKS_FILE, get_all)
    is_empty = (result is None) if not get_all else (len(result) == 0)

    if is_empty:
        if "--json" in sys.argv:
            print(json.dumps({"error": "모든 태스크가 완료되었습니다."}, ensure_ascii=False))
        else:
            print("🎉 모든 태스크가 완료되었습니다!")
        sys.exit(0)

    if "--json" in sys.argv:
        print(json.dumps(result, ensure_ascii=False))
        return

    if "--mark-done" in sys.argv:
        if not get_all:
            mark_task_done(TASKS_FILE, result["title"])
        return

    if get_all:
        print(f"\n{'=' * 60}")
        print(f"📋 대기 중인 태스크: {len(result)}개")
        print(f"{'=' * 60}")
        for idx, task in enumerate(result, 1):
            print(f"[{idx}] {task['tag']} | {task['title']}")
        return

    print(f"\n{'=' * 60}")
    print("📋 다음 태스크")
    print(f"{'=' * 60}")
    print(f"  태그   : [{result['tag']}]")
    print(f"  제목   : {result['title']}")
    print(f"  모델   : {result['model']}")
    print(f"  본문   :\n{result['body']}")
    print(f"{'=' * 60}\n")


if __name__ == "__main__":
    main()
