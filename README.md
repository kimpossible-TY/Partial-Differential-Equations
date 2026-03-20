# 🌌 NightWatch PDE Workspace

![Typst](https://img.shields.io/badge/Typst-0.11.0-239DAD?logo=typst)
![Python](https://img.shields.io/badge/Python-3.x-3776AB?logo=python)
![Tailscale](https://img.shields.io/badge/Tailscale-VPN-white?logo=tailscale)
![OpenClaw](https://img.shields.io/badge/AI-OpenClaw_NightWatch-8A2BE2)

**NightWatch PDE Workspace**는 미분 기하학(Differential Geometry) 및 편미분방정식(PDE) 등 복잡한 수학 노트를 Typst로 작성하고, 이를 모바일 기기에서 실시간으로 확인하며, 듀얼 AI 에이전트의 보조를 받을 수 있는 **통합 로컬 워크스페이스**입니다.

## ✨ 주요 기능 (Key Features)

- ⚡️ **초고속 실시간 렌더링**: `typst watch`와 Python HTTP 서버를 결합하여 작성 즉시 결과물을 확인합니다.
- 📱 **안전한 모바일 서빙**: Tailscale Serve를 통해 외부 네트워크(예: 아이폰)에서도 안전하게 실시간 문서에 접속할 수 있습니다.
- 🤖 **듀얼 AI 에이전트 (OpenClaw)**:
  - **Math & Typst Specialist 🎓**: 수학적 개념(예: Killing fields, Riemannian manifolds) 설명 및 Typst 수식 렌더링 지원
  - **Tool Architect 💻**: 시스템 스크립트(`start_workspace.sh`) 유지보수 및 `TASKS.md` 기반 워크플로우 자동화
- 🔄 **NightWatch CI/CD**: 로컬과 격리된 안전한 환경에서 스크립트 실행 및 권한 승격 테스트 진행

## 🚀 시작하기 (Quick Start)

### 1. 사전 요구 사항 (Prerequisites)
이 프로젝트는 macOS 환경에 최적화되어 있습니다. 다음 도구들이 설치되어 있어야 합니다:
- `typst`, `tmux`, `python3`, `docker`, `tailscale`, `openclaw` (npm)

### 2. 환경 설정
저장소를 클론한 후, 프로젝트 루트에 `.env` 파일을 생성하고 필요한 API Key 및 환경 변수를 설정하세요.

### 3. 워크스페이스 구동
아래 명령어를 통해 키체인 인증을 거친 후, 모든 백그라운드 서버(Typst, HTTP, NightWatch 통합 센터)를 한 번에 실행합니다.
```bash
./start_workspace.sh
```
> 구동이 완료되면 터미널에 모바일 접속용 Tailscale HTTPS 주소가 안내됩니다.

## 📂 프로젝트 구조 (Structure)

- `Typst_project/`: 리만 기하학 등 실제 수학 노트 코드가 담긴 메인 작업 공간
- `agents/`: OpenClaw 에이전트(`math-typst-specialist`, `tool-architect`) 권한 및 프롬프트 설정
- `Tools/`: 환경 설정 패치 및 터미널 정보 출력용 유틸리티 스크립트
- `TASKS.md`: [FLASH] / [PRO] 태그 기반의 작업 큐 및 이슈 트래커

## 📖 문서 및 위키 (Documentation)

아키텍처 설계, 상세한 시스템 설정 방법, 그리고 Typst 수학 노트의 세부 내용은 **[GitHub Wiki](link-to-wiki)** 및 `doc/` 디렉토리를 참조하세요.