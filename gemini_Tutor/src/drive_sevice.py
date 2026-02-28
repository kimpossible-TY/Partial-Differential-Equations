import os
 import pickle
 import base64
 import json
 from googleapiclient.discovery import build
 from google.oauth2.credentials import Credentials
 from google_auth_oauthlib.flow import InstalledAppFlow
 from google.auth.transport.requests import Request
 
 class DriveService:
     SCOPES = ['https://www.googleapis.com/auth/drive.file']
 
     def __init__(self):
         self.creds = None
         self.service = None
         self._authenticate()
 
     def _authenticate(self):
         """환경 변수(GitHub Secrets)에서 인증 정보를 복구합니다."""
         # 1. Token 복구 시도
         token_base64 = os.getenv("GDRIVE_TOKEN_BASE64")
         if token_base64:
             token_data = base64.b64decode(token_base64)
             self.creds = pickle.loads(token_data)
 
         # 2. 만료되었거나 Token이 없는 경우 처리
         if not self.creds or not self.creds.valid:
             if self.creds and self.creds.expired and self.creds.refresh_token:
                 self.creds.refresh(Request())
             else:
                 # credentials.json도 환경 변수에서 로드
                 creds_json = base64.b64decode(os.getenv("GDRIVE_CREDENTIALS_BASE64"))
                 creds_info = json.loads(creds_json)
                 
                 flow = InstalledAppFlow.from_client_config(creds_info, self.SCOPES)
                 self.creds = flow.run_local_server(port=0)
 
         self.service = build('drive', 'v3', credentials=self.creds)
 
