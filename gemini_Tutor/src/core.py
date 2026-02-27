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

        self.chat = self.client.chats.create(
            model=self.model_name,
            config=types.GenerateContentConfig(
                tools=[read_project_knowledge],
                system_instruction=instructions,
                temperature=0.1
            ),
            history=history if isinstance(history, list) else []
        )

class TutorAgent:
    def __init__(self, api_key, model_name="gemini-2.5-flash"): #
        self.session = SessionManager(api_key, model_name)
        self.logger = HistoryLogger()
        self.session.create_session()

    def switch_model(self, new_model_name):
        if self.session.model_name == new_model_name: return False
        current_history = getattr(self.session.chat, 'history', []) #
        self.session.model_name = new_model_name
        self.session.create_session(history=current_history)
        return True

    def send_query(self, message):
        return self.session.chat.send_message(message)

    def shutdown(self):
        history = getattr(self.session.chat, 'history', [])
        return self.logger.save(history, self.session.model_name)
