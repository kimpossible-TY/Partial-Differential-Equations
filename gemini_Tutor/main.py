import os
from src.core import TutorAgent
from src.tools import update_knowledge_map, get_project_root

def main():
    try:
        # CODESPACES 환경 변수를 활용한 정확한 루트 탐색
        root = get_project_root()
    except EnvironmentError as e:
        print(e)
        return

    api_key = os.getenv("GEMINI_API_KEY")
    if not api_key:
        print("❌ 에러: GEMINI_API_KEY가 없습니다.")
        return

    # 지식 지도 갱신 (ImportError 해결 완료)
    update_knowledge_map()
    
    # 2.5 Flash 엔진으로 시작
    agent = TutorAgent(api_key, model_name="gemini-2.5-flash")
    
    print(f"🎓 Riemannian Geometry Tutor Active (2.5 Series)")
    print(f"📍 Project Root: {root}")
    print(f"💡 명령어: ':pro' (2.5 Pro), ':flash' (2.5 Flash), ':exit' (종료)")

    while True:
        try:
            current_label = "2.5 PRO" if "pro" in agent.model_name else "2.5 FLASH"
            user_input = input(f"\n[{current_label}] User >> ").strip()
            
            if not user_input: continue

            if user_input.startswith(":"):
                cmd = user_input.lower()
                if cmd == ":pro":
                    if agent.switch_model("gemini-2.5-pro"):
                        print("🔥 엔진 교체: Gemini 2.5 Pro (심층 추론 모드)")
                    continue
                elif cmd == ":flash":
                    if agent.switch_model("gemini-2.5-flash"):
                        print("⚡ 엔진 교체: Gemini 2.5 Flash (고속 분석 모드)")
                    continue
                elif cmd in [":exit", ":quit"]:
                    break

            payloads = []
            if user_input.startswith("pdf:"):
                parts = user_input.split(" ", 1)
                pdf_rel_path = parts[0].replace("pdf:", "")
                user_input = parts[1] if len(parts) > 1 else "분석 요청"
                
                pdf_full_path = os.path.join(root, pdf_rel_path)
                if os.path.exists(pdf_full_path):
                    print(f"📄 PDF 업로드 중: {pdf_rel_path}")
                    uploaded_file = agent.client.files.upload(file=pdf_full_path)
                    payloads.append(uploaded_file)

            response = agent.send_query(user_input, file_payloads=payloads)
            print(f"\nTutor >> {response.text}")
            
        except Exception as e:
            # 429 Quota 에러 발생 시 결제 연동 안내
            if "429" in str(e):
                print("\n⚠️ Quota 초과: 지식 규모가 커서 유료 요금제(Option C) 연동이 필요합니다.")
            else:
                print(f"\n⚠️ 오류 발생: {e}")

if __name__ == "__main__":
    main()
