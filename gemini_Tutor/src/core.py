import os
from google import genai
from google.genai import types
from .tools import get_project_root, read_project_knowledge

class TutorAgent:
    def __init__(self, api_key):
        self.client = genai.Client(api_key=api_key)
        
        project_root = get_project_root()
        config_path = os.path.join(project_root, 'Gemini_Tutor', 'config', 'system_instructions.md')
        
        with open(config_path, 'r', encoding='utf-8') as f:
            instructions = f.read()
            
        self.chat = self.client.chats.create(
            model="gemini-2.0-flash", # 고성능 추론을 원할 시 gemini-2.0-pro 권장
            config=types.GenerateContentConfig(
                tools=[read_project_knowledge],
                system_instruction=instructions,
                temperature=0.1
            )
        )

    def send_query(self, message, file_payloads=None):
        contents = []
        if file_payloads:
            contents.extend(file_payloads)
        contents.append(message)
        return self.chat.send_message(contents)
