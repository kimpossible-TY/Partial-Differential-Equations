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
        """시스템 지침을 로드하고 도구 스키마가 정의된 세션을 생성합니다."""
        project_root = get_project_root()
        config_path = os.path.join(project_root, 'gemini_Tutor', 'config', 'system_instructions.md')
        try:
            with open(config_path, 'r', encoding='utf-8') as f:
                instructions = f.read()
        except FileNotFoundError:
            instructions = "You are a strict Riemannian Geometry Tutor."

        # [스키마 강제] 모델이 인자를 누락하지 못하도록 엄격하게 정의합니다. [cite: 2025-11-22]
        project_knowledge_tool = types.Tool(
            function_declarations=[
                types.FunctionDeclaration(
                    name="read_project_knowledge",
                    description="프로젝트 내의 .typ 및 가이드라인(.md) 파일을 읽어 연구 지식을 제공합니다.",
                    parameters=types.Schema(
                        type=types.Type.OBJECT,
                        properties={
                            "query": types.Schema(
                                type=types.Type.STRING,
                                description="찾고자 하는 수학적 개념, 스타일 가이드, 혹은 LaTeX-Typst 비교 지침"
                            )
                        },
                        required=["query"]
                    )
                )
            ]
        )

        self.chat = self.client.chats.create(
            model=self.model_name,
            config=types.GenerateContentConfig(
                tools=[project_knowledge_tool],
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

    def write_document(self):
        """
        현재까지의 논의를 바탕으로 Typst 코드 초안을 작성합니다.
        가이드라인과 스타일 가이드를 참조하도록 모델을 유도합니다. [cite: 2025-11-22]
        """
        prompt = (
            "지금까지 우리가 나눈 수학적 논의를 바탕으로 Typst(.typ) 코드 초안을 작성해줘. "
            "작성 시 반드시 다음 지침을 엄격히 따라야 해:\n"
            "1. 'read_project_knowledge' 도구를 사용하여 'code_style_guide.md'와 "
            "'LaTeX-Typst 비교 문서'를 찾아 그 스타일과 문법을 완벽히 준수할 것.\n"
            "2. LaTeX 스타일의 명령어가 아닌 순수한 Typst 문법을 사용할 것.\n"
            "3. 모든 수식은 우리가 합의한 정의와 기호를 사용할 것.\n"
            "설명 없이 코드만 깔끔하게 출력해줘."
        )
        return self.send_query(prompt)

    def send_query(self, message):
        """수동 루프를 통해 도구 호출을 제어하며, 비텍스트 응답 경고를 방지합니다."""
        try:
            response = self.session.chat.send_message(message)
            
            for _ in range(5):
                # [경고 방지] 텍스트 파트가 실제로 존재할 때만 .text에 접근합니다.
                has_text = any(hasattr(p, 'text') and p.text for p in response.candidates[0].content.parts)
                if has_text:
                    return response.text
                
                # 도구 호출(Function Call) 분석 및 실행
                if not response.candidates or not response.candidates[0].content:
                    break
                
                parts = response.candidates[0].content.parts
                tool_calls = [p.function_call for p in parts if getattr(p, 'function_call', None)]
                
                if not tool_calls:
                    break 

                tool_responses = []
                for call in tool_calls:
                    args = call.args if call.args else {}
                    print(f"🛠️ Tool Calling: {call.name}({args})")
                    
                    if call.name == "read_project_knowledge":
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
