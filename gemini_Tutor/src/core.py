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
        """시스템 지침을 로드하고 전달받은 history를 포함하여 채팅 세션을 생성합니다."""
        project_root = get_project_root()
        config_path = os.path.join(project_root, 'gemini_Tutor', 'config', 'system_instructions.md')
        
        try:
            with open(config_path, 'r', encoding='utf-8') as f:
                instructions = f.read()
        except FileNotFoundError:
            instructions = "You are a strict Riemannian Geometry Tutor."

        # [핵심 수정] automatic_function_calling을 활성화하여 
        # 도구 실행 후 별도의 대기 없이 즉시 최종 답변을 생성하도록 설정합니다.
        self.chat = self.client.chats.create(
            model=self.model_name,
            config=types.GenerateContentConfig(
                tools=[read_project_knowledge],
                system_instruction=instructions,
                temperature=0.1,
                # SDK 규격에 맞게 자동 함수 호출 설정을 명시합니다.
                automatic_function_calling=types.AutomaticFunctionCallingConfig(disable=False)
            ),
            history=history if history else []
        )

class TutorAgent:
    def __init__(self, api_key, model_name="gemini-2.5-flash", history=None, source_file=None):
        """
        튜터 에이전트를 초기화합니다.
        :param history: 복구할 과거 대화 기록 리스트 [cite: 2025-11-22]
        :param source_file: 대화 기록의 출처가 되는 파일명 [cite: 2025-11-22]
        """
        self.session = SessionManager(api_key, model_name)
        self.logger = HistoryLogger()
        self.source_file = source_file  # 복구된 세션의 근원 정보 저장
        
        # 세션 생성 시 history 주입
        self.session.create_session(history=history)

    def switch_model(self, new_model_name):
        """현재 대화 맥락을 유지하면서 모델을 전환합니다."""
        if self.session.model_name == new_model_name: return False
        
        current_history = self.get_safe_history()
        self.session.model_name = new_model_name
        self.session.create_session(history=current_history)
        return True

    def get_safe_history(self):
        """세션 객체에서 현재까지의 대화 기록을 안전하게 추출합니다."""
        #
        for attr in ['history', '_history', '_curated_history']:
            hist = getattr(self.session.chat, attr, None)
            if hist and isinstance(hist, list) and len(hist) > 0:
                return hist
        return []

    def send_query(self, message):
        """사용자의 질문을 보내고 튜터의 응답을 받습니다."""
        response = self.session.chat.send_message(message)
        
        # 자동 함수 호출이 활성화되면 response.text에 최종 도구 실행 결과가 포함됩니다.
        if response and response.text:
            return response.text
        
        return "Tutor is thinking or performing a task... (Check logs for details)"

    def shutdown(self):
        """종료 시 대화 기록을 추출하여 로컬 및 클라우드에 저장합니다. 
           이때 세션의 출처(source_file) 정보도 함께 기록합니다."""
        history = self.get_safe_history()
        #
        return self.logger.save(
            history, 
            self.session.model_name, 
            source_file=self.source_file
        )
