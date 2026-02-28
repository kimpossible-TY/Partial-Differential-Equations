import os
import pickle
import json
import urllib.parse
from google_auth_oauthlib.flow import Flow

# [중요] Codespace의 DriveService와 반드시 일치해야 함
SCOPES = ['https://www.googleapis.com/auth/drive.file']

def extract_code(input_text):
    """Localhost/... 형태의 입력에서 code 값만 정밀하게 추출합니다."""
    if "code=" in input_text and not input_text.startswith("http"):
        input_text = "http://" + input_text
    parsed = urllib.parse.urlparse(input_text)
    query = urllib.parse.parse_qs(parsed.query)
    return query.get('code', [input_text])[0]

def main():
    print("🚀 모바일 SSH 인증 시스템을 시작합니다.")
    
    if not os.path.exists('credentials.json'):
        print("❌ credentials.json 파일이 없습니다!")
        return

    # 1. Flow 객체 직접 생성
    # redirect_uri는 반드시 http://localhost 여야 합니다. (GCP 콘솔 설정과 일치)
    flow = Flow.from_client_secrets_file(
        'credentials.json',
        scopes=SCOPES,
        redirect_uri='http://localhost'
    )

    # 2. 인증 URL 생성 (이 시점에 내부적으로 code_verifier가 생성됨)
    auth_url, _ = flow.authorization_url(prompt='consent', access_type='offline')
    
    print("\n" + "="*60)
    print("👉 [1단계] 아래 링크를 브라우저에서 열어 '허용'을 누르세요:")
    print(f"\n{auth_url}\n")
    print("="*60)
    
    # ⚠️ 여기서 스크립트를 절대 종료하지 마세요!
    user_input = input("\n👉 [2단계] 결과 URL 전체(Localhost/...)를 여기에 붙여넣으세요: ").strip()
    
    code = extract_code(user_input)
    print(f"📦 코드 인식 성공: {code[:10]}...")

    try:
        # 3. 토큰 교환 (생성된 flow 객체를 그대로 사용해야 verifier가 유지됨)
        flow.fetch_token(code=code)
        creds = flow.credentials
        
        with open('token.pickle', 'wb') as token:
            pickle.dump(creds, token)
        print(f"\n✅ token.pickle 생성 완료! ({os.path.getsize('token.pickle')} bytes)")
        print("💡 이제 이 파일을 Base64로 변환하여 GitHub Secret에 등록하세요.")
    except Exception as e:
        print(f"\n❌ 실패: {e}")
        print("💡 팁: 반드시 링크 클릭 후 '첫 번째'로 뜬 결과 코드를 입력해야 합니다.")

if __name__ == '__main__':
    main()
