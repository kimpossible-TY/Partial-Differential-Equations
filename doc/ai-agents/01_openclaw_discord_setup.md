# OpenClaw Discord Bot 연동 및 설정

OpenClaw 기반 디스코드 에이전트 연동 가이드입니다.

## 1. Discord 봇 생성 및 설정
1. Discord Developer Portal에서 새 어플리케이션(Application)을 생성합니다.
2. Bot 메뉴에서 봇(Bot)을 추가하고 토큰(Token)을 발급받습니다. 필요한 Privileged Gateway Intents(Message Content Intent 등)를 활성화합니다.
3. OAuth2 메뉴의 URL Generator를 이용해 봇을 디스코드 서버에 초대합니다.

## 2. OpenClaw 설정 및 `patch_openclaw_config.py`
OpenClaw가 디스코드 봇 계정으로 동작하기 위해서는 설정 파일에 봇 토큰과 채널 정보가 주입되어야 합니다.
이를 자동화하기 위해 `patch_openclaw_config.py` 스크립트를 사용합니다.

### `patch_openclaw_config.py` 동작 방식
- OpenClaw의 기본 설정 경로(`.openclaw/config.json`)를 탐색하고 로드합니다.
- `plugins.entries.discord` 혹은 연관된 플러그인 설정 노드에 디스코드 봇 토큰을 주입합니다.
- 채널 라우팅 및 봇 활성화(enabled: true) 상태를 보장하도록 JSON 설정을 패치(patch)합니다.
- 안전하게 기존 설정을 백업한 후 수정된 설정 파일을 저장합니다.

```bash
# 설정 패치 스크립트 실행
python3 patch_openclaw_config.py
```

## 3. 실행 및 확인
설정 패치 이후 OpenClaw 데몬(Gateway)을 재시작합니다. 디스코드 서버 내에서 봇이 온라인 상태가 되며 메시지에 응답할 수 있게 됩니다.
