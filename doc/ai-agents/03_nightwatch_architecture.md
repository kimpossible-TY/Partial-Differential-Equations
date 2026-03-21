# Project NightWatch — E2E 자율 개발 통제 파이프라인 설계도

> **목표**: iPad + Blink Shell의 제한된 모바일 환경에서, 사용자가 지휘관으로서 AI 자율 개발 시스템을 완벽히 통제한다.

---

## 아키텍처 대원칙

| 원칙 | 설명 |
|---|---|
| **결정론적 라우팅** | 모델 선택은 전적으로 `TASKS.md`의 태그가 결정. AI의 재량 없음. |
| **물리적 격리** | AI는 `tests/` 디렉터리에 쓰기 불가 (컨테이너 read-only 마운트). |
| **무관용 병합 통제** | CI(자동)는 필요조건. 병합(Merge)은 오직 인간의 승인에 종속. |

---

## 시스템 구성도

```
[외부 cron/스케줄러]
        │ 야간 트리거
        ▼
[Phase 1: 컨테이너 샌드박스 (OrbStack)]
  nightwatch-agent 컨테이너 기동
  ├── src/        → rw (읽기/쓰기)
  └── tests/      → ro (읽기 전용 ← 절대 규칙)
        │
        ▼
[Phase 2: TASKS.md 파서 & 모델 라우터]
  task_runner.py → TASKS.md 첫 미결제 항목 파싱
  ├── [FLASH] → gemini-2.0-flash (단순 버그픽스, 문서화)
  └── [PRO]   → gemini-3.1-pro-preview (아키텍처, 복잡한 로직)
        │
        ▼
[Phase 3: CI/CD 게이트 (GitHub Actions)]
  PR 생성 → pytest + mypy + flake8
  ├── 성공 → PR 리뷰 대기열 진입 (아침 7시 알림)
  └── 실패 → 최대 2회 재시도 → 실패 지속 시 Discord 알림 ("인간 개입 필요")
        │
        ▼
[Phase 4: 지휘관 게이트키핑 (아침 7시)]
  iPad에서 PR 로직 5분 검토
  ├── Approve + Merge → main 브랜치 병합
  └── Request Changes → 다음 야간 작업 큐에 재등록
        │
        ▼
[Phase 5: 로컬 동기화]
  git pull → TASKS.md 체크 → 다음 큐 갱신
```

---

## Phase 1 — 로컬 컨테이너 샌드박스

### 파일 구조
```
.
├── docker-compose.yml          ← 새로 생성
├── Dockerfile.nightwatch       ← 새로 생성
└── start_workspace.sh          ← 컨테이너 시작 통합
```

### `docker-compose.yml` 명세
```yaml
services:
  nightwatch-agent:
    build:
      context: .
      dockerfile: Dockerfile.nightwatch
    container_name: nightwatch-agent
    volumes:
      - .:/workspace:rw            # 전체 워크스페이스 (읽기/쓰기)
      - ./tests:/workspace/tests:ro  # ← 절대로 타협할 수 없는 라인
    environment:
      - GEMINI_API_KEY=${GEMINI_API_KEY}
    working_dir: /workspace
    tty: true
    stdin_open: true
    restart: "no"
```

### `Dockerfile.nightwatch` 명세
- Base: `ubuntu:24.04`
- 포함 패키지: `git`, `curl`, `python3`, `pip`, `typst`
- 진입점: `/bin/bash`

### `start_workspace.sh` 통합
- `docker compose up -d nightwatch-agent` → 컨테이너 기동
- `docker compose down` → tmux 종료 시 컨테이너 정리

---

## Phase 2 — TASKS.md 파서 & 모델 라우터

### `TASKS.md` 포맷
```markdown
# Task Queue

## [FLASH] Fix footnote numbering in chapter 2
- 각주 번호가 챕터 경계에서 초기화되지 않음
- 파일: chapter 2/main.typ

## [PRO] Redesign the Preliminaries section layout
- 현재 구조가 PDE 흐름과 맞지 않음
- Architecture_Plan.md 먼저 생성 후 승인 필요
```

**태그 규칙:**
- `[FLASH]` — 단순 버그 픽스, 문서화, 린팅, 스타일 수정
- `[PRO]` — 아키텍처 변경, 복잡한 비즈니스 로직, 의존성 있는 이슈

