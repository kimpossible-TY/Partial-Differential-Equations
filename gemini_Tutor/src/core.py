import os
from google import genai
from google.genai import types
from .tools import get_project_root, read_project_knowledge

class TutorAgent:
    def __init__(self, api_key, model_name="gemini-2.0-flash"):
        """
        에이전트 초기화 및 초기 세션 설정
        """
        self.client = genai.Client(api_key=api_key)
        self.model_name = model_name
        self.api_key = api_key
        self.chat = None
        self._setup_session()

    def _setup_session(self, history=None):
        """
        세션을 생성하거나 재설정합니다. 
        history가 전달되면 이전 대화 맥락을 이식합니다.
        """
        project_root = get_project_root()
        config_path = os.path.join(project_root, 'gemini_Tutor', 'config', 'system_instructions.md')
        
        try:
            with open(config_path, 'r', encoding='utf-8') as f:
                instructions = f.read()
        except FileNotFoundError:
            instructions = "당신은 엄격하고 실력이 뛰어난 리만 기하학 튜터입니다."
            print(f"⚠️ 시스템 지시사항 파일을 찾을 수 없어 기본값을 사용합니다.")

        # 새 모델로 채팅 세션 생성 (history 주입이 핵심)
        self.chat = self.client.chats.create(
            model=self.model_name,
            config=types.GenerateContentConfig(
                tools=[read_project_knowledge],
                system_instruction=instructions,
                temperature=0.1
            ),
            history=history
        )

    def switch_model(self, new_model_name):
        """
        현재 대화 기록을 유지한 채 모델 엔진만 교체합니다.
        """
        if self.model_name == new_model_name:
            return False
        
        # 현재까지의 대화 기록(맥락) 추출
        current_history = self.chat.history if self.chat else None
        
        self.model_name = new_model_name
        self._setup_session(history=current_history)
        return True

    def send_query(self, message, file_payloads=None):
        """
        메시지와 파일(PDF 등)을 전송합니다.
        """
        contents = []
        if file_payloads:
            contents.extend(file_payloads)
        contents.append(message)
        return self.chat.send_message(contents)
