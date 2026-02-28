import os
import base64
import pickle
import json
from googleapiclient.discovery import build
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
from googleapiclient.http import MediaFileUpload

class DriveService:
    # 튜터가 사용할 최소 권한 범위
    SCOPES = ['https://www.googleapis.com/auth/drive.file']

    def __init__(self):
        self.creds = None
        self.service = None
        self._authenticate()

    def _authenticate(self):
        """GitHub Secrets(환경 변수)에서 인증 정보를 메모리로 로드하고 복원합니다."""
        # 1. 환경 변수에서 Base64 인코딩된 토큰 가져오기
        token_base64 = os.getenv("GDRIVE_TOKEN_BASE64")
        
        if token_base64:
            try:
                # Base64 -> Bytes -> Pickle Object 복원
                token_data = base64.b64decode(token_base64)
                self.creds = pickle.loads(token_data)
                print("🔑 Cloud Token restored from environment variables.")
            except Exception as e:
                print(f"⚠️ Token 복구 실패: {e}")

        # 2. 토큰이 만료되었을 경우 자동 갱신 (Refresh Token 활용)
        if self.creds and self.creds.expired and self.creds.refresh_token:
            try:
                self.creds.refresh(Request())
                print("🔄 Access token refreshed automatically.")
            except Exception as e:
                print(f"❌ Token refresh 실패: {e}")
                self.creds = None

        # 3. 토큰이 아예 없거나 갱신에 실패한 경우 (비상용 브라우저 인증)
        if not self.creds or not self.creds.valid:
            print("📢 유효한 토큰이 없습니다. 새로운 인증이 필요합니다.")
            creds_json_base64 = os.getenv("GDRIVE_CREDENTIALS_BASE64")
            
            if creds_json_base64:
                creds_info = json.loads(base64.b64decode(creds_json_base64))
                flow = InstalledAppFlow.from_client_config(creds_info, self.SCOPES)
                self.creds = flow.run_local_server(port=0)
            else:
                # 로컬에 credentials.json이 있는 경우 대비
                if os.path.exists('credentials.json'):
                    flow = InstalledAppFlow.from_client_secrets_file('credentials.json', self.SCOPES)
                    self.creds = flow.run_local_server(port=0)
                else:
                    print("❌ 오류: 인증을 위한 Credentials 정보가 없습니다.")
                    return

        # 4. 드라이브 서비스 빌드 및 성공 확인
        try:
            self.service = build('drive', 'v3', credentials=self.creds)
            print("✅ Google Drive service initialized successfully.")
        except Exception as e:
            print(f"❌ API 서비스 빌드 실패: {e}")

    def upload_log(self, local_path, folder_name="Riemannian_Geometry_Logs"):
        """로컬 로그 파일을 구글 드라이브의 지정된 폴더로 업로드합니다."""
        if not self.service:
            print("⚠️ 드라이브 서비스가 준비되지 않아 업로드를 건너뜁니다.")
            return None

        try:
            # 폴더 존재 확인 및 없으면 생성
            folder_id = self._get_or_create_folder(folder_name)

            # 파일 메타데이터 설정
            file_metadata = {
                'name': os.path.basename(local_path),
                'parents': [folder_id]
            }
            media = MediaFileUpload(local_path, mimetype='text/markdown')

            # 업로드 실행
            uploaded_file = self.service.files().create(
                body=file_metadata, 
                media_body=media, 
                fields='id'
            ).execute()
            
            return uploaded_file.get('id')
        except Exception as e:
            print(f"❌ 클라우드 업로드 중 오류 발생: {e}")
            return None

    def _get_or_create_folder(self, folder_name):
        """드라이브에서 폴더를 찾거나 새로 생성합니다."""
        query = f"name = '{folder_name}' and mimeType = 'application/vnd.google-apps.folder' and trashed = false"
        results = self.service.files().list(q=query, fields="files(id)").execute()
        files = results.get('files', [])
        
        if files:
            return files[0].get('id')
        
        # 폴더가 없으면 생성
        folder_metadata = {
            'name': folder_name,
            'mimeType': 'application/vnd.google-apps.folder'
        }
        folder = self.service.files().create(body=folder_metadata, fields='id').execute()
        print(f"📁 Created new folder: {folder_name}")
        return folder.get('id')
