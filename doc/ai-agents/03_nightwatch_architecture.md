# Project NightWatch — E2E 자율 개발 통제 파이프라인

> **목표**: iPad + Blink Shell의 제한된 모바일 환경에서, 사용자가 지휘관으로서 AI 자율 개발 시스템을 완벽히 통제한다.
> **"설계는 로컬에서, 구현은 밤사이에!"**

---

## 1. 아키텍처 대원칙

| 원칙 | 설명 |
|---|---|
| **결정론적 라우팅** | 모델 선택은 전적으로 `TASKS.md`의 태그가 결정. AI의 재량 없음. |
| **물리적 격리** | AI는 `tests/` 디렉터리에 쓰기 불가 (컨테이너 read-only 마운트). |
| **무관용 병합 통제** | CI(자동)는 필요조건. 병합(Merge)은 오직 인간의 승인에 종속. |

---

## 2. 시스템 구성도

```text
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
```

---

## 3. 핵심 워크플로우 (Handoff 가이드)

NightWatch를 활용한 협업은 다음 3단계로 이루어집니다.

### 1단계: 작업 정의 (Plan)
에이전트가 수행할 작업을 프로젝트 루트의 **`TASKS.md`** 파일에 작성합니다.

#### TASKS.md 작성 규격
1. **태그 시스템 (TAG)**
   - `[FLASH]`: 단순 버그 픽스, 문서화, 스타일 수정 등 가벼운 작업 (사용 모델: Gemini Flash)
   - `[PRO]`: 복잡한 로직 구현, 아키텍처 설계, 깊은 이해가 필요한 작업 (사용 모델: Gemini Pro)
2. **작업 선택 로직 (Priority)**
   - Top-Down: 파일 최상단에서 가장 먼저 발견되는 **"미완료"** 상태의 태스크 하나만 가져가 실행합니다.
3. **완료 처리 (Completion Marker)**
   - 항목을 완료 처리하려면 제목 바로 윗줄에 `[x]` 마커를 추가합니다.
     ```markdown
     [x] ## [FLASH] 완료된 작업 제목
     ```

### 2단계: 자율 실행 트리거 (Handoff)
터미널에서 다음 명령어를 실행합니다.
```bash
./nightwatch.sh
```
스크립트가 안전한 새 브랜치(`nightwatch/이름`) 생성을 강제하고, 변경사항을 푸시하여 자율 실행 워크플로우를 가동합니다.

### 3단계: 결과 검토 (Review)
작업 완료 후 GitHub에서 에이전트가 생성한 Pull Request(PR)를 검토하고 `main` 브랜치에 병합(Merge)합니다.

---

## 4. 해결된 주요 기술적 과제 (Milestones)

1. **이중 레이어 부트스트랩 (Double-Layer Bootstrap)**
   - `docker-compose.yml`과 `Dockerfile.nightwatch`를 통해 로컬 컨테이너 샌드박스 구축.
2. **권한 이슈 해결 (Permission Fixes)**
   - UID/GID 매핑 및 읽기 전용 볼륨 마운트(`tests/`)를 통한 호스트-컨테이너 간 보안 및 권한 충돌 해결.
3. **아키텍처 강제 (Architecture Implementation)**
   - 작업 브랜치 생성을 강제하고, 모든 변경사항이 PR을 거치도록 통제 파이프라인 완성.
