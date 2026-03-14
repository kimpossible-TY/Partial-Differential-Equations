# 🛠️ NightWatch Tasks

## [FLASH] AGENTS.md 세션 시작 규칙 개선 (멀티 에이전트 매뉴얼 참조 추가)

**목표:** 멀티 에이전트 환경에서 특수 에이전트들이 세션 시작 시 자신의 전용 설정 파일(`SOUL.md`, `manifest.yaml`)을 반드시 읽도록 `AGENTS.md`의 가이드라인을 수정합니다.

### 작업 지침:
1. 최상위 디렉토리의 `AGENTS.md` 파일을 엽니다.
2. `## Session Startup` 섹션을 찾습니다.
3. 기존 파일 읽기 순서(1번 `SOUL.md` 읽기 이후)에 다음 항목을 명시적으로 추가하세요.
   - `1.5. **If you are a specialized agent**, read your specific role file (e.g., agents/<your-name>/SOUL.md) and manifest.yaml`
4. 이를 통해 각 에이전트가 공통 문서에만 의존하지 않고, 자신의 역할(Persona)과 권한(Permissions)을 명확히 인지하고 행동하도록 가이드라인을 강화하는 것이 목적입니다.
