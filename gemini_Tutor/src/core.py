import os
from google import genai
from google.genai import types
from src.tools import get_project_root, read_project_knowledge
from src.logger import HistoryLogger

class SessionManager:
    """Manages the Gemini API session and model switching."""
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

        # Ensure history is a list
        safe_history = history if isinstance(history, list) else []

        self.chat = self.client.chats.create(
            model=self.model_name,
            config=types.GenerateContentConfig(
                tools=[read_project_knowledge],
                system_instruction=instructions,
                temperature=0.1
            ),
            history=safe_history
        )

class TutorAgent:
    """Facade class for the user interface."""
    def __init__(self, api_key, model_name="gemini-2.5-flash"):
        self.session = SessionManager(api_key, model_name)
        self.logger = HistoryLogger()
        self.session.create_session()

    @property
    def model_name(self):
        return self.session.model_name

    def switch_model(self, new_model_name):
        """Switches model while migrating history safely."""
        if self.session.model_name == new_model_name:
            return False
        
        current_history = getattr(self.session.chat, 'history', [])
        self.session.model_name = new_model_name
        self.session.create_session(history=current_history)
        return True

    # FIXED: This method must be at the same indentation level as switch_model
    def send_query(self, message, file_payloads=None):
        """
        Sends a message and returns the textual response.
        """
        contents = []
        if file_payloads:
            contents.extend(file_payloads)
        
        if message:
            contents.append(message)
        
        # Capture and return the text
        response = self.session.chat.send_message(contents)
        
        if response and hasattr(response, 'text'):
            return response.text
        return "⚠️ Error: The model produced an empty response."
    
    def shutdown(self):
        """Saves logs before closing."""
        history = getattr(self.session.chat, 'history', [])
        return self.logger.save(history, self.session.model_name)
