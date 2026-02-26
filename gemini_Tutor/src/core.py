import os
from google import genai
from google.genai import types
from .tools import get_project_root, read_project_knowledge

class TutorAgent:
    def __init__(self, api_key):
        """
        Gemini API 클라이언트를 초기화하고 도구가 포함된 대화 세션을 생성합니다.
        """
        self.client = genai.Client(api_key=api_key)
        
        # 프로젝트 루트를 기반으로 시스템 지시사항(Persona) 파일 경로 설정
        project_root = get_project_root()
        config_path = os.path.join(project_root, 'gemini_Tutor', 'config', 'system_instructions.md')
        
        # 시스템 지시사항 로드
        try:
            with open(config_path, 'r', encoding='utf-8') as f:
                instructions = f.read()
        except FileNotFoundError:
            instructions = "당신은 엄격하고 실력이 뛰어난 리만 기하학 튜터입니다."
            print(f"⚠️ 경고: {config_path} 파일을 찾을 수 없어 기본 지시사항을 사용합니다.")
            
        # 대화 세션 시작 (함수 등록 방식 변경: 인자 없는 read_project_knowledge 등록)
        self.chat = self.client.chats.create(
            model="gemini-2.0-flash", # 또는 gemini-2.0-pro
            config=types.GenerateContentConfig(
                tools=[read_project_knowledge], # Gemini가 필요할 때 스스로 호출
                system_instruction=instructions,
                temperature=0.1 # 수학적 엄밀성을 위해 낮게 유지
            )
        )

    def send_query(self, message, file_payloads=None):
        """
        사용자의 메시지와 (필요 시) PDF 파일 데이터를 Gemini에게 전송합니다.
        """
        contents = []
        if file_payloads:
            contents.extend(file_payloads)
        contents.append(message)
        
        return self.chat.send_message(contents)
