# 🛠️ NightWatch Tasks


## [PRO] 위키 전면 재구성: 1. AI Agent System (doc/ai-agents/)
**목표:** OpenClaw 기반 Discord 에이전트 연동 및 NightWatch 아키텍처 문서화
**세부 작업:**
1. `doc/ai-agents/` 디렉토리 생성
2. `01_openclaw_discord_setup.md` 신규 작성: OpenClaw Discord 봇 연결, `patch_openclaw_config.py` 동작 방식 설명
3. `02_multi_agent_personas.md` 신규 작성: `@math-typst-specialist`와 `@tool-architect` 권한 분리 및 역할 가이드
4. 기존 `doc/nightwatch/NIGHTWATCH_BLUEPRINT.md`, `nightwatch_guide.md`, `README.md`를 통합하여 `03_nightwatch_architecture.md`로 재작성 후 `doc/ai-agents/`로 이동
5. 작업 완료 후 기존 `doc/nightwatch/` 디렉토리 삭제

## [FLASH] 위키 전면 재구성: 2. Infrastructure (doc/infrastructure/)
**목표:** 로컬 구동 스크립트 및 모바일 서빙 환경 문서화
**세부 작업:**
1. `doc/infrastructure/` 디렉토리 생성
2. `01_workspace_startup.md` 신규 작성: `start_workspace.sh`의 tmux 세션 분리, Python HTTP 서버, 컨테이너 실행 흐름 설명
3. `02_tailscale_mobile_serving.md` 신규 작성: Tailscale Serve를 통한 외부(iPad/iPhone) 접속 및 실시간 PDF 렌더링 확인 방법 작성

## [FLASH] 위키 전면 재구성: 3. Typst & Mathematics (doc/typst-math/)
**목표:** Typst 문서 작성 워크플로우 및 수학 노트 가이드 정리
**세부 작업:**
1. `doc/typst-math/` 디렉토리 생성
2. `01_project_structure.md` 신규 작성: `Typst_project/` 내부 폴더 구조 및 `main.typ` 컴파일 흐름 안내
3. 기존 `doc/pdf_to_Typst_guide.md`를 `doc/typst-math/02_pdf_to_typst_guide.md`로 이동 및 내용 다듬기

## [FLASH] 위키 전면 재구성: 4. Guidelines (doc/guidelines/)
**목표:** 개발 및 작성 컨벤션 문서 정리 (CodeCompanion 내용 제외)
**세부 작업:**
1. `doc/guidelines/` 디렉토리 생성
2. 기존 `doc/code_style_guide.md`를 `doc/guidelines/01_code_style_guide.md`로 이동
3. 기존 `rules/typst-code-style-guide.md` 내용을 `doc/guidelines/02_typst_style_guide.md`로 통합 또는 참조 문서로 이동
4. (기존 `Neovim_CodeCompanion_가이드.md`는 재구성에 포함하지 않음)

## [FLASH] 위키 전면 재구성: 5. Project Management (doc/project-management/)
**목표:** 이슈 트래킹 및 로드맵 문서화
**세부 작업:**
1. `doc/project-management/` 디렉토리 생성
2. `01_tasks_workflow.md` 신규 작성: `TASKS.md`의 `[FLASH]`/`[PRO]` 태그 기반 작업 지시 방법 및 워크플로우 설명
3. 기존 `doc/ToDolist.md`를 `doc/project-management/02_roadmap_and_todo.md`로 이동 및 내용 최신화
