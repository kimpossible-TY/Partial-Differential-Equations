# 🛠️ NightWatch Tasks

## [PRO] NightWatch 다중 태스크 병렬 및 순차 처리 기능 구현 (Adaptive Mode)

아래의 작업 정보를 참고하여 해당 작업이 잘 되었는지를 확인하는 파이썬 코드를 작성할 것  이 때 flake8 테스트에 유의  

---
**목표:** `nightwatch.sh`와 `nightwatch_executor.py`의 구조를 개선하여, `TASKS.md`에 여러 개의 미완료 태스크가 있을 때 이를 어떻게 처리할지 사용자에게 선택지(병렬 또는 순차)를 제공하고 다중 태스크를 올바르게 처리하도록 수정합니다.

### 작업 지침:

1. **`Tools/task_runner.py` 수정 (전체 태스크 반환 기능)**
   - `--all` 플래그를 추가합니다.
   - 이 플래그가 전달되면, 정규표현식을 수정하여 파일 내에 존재하는 **모든 미완료 태스크**(`## [TAG] Title` 형식으로 시작하되, 바로 윗줄에 완료 마커 `# [x]`가 없는 항목)를 찾아 배열 형태로 반환하도록 만드세요.
   - 단일 항목을 반환하던 기존의 하위 호환성은 유지해야 합니다.

2. **`nightwatch.sh` 수정 (적응형 프롬프트 및 브랜칭 로직)**
   - `task_runner.py --all --json`을 호출하여 반환된 JSON 배열의 길이를 확인합니다.
   - **태스크 개수가 1개인 경우:** 기존 로직대로 단일 브랜치(`nightwatch/title-slug`)를 생성하고 GitHub Actions 워크플로우를 즉시 트리거합니다.
   - **태스크 개수가 2개 이상인 경우:** 
     사용자에게 프롬프트를 띄워 다음과 같이 물어봅니다.
     ```
     여러 개의 태스크(N)가 대기 중입니다. 어떻게 실행하시겠습니까?
     [P]arallel: 병렬 실행 (각 태스크마다 독립된 브랜치/VM 생성)
     [S]eries  : 순차 실행 (하나의 브랜치에서 일괄 처리)
     ```
   - **사용자가 P(Parallel) 선택 시:** 배열 내 각 태스크마다 고유한 브랜치명(`nightwatch/title-timestamp`)을 생성하고, 각각의 태스크 정보만 담은 임시 파일(또는 단일 태스크 처리)을 커밋한 후 GitHub Actions를 개별적으로 트리거합니다.
   - **사용자가 S(Series) 선택 시:** 하나의 공통 브랜치(`nightwatch/bulk-run-timestamp`)를 생성하고, 전체 태스크 JSON 배열을 파일(`nightwatch_bulk_tasks.json` 등)로 저장 및 커밋한 후, 한 번만 워크플로우를 트리거합니다.

3. **`Tools/nightwatch_executor.py` 수정 (루프 기반 순차 실행 및 버그 수정)**
   - 스크립트 실행 초기에 `nightwatch_bulk_tasks.json` 파일의 존재 여부를 확인합니다.
   - 파일이 존재하면(Series 모드), 파일에 담긴 태스크 배열을 로드하고 **해당 파일을 즉시 삭제(및 git rm)** 합니다. (이는 태스크 커밋 시 큐 파일이 포함되지 않게 하기 위함입니다)
   - 파일이 없으면 기존처럼 단일 환경변수(`TAG`, `TITLE`)를 읽어 단일 태스크로 취급합니다.
   - **핵심 루프:** 로드된 태스크 개수만큼 반복문을 돕니다.
     - 각 태스크에 대해: 
       1) `.openclaw_config` 패치 및 토큰 생성
       2) `openclaw-gateway` 도커 컨테이너 기동 (`sleep 5` 대기)
       3) `nightwatch-agent` 도커 컨테이너를 실행하여 에이전트 작업 지시
       4) `openclaw-gateway` 종료 (`docker compose stop openclaw-gateway`)
       5) `git add .` 및 `git commit` (각 태스크마다 개별 커밋)
   - 권한 승격(`elevate_agent_permissions()`)은 루프 시작 전에 한 번만 하고, 권한 복구(`restore_agent_permissions()`)는 모든 루프가 끝난 뒤 `finally` 블록에서 안전하게 수행되도록 변경하세요.
   - **버그 수정:** 현재 파일에 `run_command(" ".join(agent_cmd))` 가 중복으로 두 번 연달아 호출되는 오타가 있습니다. 이를 찾아 하나를 제거하세요.

4. 위 사항을 모두 구현한 후, `TASKS.md`의 본 항목을 완료(`# [x]`) 처리합니다.
