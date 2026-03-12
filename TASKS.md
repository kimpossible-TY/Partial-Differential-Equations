# ==============================================================================
# Project NightWatch — Task Queue
# 포맷: ## [TAG] 제목 (TAG: FLASH 또는 PRO)
#   - FLASH: 단순 버그픽스, 문서화, 린팅 (→ gemini-3.0-flash)
#   - PRO:   아키텍처, 복잡한 로직, 의존성 얽힌 이슈 (→ gemini-3.1-pro-preview)
# ==============================================================================

# ✅ 완료된 작업
# [x] [FLASH] Fix footnote numbering reset per chapter

# 🔄 대기 중인 작업 (상단 항목부터 처리)

## [FLASH] Final Handoff Test: Create 'HANDOFF_SUCCESS.md'
- 목표: `./nightwatch.sh` 스크립트가 정상적으로 워크플로우를 트리거하고 에이전트가 작업을 수행하는지 최종 확인합니다.
- 기대 결과: 에이전트가 `HANDOFF_SUCCESS.md` 파일을 생성하고 PR을 올려야 함.

## [FLASH] E2E Verification: Create NightWatch status file
- 목표: 시스템이 정상 작동하는지 확인하기 위해 `STATUS_NIGHTWATCH.md` 파일을 생성하고 시스템 정보를 기록합니다.
- 기대 결과: NightWatch가 이 태스크를 읽고 파일을 생성한 뒤 PR을 자동으로 올려야 함.

## [FLASH] Example: Fix minor Typst compilation warning in `main.typ`
- 파일: `main.typ`
- 현상: 경고 메시지 발생 (실제 렌더링 영향 없음)
- 목표: 경고 제거

## [PRO] Example: Redesign Preliminaries section structure
- 파일: `Preliminaries/`
- 현상: 현재 구조가 PDE 흐름과 맞지 않음
- 목표: Architecture_Plan.md 먼저 생성 후 승인받아 리팩터링
