import os
import sys
# Corrected absolute imports for top-level script
from src.core import TutorAgent 
from src.tools import update_knowledge_map, get_project_root

def main():
    try:
        root = get_project_root()
    except EnvironmentError as e:
        print(e); return

    api_key = os.getenv("GEMINI_API_KEY")
    if not api_key:
        print("❌ GEMINI_API_KEY missing"); return

    update_knowledge_map()
    agent = TutorAgent(api_key, model_name="gemini-2.5-flash") #
    
    print(f"🎓 Tutor Active | Model: 2.5 Series")

    while True:
        try:
            user_input = input(f"\n[{agent.session.model_name}] User >> ").strip()
            if not user_input: continue

            if user_input.startswith(":"):
                cmd = user_input.lower()
                if cmd == ":pro":
                    agent.switch_model("gemini-2.5-pro"); print("🔥 Switched to Pro"); continue
                elif cmd == ":flash":
                    agent.switch_model("gemini-2.5-flash"); print("⚡ Switched to Flash"); continue
                elif cmd in [":exit", ":quit"]:
                    path = agent.shutdown(); print(f"💾 Saved: {path}"); break

            response = agent.send_query(user_input)
            print(f"\nTutor >> {response}")
        except Exception as e:
            print(f"⚠️ Error: {e}")

if __name__ == "__main__":
    main()
