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

        # [핵심] 모델이 임의로 인자를 누락하지 못하도록 엄격한 스키마(Schema)를 강제합니다. [cite: 2025-11-22]
        project_knowledge_tool = types.Tool(
            function_declarations=[
                types.FunctionDeclaration(
                    name="read_project_knowledge",
                    description="사용자의 프로젝트 디렉토리 내에 있는 .typ (Typst) 연구 노트 파일들을 읽어옵니다.",
                    parameters=types.Schema(
                        type=types.Type.OBJECT,
                        properties={
                            "query": types.Schema(
                                type=types.Type.STRING,
                                description="찾고자 하는 수학적 개념이나 키워드 (예: 'divergence', 'metric')"
                            )
                        },
                        required=["query"] # query를 필수로 지정하여 빈 값(None) 반환을 원천 차단합니다.
                    )
                )
            ]
        )

        self.chat = self.client.chats.create(
            model=self.model_name,
            config=types.GenerateContentConfig(
                tools=[project_knowledge_tool], # 파이썬 함수 대신 스키마 객체를 주입합니다.
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
            response = self.session.chat.send_message(message)
            
            # 도구 호출 루프 (최대 5회 시도) [cite: 2025-11-22]
            for _ in range(5):
                if response.text:
                    return response.text
                
                # [방어적 코딩] 응답 객체의 필수 속성 누락 시 크래시 방지
                if not getattr(response, 'candidates', None) or not response.candidates[0].content:
                    break
                
                parts = response.candidates[0].content.parts
                if not parts: 
                    break

                tool_calls = [p.function_call for p in parts if getattr(p, 'function_call', None)]
                if not tool_calls:
                    break 

                tool_responses = []
                for call in tool_calls:
                    # 인자가 비어있을 경우 빈 딕셔너리로 초기화하여 'NoneType' 에러 차단
                    args = call.args if call.args else {}
                    print(f"🛠️ Tool Calling: {call.name}({args})")
                    
                    if call.name == "read_project_knowledge":
                        # 수동으로 tools.py의 함수를 실행하고 결과를 패키징합니다.
                        result = read_project_knowledge(**args)
                        tool_responses.append(types.Part.from_function_response(
                            name=call.name,
                            response={"result": result}
                        ))
                
                if tool_responses:
                    response = self.session.chat.send_message(tool_responses)
                else:
                    break
            
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
