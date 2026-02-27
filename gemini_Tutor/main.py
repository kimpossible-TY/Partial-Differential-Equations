import os
import sys
# Absolute imports are required for the main execution script
from src.core import TutorAgent 
from src.tools import update_knowledge_map, get_project_root #

def main():
    try:
        root = get_project_root()
    except EnvironmentError as e:
        print(f"❌ {e}")
        return

    api_key = os.getenv("GEMINI_API_KEY")
    if not api_key:
        print("❌ ERROR: GEMINI_API_KEY is not set in environment variables.")
        return

    # Update knowledge map before starting
    update_knowledge_map()
    
    # Initialize with the 2026 standard model
    agent = TutorAgent(api_key, model_name="gemini-2.5-flash")
    
    print(f"🎓 Riemannian Geometry Tutor Active")
    print(f"💡 Commands: ':pro' (2.5 Pro), ':flash' (2.5 Flash), ':exit' (Save & Quit)")

    while True:
        try:
            model_label = "PRO" if "pro" in agent.model_name else "FLASH"
            user_input = input(f"\n[{model_label}] User >> ").strip()
            
            if not user_input: continue

            if user_input.startswith(":"):
                cmd = user_input.lower()
                if cmd == ":pro":
                    if agent.switch_model("gemini-2.5-pro"): #
                        print("🔥 Engine Switched: Gemini 2.5 Pro (High-Performance Reasoning)")
                    continue
                elif cmd == ":flash":
                    if agent.switch_model("gemini-2.5-flash"): #
                        print("⚡ Engine Switched: Gemini 2.5 Flash (High-Speed Analysis)")
                    continue
                elif cmd in [":exit", ":quit"]:
                    log_path = agent.shutdown()
                    if log_path:
                        print(f"💾 Session logs saved to: {log_path}")
                    break

            response = agent.send_query(user_input)
            print(f"\nTutor >> {response.text}")
            
        except Exception as e:
            if "429" in str(e): #
                print("\n⚠️ Quota Exceeded. Please wait 1 minute or upgrade to Option C (Billing).")
            else:
                print(f"\n⚠️ Unexpected Error: {e}")

if __name__ == "__main__":
    main()
