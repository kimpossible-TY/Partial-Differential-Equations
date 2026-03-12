# ==============================================================================
# Project NightWatch — Task Queue
# 포맷: ## [TAG] 제목 (TAG: FLASH 또는 PRO)
#   - FLASH: 단순 버그픽스, 문서화, 린팅 (→ gemini-3.0-flash)
#   - PRO:   아키텍처, 복잡한 로직, 의존성 얽힌 이슈 (→ gemini-3.1-pro-preview)
# ==============================================================================

# ✅ 완료된 작업
# [x] [FLASH] Fix footnote numbering reset per chapter

# 🔄 대기 중인 작업 (상단 항목부터 처리)

## [FLASH] Doc 디렉터리 정리 및 NightWatch 문서 체계화
- 목표: `Doc/` 디렉터리 루트를 정리하고 NightWatch 관련 지식을 체계적으로 구조화합니다.
- 세부 작업:
    1. `Doc/nightwatch/` 디렉터리 생성.
    2. `Doc/nightwatch_guide.md`를 해당 디렉터리로 이동 및 보강.
    3. 지금까지의 작업 내역(이중 레이어 부트스트랩, 권한 이슈 해결, 아키텍처 등)을 포함한 `README.md`를 `Doc/nightwatch/` 내에 작성.
    4. 프로젝트 루트의 `walkthrough.md` 등 임시 문서들을 `Doc/nightwatch/`로 통합 정리.
- 기대 결과: `Doc/` 하위가 깔끔해지고, NightWatch 시스템을 한눈에 파악할 수 있는 문서 구조 완성.