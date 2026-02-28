import os
import argparse
from src.core import TutorAgent 
from src.tools import update_knowledge_map, get_project_root
from src.logger import HistoryLogger

def main():
    # 1. 커맨드라인 플래그 설정 [cite: 2025-11-22]
    parser = argparse.ArgumentParser(description="Gemini Riemannian Tutor")
    parser.add_argument('--last', action='store_true', help='가장 최근 대화 복구')
    parser.add_argument('--file', type=str, help='특정 로그 파일 복구 (파일명만 입력)')
    args = parser.parse_args()

    try:
        root = get_project_root()
    except EnvironmentError as e:
        print(e); return

    api_key = os.getenv("GEMINI_API_KEY")
    if not api_key:
        print("❌ GEMINI_API_KEY missing"); return

    # 지식 지도 갱신 및 로거 준비
    update_knowledge_map()
    logger = HistoryLogger()
    
    history = []
    source_file = None

    # 2. 복구 로직 실행
    if args.last:
        last_log = logger.get_latest_log()
        if last_log:
            history, source_file = logger.load_history(last_log)
            print(f"🔄 최근 대화 복구됨: {source_file}")
    elif args.file:
        # 파일명만 입력받아 전체 경로 생성
        file_path = os.path.join(logger.log_dir, args.file)
        history, source_file = logger.load_history(file_path)
        if source_file:
            print(f"🔄 특정 대화 복구됨: {source_file}")

    # 3. 튜터 에이전트 초기화 (복구된 history와 source_file 주입)
    agent = TutorAgent(
        api_key, 
        model_name="gemini-2.5-flash", 
        history=history, 
        source_file=source_file
    )
    
    print(f"🎓 Tutor Active | Model: 2.5 Series")
    if source_file:
        print(f"📖 Context restored from: {source_file}")

    # 4. 대화 루프
    while True:
        try:
            user_input = input(f"\n[{agent.session.model_name}] User >> ").strip()
            if not user_input: continue

            if user_input.startswith(":"):
                cmd = user_input.lower()
                if cmd == ":pro":
                    agent.switch_model("gemini-2.5-pro")
                    print("🔥 Switched to Pro"); continue
                elif cmd == ":flash":
                    agent.switch_model("gemini-2.5-flash")
                    print("⚡ Switched to Flash"); continue
                elif cmd in [":exit", ":quit"]:
                    # 종료 시 기록을 저장하고 클라우드 동기화 수행
                    path = agent.shutdown()
                    print(f"💾 Saved & Synced: {path}")
                    break

            response = agent.send_query(user_input)
            print(f"\nTutor >> {response}")
        except Exception as e:
            print(f"⚠️ Error: {e}")

if __name__ == "__main__":
    main()
