import os
from google import genai
from google.genai import types
from .tools import read_project_knowledge

class TutorAgent:
    def __init__(self, api_key):
        self.client = genai.Client(api_key=api_key)
        
        # 시스템 명령문 로드
        with open('config/system_instructions.md', 'r', encoding='utf-8') as f:
            instructions = f.read()
            
        self.chat = self.client.chats.create(
            model="gemini-2.0-pro",
            config=types.GenerateContentConfig(
                tools=[read_project_knowledge], # 함수 호출 활성화
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