### `tools/task_runner.py` 설계
```python
# 핵심 로직
def parse_next_task(tasks_md_path) -> dict:
    """TASKS.md에서 첫 번째 미완료 항목을 파싱."""
    # [FLASH] 또는 [PRO] 태그 정규식 추출
    # 태그에 따라 model 결정
    return {"tag": "FLASH"|"PRO", "title": ..., "model": ..., "body": ...}

def route_to_model(task: dict) -> str:
    """태그에 따른 모델 ID 반환."""
    return {
        "FLASH": "google/gemini-3.0-flash",
        "PRO":   "google/gemini-3.1-pro-preview",
    }[task["tag"]]
```

---

## Phase 3 — CI/CD 파이프라인

### `.github/workflows/nightwatch-ci.yml` 명세
```yaml
name: NightWatch CI

on:
  pull_request:
    branches: [main]

jobs:
  verify:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup Python
        uses: actions/setup-python@v5
      - name: Install deps
        run: pip install -r requirements.txt
      - name: pytest (커버리지 0.1% 하락도 허용 불가)
        run: pytest --cov --cov-fail-under=<현재_커버리지>
      - name: mypy
        run: mypy src/
      - name: flake8
        run: flake8 src/
      - name: Discord 실패 알림
        if: failure()
        run: |
          curl -X POST ${{ secrets.DISCORD_WEBHOOK }} \
            -H 'Content-Type: application/json' \
            -d '{"content": "🚨 NightWatch CI 실패 — 인간 개입 필요!"}'
```

### GitHub Branch Protection Rules (설정 위치: GitHub 웹 > Settings > Branches)
- ✅ `Require a pull request before merging`
- ✅ `Require approvals` (1명 — 본인)
- ✅ `Require status checks to pass` (job: `verify`)
- ✅ `Do not allow bypassing the above settings`

---

## Phase 4 — 야간 자율 실행 루프

### 트리거 방식 (GitHub Actions Schedule)
```yaml
on:
  schedule:
    - cron: '0 16 * * *'  # KST 01:00 (UTC+9 → UTC 16:00)
```

### 자율 실행 플로우
1. `task_runner.py` → `TASKS.md` 파싱
2. 작업 브랜치 생성 (`git checkout -b nightwatch/task-<id>`)
3. OpenClaw (라우팅된 모델) → 코드 구현
4. `[PRO]` 태그 시: `Architecture_Plan.md` 생성 → PR 코멘트로 제출 → 대기
5. 브랜치 푸시 → PR 생성 (`gh pr create`)
6. CI 결과 폴링:
   - 성공 → 아침 Discord 알림 ("✅ PR #N 리뷰 준비 완료")
   - 실패 → 재시도 (최대 2회) → 지속 실패 → "🚨 인간 개입 필요" 알림

---

## Phase 5 — E2E 검증 및 지휘관 플로우

### 아침 지휘관 루틴 (iPad + Blink Shell)
```
1. Discord 알림 확인 → ✅ PR #N 리뷰 준비 완료
2. GitHub Mobile 앱에서 PR 열기
3. 코드 변경 로직/설계 5분 검토
   - 테스트 우회 여부 확인
   - 설계 의도 부합 여부 확인
4. Approve → Merge to main
5. Blink Shell: git pull → TASKS.md 업데이트
```

---

## 구현 순서 (우선순위)

| 순서 | Phase | 예상 작업량 | 비고 |
|---|---|---|---|
| 1 | Phase 1 — 컨테이너 샌드박스 | 소 (1-2시간) | 핵심 보안 기반 |
| 2 | Phase 2 — TASKS.md 파서 | 소 (1-2시간) | 라우팅 로직 |
| 3 | Phase 3 — CI 파이프라인 | 중 (2-3시간) | GitHub 설정 포함 |
| 4 | Phase 4 — 야간 자율 루프 | 중 (2-3시간) | Phase 1-3 완료 후 |
| 5 | Phase 5 — E2E 검증 | 소 (1시간) | 전체 통합 테스트 |

---

## 현재 기술 스택

