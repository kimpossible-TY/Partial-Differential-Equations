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
        # 파일 수정 시간(mtime) 기준으로 정렬하여 가장 최근 파일 선택
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

            # 정규표현식을 사용하여 ### User와 ### Tutor 섹션을 분리합니다.
            # [cite: 2025-11-22] 데이터의 일관성을 위해 마크다운 헤더를 기준으로 파싱합니다.
            sections = re.split(r'### (User|Tutor)\n', content)
            
            # sections[0]은 메타데이터 섹션이며, 이후 [role, text, role, text...] 순서임
            for i in range(1, len(sections), 2):
                role_str = sections[i].strip()
                text = sections[i+1].strip()
                
                role = "user" if role_str == "User" else "model"
                history.append({"role": role, "parts": [text]})
            
            return history, os.path.basename(file_path)
        except Exception as e:
            print(f"❌ 히스토리 로드 실패: {e}")
            return [], None

    def save(self, history, model_name, source_file=None):
        """대화 기록을 로컬과 구글 드라이브에 저장하며, 출처 정보를 남깁니다."""
        if not history or len(history) == 0:
            return "No history to save."

        # 1. 디렉토리 준비
        os.makedirs(self.log_dir, exist_ok=True)
        filename = f"chat_{datetime.now().strftime('%Y%m%d_%H%M%S')}.md"
        local_path = os.path.join(self.log_dir, filename)
        
        try:
            with open(local_path, 'w', encoding='utf-8') as f:
                # 헤더 정보 작성 (출처 기록 포함) [cite: 2025-11-22]
                f.write(f"# 🎓 Riemannian Geometry Session\n")
                f.write(f"- Model: {model_name}\n")
                f.write(f"- Timestamp: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
                if source_file:
                    f.write(f"- Source File: {source_file}\n") # 복구된 파일 정보 기록
                f.write(f"\n---\n")

                # 대화 내용 기록
                for content in history:
                    role = "User" if content.role == "user" else "Tutor"
                    # Gemini Content 객체에서 텍스트 추출
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
