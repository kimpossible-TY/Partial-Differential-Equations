import os
from google import genai
from google.genai import types
from src.tools import get_project_root, read_project_knowledge
from src.logger import HistoryLogger

class SessionManager:
    def __init__(self, api_key, model_name):
        self.client = genai.Client(api_key=api_key)
        self.model_name = model_name
        self.chat = None

    def create_session(self, history=None):
        project_root = get_project_root()
        config_path = os.path.join(project_root, 'gemini_Tutor', 'config', 'system_instructions.md')
        try:
            with open(config_path, 'r', encoding='utf-8') as f:
                instructions = f.read()
        except FileNotFoundError:
            instructions = "You are a strict Riemannian Geometry Tutor."

        # history가 None이면 빈 리스트로 초기화
        self.chat = self.client.chats.create(
            model=self.model_name,
            config=types.GenerateContentConfig(
                tools=[read_project_knowledge],
                system_instruction=instructions,
                temperature=0.1
            ),
            history=history if history else []
        )

class TutorAgent:
    def __init__(self, api_key, model_name="gemini-2.5-flash"):
        self.session = SessionManager(api_key, model_name)
        self.logger = HistoryLogger()
        self.session.create_session()

    def switch_model(self, new_model_name):
        if self.session.model_name == new_model_name: return False
        
        # history를 가져오는 가장 안전한 방법
        current_history = self.get_safe_history()
        self.session.model_name = new_model_name
        self.session.create_session(history=current_history)
        return True

    def get_safe_history(self):
        """다양한 속성명을 시도하여 대화 기록을 확보합니다."""
        for attr in ['history', '_history', '_curated_history']:
            hist = getattr(self.session.chat, attr, None)
            if hist and isinstance(hist, list) and len(hist) > 0:
                return hist
        return []

    def send_query(self, message):
        """텍스트 응답을 보장하며 툴 호출 시에도 None 반환을 방지합니다."""
        response = self.session.chat.send_message(message)
        
        # 텍스트가 있으면 즉시 반환
        if response and response.text:
            return response.text
        
        # 텍스트는 없지만 모델이 무언가(툴 호출 등)를 했다면 상태 메시지 반환
        return "Tutor is thinking or performing a task... (Check logs for details)"

    def shutdown(self):
        """종료 시 기록을 강제로 긁어모아 저장합니다."""
        history = self.get_safe_history()
        return self.logger.save(history, self.session.model_name)
