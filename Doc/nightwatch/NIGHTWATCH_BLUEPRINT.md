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
