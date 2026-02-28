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
        project_root = get_project_root()
        config_path = os.path.join(project_root, 'gemini_Tutor', 'config', 'system_instructions.md')
        try:
            with open(config_path, 'r', encoding='utf-8') as f:
                instructions = f.read()
        except FileNotFoundError:
            instructions = "You are a strict Riemannian Geometry Tutor."

        # 도구 목록 정의
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
    def __init__(self, api_key, model_name="gemini-2.5-flash", history=None, source_file=None):
        self.session = SessionManager(api_key, model_name)
        self.logger = HistoryLogger()
        self.source_file = source_file
        self.session.create_session(history=history)

    def send_query(self, message):
        """수동 루프를 통해 도구 호출과 답변 생성을 완벽히 제어합니다."""
        try:
            # 1. 사용자의 질문 전송
            response = self.session.chat.send_message(message)
            
            # 2. 도구 호출 루프 (최대 3회 시도) [cite: 2025-11-22]
            for _ in range(3):
                # 답변 텍스트가 있으면 즉시 반환
                if response.text:
                    return response.text
                
                # 도구 호출(Tool Call)이 있는지 확인
                parts = response.candidates[0].content.parts
                tool_calls = [p.function_call for p in parts if p.function_call]
                
                if not tool_calls:
                    break # 더 이상 호출할 도구가 없음

                # 도구 실행 및 결과 수집
                tool_responses = []
                for call in tool_calls:
                    print(f"🛠️ Tool Calling: {call.name}({call.args})")
                    if call.name == "read_project_knowledge":
                        # tools.py의 함수를 직접 실행
                        result = read_project_knowledge(**call.args)
                        tool_responses.append(types.Part.from_function_response(
                            name=call.name,
                            response={"result": result}
                        ))
                
                # 결과를 모델에게 다시 전달하여 최종 답변 생성 유도
                response = self.session.chat.send_message(tool_responses)
            
            return response.text if response.text else "Tutor finished without text response."
            
        except Exception as e:
            return f"❌ System Error: {str(e)}"

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
