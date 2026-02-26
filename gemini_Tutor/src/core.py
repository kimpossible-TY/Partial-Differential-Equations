import os
from google import genai
from google.genai import types
from .tools import get_project_root, read_project_knowledge

class TutorAgent:
    def __init__(self, api_key, model_name="gemini-2.5-flash"):
        """
        TutorAgent 초기화: 최신 2.5 Flash 모델을 기본으로 사용합니다.
        """
        self.client = genai.Client(api_key=api_key)
        self.model_name = model_name
        self.api_key = api_key
        self.chat = None
        self._setup_session()

    def _setup_session(self, history=None):
        """
        채팅 세션을 설정합니다. 엔진 교체 시 이전 대화 기록(history)을 주입합니다.
        """
        project_root = get_project_root()
        config_path = os.path.join(project_root, 'gemini_Tutor', 'config', 'system_instructions.md')
        
        try:
            with open(config_path, 'r', encoding='utf-8') as f:
                instructions = f.read()
        except FileNotFoundError:
            instructions = "당신은 엄격한 리만 기하학 튜터입니다."

        # 도구 호출 시 파라미터 에러(이미지 2번)를 방지하기 위해 
        # 인자 없는 read_project_knowledge를 등록합니다.
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
        지능 중심(Pro)과 속도 중심(Flash)을 오가며 맥락을 유지합니다.
        """
        if self.model_name == new_model_name:
            return False
        
        current_history = self.chat.history if self.chat else None
        self.model_name = new_model_name
        self._setup_session(history=current_history)
        return True

    def send_query(self, message, file_payloads=None):
        contents = []
        if file_payloads:
            contents.extend(file_payloads)
        contents.append(message)
        return self.chat.send_message(contents)
