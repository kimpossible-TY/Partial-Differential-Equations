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
