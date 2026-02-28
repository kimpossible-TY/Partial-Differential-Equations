import os
from datetime import datetime
from src.tools import get_project_root #
from .drive_service import DriveService

class HistoryLogger:
    def __init__(self):
        self.project_root = get_project_root()
        self.log_dir = os.path.join(self.project_root, 'gemini_Tutor', 'logs')

    def save(self, history, model_name):
        if not history or len(history) == 0:
            return "No history to save."

        # 1. 로컬 저장
        os.makedirs(self.log_dir, exist_ok=True)
        filename = f"chat_{datetime.now().strftime('%Y%m%d_%H%M%S')}.md"
        local_path = os.path.join(self.log_dir, filename)
        
        try:
            with open(local_path, 'w', encoding='utf-8') as f:
                f.write(f"# 🎓 Riemannian Geometry Session\n- Model: {model_name}\n\n---\n")
                for content in history:
                    role = "User" if content.role == "user" else "Tutor"
                    text = "".join([p.text for p in content.parts if hasattr(p, 'text')])
                    f.write(f"### {role}\n{text}\n\n")
        except Exception as e:
            return f"Local save failed: {e}"

        # 2. 구글 드라이브 업로드
        try:
            drive = DriveService()
            drive_id = drive.upload_log(local_path)
            return f"{filename} (Cloud ID: {drive_id})"
        except Exception as e:
            return f"{filename} (Local Only - Cloud Error: {e})"