| 컴포넌트 | 기술 |
|---|---|
| 에이전트 게이트웨이 | OpenClaw (로컬, port 18789) |
| 에이전트 모델 | `google/gemini-3.1-pro-preview` (기본) |
| 컨테이너 런타임 | OrbStack (Docker 호환) |
| PDF 컴파일러 | Typst (로컬 Mac 바이너리) |
| 모바일 접속 | Tailscale HTTPS (`*.tail8adc61.ts.net`) |
| 터미널 멀티플렉서 | tmux (zsh 기본 셸) |
| 알림 채널 | Discord (Bot: `open claw_bot`) |
| VCS | Git + GitHub (`kimpossible-TY/Partial-Differential-Equations`) |
# 🌙 NightWatch 자율 실행 가이드 (nightwatch.sh)

이 문서는 로컬 개발 환경에서 정의한 작업을 자율 실행 에이전트(NightWatch)에게 안전하게 넘겨주는(Handoff) 방법을 설명합니다.

---

## 📋 핵심 워크플로우

NightWatch를 활용한 협업은 다음 3단계로 이루어집니다.

### 1단계: 작업 정의 (Plan)
에이전트가 수행할 작업을 프로젝트 루트의 **`TASKS.md`** 파일에 작성합니다.
- 반드시 **`# 🔄 대기 중인 작업`** 섹션 아래에 작성합니다.
- **포맷**: `## [TAG] 작업 제목`

---

## 📝 TASKS.md 작성 규격

NightWatch의 파서(`task_runner.py`)는 다음 규칙에 따라 작업을 선정합니다.

### 1. 태그 시스템 (TAG)
작업의 성격에 따라 적절한 태그를 붙여야 하며, 이에 따라 사용되는 AI 모델이 결정됩니다.
*   **`[FLASH]`**: 단순 버그 픽스, 문서화, 스타일 수정 등 가벼운 작업 (사용 모델: `Gemini 3.0 Flash`)
*   **`[PRO]`**: 복잡한 로직 구현, 아키텍처 설계, 깊은 이해가 필요한 작업 (사용 모델: `Gemini 3.1 Pro Preview`)

### 2. 작업 선택 로직 (Priority)
*   **Top-Down**: 파일의 최상단에서부터 가장 먼저 발견되는 **"미완료"** 상태의 태스크 하나만 가져가서 실행합니다.
*   **일회성(One by One)**: 한 PR에 변경 사항이 섞이는 것을 방지하기 위해, 한 번에 하나의 태스크 섹션만 처리합니다.

### 3. 완료 처리 (Completion Marker)
항목을 완료 처리하거나 무시하게 하려면, 제목(`##`) **바로 윗줄**에 완료 마커를 추가해야 합니다.
```markdown
# [x] ## [FLASH] 완료된 작업 제목
또는
[x] ## [PRO] 완료된 작업 제목
```
> [!IMPORTANT]
> 단순히 `# 완료된 작업` 섹션 아래에 옮겨두는 것만으로는 부족할 수 있습니다. 반드시 제목 바로 위에 `# [x]` 마커가 있는지 확인하세요.

### 4. 본문 작성
제목(`##`) 아래에 작성된 모든 텍스트는 에이전트에게 전달되는 **태스크 본문**이 됩니다. 구체적인 목표, 변경해야 할 파일 경로, 예상 결과 등을 상세히 적을수록 정확도가 올라갑니다.

---

### 2단계: 자율 실행 트리거 (Handoff)
터미널에서 다음 명령어를 실행합니다.
```bash
./nightwatch.sh
```
이 쉘 스크립트는 다음 과정을 대화형으로 자동 수행합니다:
1.  **브랜치 체크**: `main` 브랜치인 경우 보안을 위해 반드시 새 브랜치를 생성하도록 안내합니다.
2.  **브랜치 생성**: 새로운 작업을 위한 브랜치 명을 입력받습니다 (형식: `nightwatch/이름`).
3.  **저장 및 전송**: 변경된 `TASKS.md`를 커밋하고 GitHub로 푸시합니다.
4.  **루프 가동**: GitHub Actions의 NightWatch 자율 루프 워크플로우를 즉시 실행시킵니다.

### 3단계: 결과 검토 (Review)
약 5~10분 후 GitHub에서 에이전트가 생성한 **Pull Request(PR)**를 확인합니다.
- 에이전트의 작업이 마음에 든다면 `Merge`를 통해 `main` 브랜치에 반영합니다.

