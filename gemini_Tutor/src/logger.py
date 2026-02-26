import os
 from datetime import datetime
 from .tools import get_project_root 
 
 class HistoryLogger:
     def __init__(self):
         self.project_root = get_project_root() #
         self.log_dir = os.path.join(self.project_root, 'gemini_Tutor', 'logs')
 
     def save(self, history, model_name):
         """대화 기록을 Markdown 파일로 저장합니다."""
         if not history:
             return None
 
         os.makedirs(self.log_dir, exist_ok=True)
         filename = f"chat_{datetime.now().strftime('%Y%m%d_%H%M%S')}.md"
         filepath = os.path.join(self.log_dir, filename)
 
         with open(filepath, 'w', encoding='utf-8') as f:
             f.write(f"# 🎓 Riemannian Geometry Study Session\n")
             f.write(f"- **Date**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
             f.write(f"- **Final Model**: {model_name}\n\n---\n\n")
 
             for content in history: #
                 role = "User" if content.role == "user" else "Tutor"
                 text_parts = [part.text for part in content.parts if hasattr(part, 'text') and part.text]
                 if text_parts:
                     f.write(f"### 👤 {role}\n" if role == "User" else f"### 🤖 {role}\n")
                     f.write("\n".join(text_parts) + "\n\n")
         return filepath
 
