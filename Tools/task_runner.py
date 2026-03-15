#!/usr/bin/env python3
"""
Project NightWatch — Task Parser & Model Router
TASKS.md를 파싱하여 첫 번째(또는 모든) 미완료 태스크를 추출하고,
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


def parse_tasks(tasks_path: Path, get_all: bool = False) -> list | dict | None:
    """
    TASKS.md에서 미완료 항목을 파싱합니다.
    get_all=True 인 경우 모든 미완료 태스크를 리스트로 반환합니다.
    get_all=False 인 경우 첫 번째 미완료 태스크만 dict로 반환합니다.

    지원 포맷:
        ## [FLASH] 제목
        ## [PRO] 제목

    완료 항목(# [x])은 스킵합니다.
    """
    if not tasks_path.exists():
        print(f"❌ TASKS.md 파일을 찾을 수 없습니다: {tasks_path}", file=sys.stderr)
        return [] if get_all else None

    content = tasks_path.read_text(encoding="utf-8")

    # 미완료 태스크 블록 파싱 (## [TAG] 로 시작하는 섹션)
    pattern = re.compile(
        r"^##\s+\[(FLASH|PRO)\]\s+(.+?)$",
        re.MULTILINE
    )

    tasks = []

    for match in pattern.finditer(content):
        # 이 매치 앞에 [x] 완료 마커가 있는지 확인
        preceding = content[:match.start()].rstrip()
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

        task = {
            "tag": tag,
            "title": title,
            "body": body,
            "model": model,
        }

        if not get_all:
            return task
        
        tasks.append(task)

    if not get_all:
        return None
    return tasks


def mark_task_done(tasks_path: Path, title: str) -> None:
    """완료된 태스크를 TASKS.md에서 [x]로 마킹합니다."""
    content = tasks_path.read_text(encoding="utf-8")
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
    get_all = "--all" in sys.argv
    result = parse_tasks(TASKS_FILE, get_all)

    # Empty logic
    is_empty = (result is None) if not get_all else (len(result) == 0)

    if is_empty:
        if "--json" in sys.argv:
            print(json.dumps({"error": "모든 태스크가 완료되었습니다."}, ensure_ascii=False))
        else:
            print("🎉 모든 태스크가 완료되었습니다!")
        sys.exit(0)

    # JSON 출력 모드
    if "--json" in sys.argv:
        print(json.dumps(result, ensure_ascii=False))
        return

    # --mark-done: 태스크 완료 마킹 모드 (단일 모드일 때만 적용 혹은 특정 title 지정)
    if "--mark-done" in sys.argv:
        if not get_all:
            mark_task_done(TASKS_FILE, result["title"])
        return

    # 일반 사용자용 출력
    if get_all:
        print(f"\n{'=' * 60}")
        print(f"📋 대기 중인 태스크: {len(result)}개")
        print(f"{'=' * 60}")
        for idx, task in enumerate(result, 1):
            print(f"[{idx}] {task['tag']} | {task['title']}")
    else:
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