---

## 💡 유의 사항 및 팁

- **로컬 프로세스**: `./start_workspace.sh`를 통해 로컬 게이트웨이가 실행 중이어도 상관없습니다. NightWatch는 GitHub 서버의 독립된 환경에서 자율적으로 실행됩니다.
- **브랜치 전략**: `main` 브랜치에서 직접 자율 작업을 돌리는 것은 금지되어 있습니다. 스크립트가 자동으로 이를 감지하고 브랜치 생성을 강제하므로 안심하고 사용하세요.
- **모니터링**: 실행 상태를 터미널에서 보고 싶다면 `gh run watch`를 입력하세요.

---

> **"설계는 로컬에서, 구현은 밤사이에!"**
# 🌙 NightWatch 시스템 문서

이 디렉터리는 프로젝트의 야간 자율 실행 에이전트 파이프라인인 **NightWatch** 시스템에 관한 모든 지식과 가이드를 체계적으로 구조화한 곳입니다.

## 📂 문서 구조

- [**nightwatch_guide.md**](./nightwatch_guide.md): 
  - 로컬 개발 환경에서 사용자가 직접 작업을 정의(`TASKS.md`)하고 NightWatch 스크립트(`nightwatch.sh`)를 통해 자율 에이전트에게 안전하게 작업을 위임(Handoff)하는 방법을 설명하는 실무 가이드입니다.
- [**NIGHTWATCH_BLUEPRINT.md**](./NIGHTWATCH_BLUEPRINT.md): 
  - NightWatch의 End-to-End 자율 개발 통제 파이프라인의 설계도 및 아키텍처 원칙(결정론적 라우팅, 물리적 격리, 무관용 병합 통제)을 담고 있습니다.

## 🛠️ 지금까지의 주요 작업 내역 (History & Milestones)

NightWatch 시스템을 구축하기 위해 다음과 같은 주요 기술적 과제들을 해결해 왔습니다.

### 1. 이중 레이어 부트스트랩 (Double-Layer Bootstrap)
- **과제:** 에이전트가 로컬 파일 시스템에 접근하면서도, 실행 환경 자체가 격리되어야 하며 GitHub Actions와의 연동이 매끄러워야 했습니다.
- **해결:** `docker-compose.yml`과 `Dockerfile.nightwatch`를 통해 로컬 컨테이너 샌드박스 레이어를 구축하고, `nightwatch.sh`를 통한 Handoff 스크립트 레이어를 마련하여 설계 환경과 실행 환경을 이중으로 분리 및 연동했습니다.

### 2. 권한 이슈 해결 (Permission Fixes)
- **과제:** Docker 컨테이너(특히 OrbStack 기반) 환경과 호스트 파일 시스템 간의 UID/GID 불일치로 인해 권한 거부(Permission Denied) 문제가 발생했습니다. (예: `tests/` 디렉터리 접근 제어 및 `.openclaw_config` 권한 등)
- **해결:** `uid: 1001` 매핑 및 워크스페이스 마운트 전략 수정(`tests` 디렉터리는 Read-Only로 설정하여 안정성 및 물리적 격리 원칙 고수)을 통해 권한 문제를 근본적으로 해결했습니다.

### 3. 아키텍처 구현 (Architecture Implementation)
- **과제:** AI가 무분별하게 메인 브랜치에 코드를 푸시하거나, 중요 테스트 코드를 변경하는 것을 방지해야 했습니다.
- **해결:** 
  - **결정론적 라우팅:** `TASKS.md`의 `[FLASH]`, `[PRO]` 태그 기반 작업 지시.
  - **작업 브랜치 강제:** `nightwatch.sh`가 항상 `main`이 아닌 고립된 브랜치(`nightwatch/...`)를 생성하도록 강제.
  - **지휘관 게이트키핑:** 작업 결과는 PR(Pull Request)로만 제출되며, 아침 7시에 인간(지휘관)이 리뷰 후 Merge 하도록 시스템을 구현했습니다.

---

> **"설계는 로컬에서, 구현은 밤사이에!"**
> NightWatch는 인간 지휘관이 설계와 검증에 집중할 수 있도록, 단순하고 반복적이거나 시간이 오래 걸리는 구현 작업을 밤새 자율적으로 처리하는 든든한 파트너입니다.
