# ==============================================================================
# Project NightWatch — Task Queue
# 포맷: ## [TAG] 제목 (TAG: FLASH 또는 PRO)
#   - FLASH: 단순 버그픽스, 문서화, 린팅 (→ gemini-3.0-flash)
#   - PRO:   아키텍처, 복잡한 로직, 의존성 얽힌 이슈 (→ gemini-3.1-pro-preview)
# ==============================================================================

# ✅ 완료된 작업
# [x] [FLASH] Fix footnote numbering reset per chapter

# 🔄 대기 중인 작업 (상단 항목부터 처리)

## [FLASH] Example: Fix minor Typst compilation warning in `main.typ`
- 파일: `main.typ`
- 현상: 경고 메시지 발생 (실제 렌더링 영향 없음)
- 목표: 경고 제거

## [PRO] Example: Redesign Preliminaries section structure
- 파일: `Preliminaries/`
- 현상: 현재 구조가 PDE 흐름과 맞지 않음
- 목표: Architecture_Plan.md 먼저 생성 후 승인받아 리팩터링
