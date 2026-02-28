import os
import pickle
import base64
import json
from googleapiclient.discovery import build
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
from googleapiclient.http import MediaFileUpload

class DriveService:
    SCOPES = ['https://www.googleapis.com/auth/drive.file']

    def __init__(self):
        self.creds = None
        self.service = None
        self._authenticate()

    def _authenticate(self):
        """GitHub Secrets(환경 변수)에서 인증 정보를 안전하게 로드합니다."""
        # 1. 기존 Token 복구 시도
        token_base64 = os.getenv("GDRIVE_TOKEN_BASE64")
        if token_base64:
            try:
                token_data = base64.b64decode(token_base64)
                self.creds = pickle.loads(token_data)
            except Exception as e:
                print(f"⚠️ Token 복구 실패: {e}")

        # 2. Token이 없거나 만료된 경우 처리
        if not self.creds or not self.creds.valid:
            if self.creds and self.creds.expired and self.creds.refresh_token:
                self.creds.refresh(Request())
            else:
                # credentials.json 정보를 환경 변수에서 로드
                creds_json_base64 = os.getenv("GDRIVE_CREDENTIALS_BASE64")
                if not creds_json_base64:
                    raise EnvironmentError("❌ GDRIVE_CREDENTIALS_BASE64 Secret이 설정되지 않았습니다.")
                
                creds_info = json.loads(base64.b64decode(creds_json_base64))
                flow = InstalledAppFlow.from_client_config(creds_info, self.SCOPES)
                # Codespaces 환경에서는 0번 포트를 사용하여 포트 포워딩 유도
                self.creds = flow.run_local_server(port=0)

        self.service = build('drive', 'v3', credentials=self.creds)

    def upload_log(self, local_path, folder_name="Riemannian_Geometry_Logs"):
        """로그 파일을 구글 드라이브에 업로드합니다."""
        # 폴더 존재 확인 및 생성 로직
        query = f"name = '{folder_name}' and mimeType = 'application/vnd.google-apps.folder' and trashed = false"
        results = self.service.files().list(q=query, fields="files(id)").execute()
        files = results.get('files', [])
        
        folder_id = files[0].get('id') if files else self.service.files().create(
            body={'name': folder_name, 'mimeType': 'application/vnd.google-apps.folder'},
            fields='id'
        ).execute().get('id')

        # 파일 업로드
        file_metadata = {'name': os.path.basename(local_path), 'parents': [folder_id]}
        media = MediaFileUpload(local_path, mimetype='text/markdown')
        uploaded_file = self.service.files().create(body=file_metadata, media_body=media, fields='id').execute()
        return uploaded_file.get('id')
