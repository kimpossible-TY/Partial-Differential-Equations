import os
from datetime import datetime
from src.tools import get_project_root

class HistoryLogger:
    def __init__(self):
        self.project_root = get_project_root()
        self.log_dir = os.path.join(self.project_root, 'gemini_Tutor', 'logs')

    def save(self, history, model_name):
        if not history:
            return None
        os.makedirs(self.log_dir, exist_ok=True)
        filename = f"chat_{datetime.now().strftime('%Y%m%d_%H%M%S')}.md"
        filepath = os.path.join(self.log_dir, filename)
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(f"# 🎓 Riemannian Geometry Session\n- Model: {model_name}\n\n---\n")
            for content in history:
                role = "User" if content.role == "user" else "Tutor"
                text = "".join([p.text for p in content.parts if hasattr(p, 'text')])
                f.write(f"### {role}\n{text}\n\n")
        return filepath
