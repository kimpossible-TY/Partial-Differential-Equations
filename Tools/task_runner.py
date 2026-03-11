#!/usr/bin/env python3
"""
Project NightWatch — Task Parser & Model Router
TASKS.md를 파싱하여 첫 번째 미완료 태스크를 추출하고,
태그에 따라 OpenClaw 호출 모델을 결정합니다.
"""

import re
import sys
import json
from pathlib import Path

# ==============================================================================
# 설정
# ==============================================================================

WORKSPACE_ROOT = Path(__file__).parent.parent  # tools/ 상위 = 프로젝트 루트
TASKS_FILE = WORKSPACE_ROOT / "TASKS.md"

MODEL_ROUTES = {
    "FLASH": "google/gemini-3.0-flash",
    "PRO": "google/gemini-3.1-pro-preview",
}

# ==============================================================================
# 파서
# ==============================================================================


def parse_next_task(tasks_path: Path) -> dict | None:
    """
    TASKS.md에서 첫 번째 미완료 항목을 파싱합니다.
    
    지원 포맷:
        ## [FLASH] 제목
        ## [PRO] 제목

    완료 항목(# [x])은 스킵합니다.
    
    Returns:
        {"tag": "FLASH"|"PRO", "title": str, "body": str, "model": str} or None
    """
    if not tasks_path.exists():
        print(f"❌ TASKS.md 파일을 찾을 수 없습니다: {tasks_path}", file=sys.stderr)
        return None

    content = tasks_path.read_text(encoding="utf-8")

    # 미완료 태스크 블록 파싱 (## [TAG] 로 시작하는 섹션)
    # completed 마커(# [x])가 바로 앞에 있으면 스킵
    pattern = re.compile(
        r"^##\s+\[(FLASH|PRO)\]\s+(.+?)$",
        re.MULTILINE
    )

    for match in pattern.finditer(content):
        # 이 매치 앞에 [x] 완료 마커가 있는지 확인
        preceding = content[:match.start()].rstrip()
        # 직전 라인이 '# [x]' 또는 완료 표시이면 스킵
        prev_lines = preceding.split("\n")
        last_meaningful = next(
            (line.strip() for line in reversed(prev_lines) if line.strip()), ""
        )
        if last_meaningful.startswith("# [x]") or last_meaningful.startswith("[x]"):
            continue

        tag = match.group(1)          # "FLASH" or "PRO"
        title = match.group(2).strip()

        # 이 섹션의 본문 추출 (다음 ## 섹션 전까지)
        body_start = match.end()
        next_section = re.search(r"^##\s", content[body_start:], re.MULTILINE)
        body_end = body_start + next_section.start() if next_section else len(content)
        body = content[body_start:body_end].strip()

        model = MODEL_ROUTES.get(tag, MODEL_ROUTES["PRO"])

        return {
            "tag": tag,
            "title": title,
            "body": body,
            "model": model,
        }

    return None  # 미완료 태스크 없음


def mark_task_done(tasks_path: Path, title: str) -> None:
    """완료된 태스크를 TASKS.md에서 [x]로 마킹합니다."""
    content = tasks_path.read_text(encoding="utf-8")
    # 해당 제목을 찾아 앞에 # [x] 삽입
    pattern = re.compile(
        r"(##\s+\[(?:FLASH|PRO)\]\s+" + re.escape(title) + r")",
        re.MULTILINE
    )
    updated = pattern.sub(r"# [x] \1", content, count=1)
    tasks_path.write_text(updated, encoding="utf-8")
    print(f"✅ 태스크 완료 마킹: {title}")


# ==============================================================================
# 메인 실행
# ==============================================================================


def main():
    task = parse_next_task(TASKS_FILE)

    if task is None:
        print("🎉 모든 태스크가 완료되었습니다!")
        sys.exit(0)

    print(f"\n{'=' * 60}")
    print("📋 다음 태스크")
    print(f"{'=' * 60}")
    print(f"  태그   : [{task['tag']}]")
    print(f"  제목   : {task['title']}")
    print(f"  모델   : {task['model']}")
    print(f"  본문   :\n{task['body']}")
    print(f"{'=' * 60}\n")

    # JSON 출력 (다른 스크립트에서 파이프로 받을 때 사용)
    if "--json" in sys.argv:
        print(json.dumps(task, ensure_ascii=False, indent=2))
        return

    # --mark-done: 태스크 완료 마킹 모드
    if "--mark-done" in sys.argv:
        mark_task_done(TASKS_FILE, task["title"])
        return


if __name__ == "__main__":
    main()
