import os
import re
from datetime import datetime
from .tools import get_project_root
from .drive_service import DriveService

class HistoryLogger:
    def __init__(self):
        self.project_root = get_project_root()
        self.log_dir = os.path.join(self.project_root, 'gemini_Tutor', 'logs')

    def get_latest_log(self):
        """가장 최근에 수정된 마크다운 로그 파일의 경로를 반환합니다."""
        if not os.path.exists(self.log_dir):
            return None
            
        files = [os.path.join(self.log_dir, f) for f in os.listdir(self.log_dir) if f.endswith('.md')]
        if not files:
            return None
        return max(files, key=os.path.getmtime)

    def load_history(self, file_path):
        """특정 로그 파일을 읽어 Gemini History 객체 형식으로 복원합니다."""
        if not os.path.exists(file_path):
            print(f"❌ 파일을 찾을 수 없습니다: {file_path}")
            return [], None

        history = []
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()

            # ### User와 ### Tutor 섹션을 기준으로 분리
            sections = re.split(r'### (User|Tutor)\n', content)
            
            for i in range(1, len(sections), 2):
                role_str = sections[i].strip()
                text = sections[i+1].strip()
                
                role = "user" if role_str == "User" else "model"
                # Pydantic 검증 에러 방지를 위한 딕셔너리 구조 유지
                history.append({"role": role, "parts": [{"text": text}]})
            
            return history, os.path.basename(file_path)
        except Exception as e:
            print(f"❌ 히스토리 로드 실패: {e}")
            return [], None

    def save(self, history, model_name, source_file=None):
        """대화 기록을 로컬과 구글 드라이브에 저장하며, 도구 호출 기록도 안전하게 텍스트화합니다."""
        if not history or len(history) == 0:
            return "No history to save."

        os.makedirs(self.log_dir, exist_ok=True)
        filename = f"chat_{datetime.now().strftime('%Y%m%d_%H%M%S')}.md"
        local_path = os.path.join(self.log_dir, filename)
        
        try:
            with open(local_path, 'w', encoding='utf-8') as f:
                f.write(f"# 🎓 Riemannian Geometry Session\n")
                f.write(f"- Model: {model_name}\n")
                f.write(f"- Timestamp: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
                if source_file:
                    f.write(f"- Source File: {source_file}\n")
                f.write(f"\n---\n")

                for content in history:
                    role = "User" if content.role == "user" else "Tutor"
                    
                    # [핵심 수정] NoneType 에러 방지를 위한 파트별 안전 처리 로직
                    parts_text = []
                    for p in content.parts:
                        # 1. 일반 텍스트가 있는 경우
                        if hasattr(p, 'text') and p.text is not None:
                            parts_text.append(p.text)
                        
                        # 2. 모델이 도구 호출(Function Call)을 생성한 경우
                        elif hasattr(p, 'function_call') and p.function_call is not None:
                            call = p.function_call
                            parts_text.append(f"\n> 🛠️ **Tool Call**: `{call.name}`\n> **Args**: `{call.args}`\n")
                        
                        # 3. 도구 실행 결과(Function Response)가 돌아온 경우
                        elif hasattr(p, 'function_response') and p.function_response is not None:
                            parts_text.append(f"\n> 📥 **Knowledge Retrieved**\n")
                    
                    # 수집된 파트들을 하나의 문자열로 결합 (None이 섞이지 않음)
                    full_text = "".join(parts_text)
                    if full_text.strip():
                        f.write(f"### {role}\n{full_text.strip()}\n\n")
        except Exception as e:
            # 상세한 에러 메시지를 반환하여 디버깅 지원
            return f"Local save failed: {str(e)}"

        try:
            drive = DriveService()
            drive_id = drive.upload_log(local_path)
            return f"{filename} (Cloud ID: {drive_id})"
        except Exception as e:
            return f"{filename} (Local Only - Cloud Error: {e})"
