import os
from google import genai
from google.genai import types
from .tools import get_project_root, read_project_knowledge
from .logger import HistoryLogger

class SessionManager:
    def __init__(self, api_key, model_name):
        self.client = genai.Client(api_key=api_key)
        self.model_name = model_name
        self.chat = None

    def create_session(self, history=None):
        """시스템 지침을 로드하고 자동 도구 호출이 활성화된 세션을 생성합니다."""
        project_root = get_project_root()
        config_path = os.path.join(project_root, 'gemini_Tutor', 'config', 'system_instructions.md')
        
        try:
            with open(config_path, 'r', encoding='utf-8') as f:
                instructions = f.read()
        except FileNotFoundError:
            instructions = "You are a strict Riemannian Geometry Tutor."

        # [수정] SDK 버전에 따라 명시적인 True/False 값이 더 안정적일 수 있습니다.
        self.chat = self.client.chats.create(
            model=self.model_name,
            config=types.GenerateContentConfig(
                tools=[read_project_knowledge],
                system_instruction=instructions,
                temperature=0.1,
                # 자동 함수 호출 활성화
                automatic_function_calling=types.AutomaticFunctionCallingConfig(disable=False)
            ),
            # 복구된 history가 있다면 주입
            history=history if history else []
        )

class TutorAgent:
    def __init__(self, api_key, model_name="gemini-2.5-flash", history=None, source_file=None):
        self.session = SessionManager(api_key, model_name)
        self.logger = HistoryLogger()
        self.source_file = source_file
        self.session.create_session(history=history)

    def send_query(self, message):
        """사용자의 질문을 보내고 응답을 받습니다. 도구 호출 루프를 감시합니다."""
        try:
            response = self.session.chat.send_message(message)
            
            # [진단] 도구는 실행되었으나 모델이 답변을 거부한 경우 (안전성 등)
            if not response.text:
                if hasattr(response, 'candidates') and response.candidates:
                    finish_reason = response.candidates[0].finish_reason
                    return f"⚠️ Tutor stopped thinking. Reason: {finish_reason}"
                return "Tutor provided an empty response after thinking."
                
            return response.text
        except Exception as e:
            # 도구(Tool) 내부에서 발생한 에러를 포착합니다.
            return f"❌ System Error during thinking: {str(e)}"

    def shutdown(self):
        history = self.get_safe_history()
        return self.logger.save(history, self.session.model_name, source_file=self.source_file)

    def get_safe_history(self):
        for attr in ['history', '_history', '_curated_history']:
            hist = getattr(self.session.chat, attr, None)
            if hist and isinstance(hist, list): return hist
        return []

    def switch_model(self, new_model_name):
        if self.session.model_name == new_model_name: return False
        current_history = self.get_safe_history()
        self.session.model_name = new_model_name
        self.session.create_session(history=current_history)
        return True
