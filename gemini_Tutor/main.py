import os
import sys
from src.core import TutorAgent
from src.tools import update_knowledge_map, get_project_root

def main():
    try:
        # 컨테이너 환경의 루트 경로 확인
        root = get_project_root()
    except EnvironmentError as e:
        print(e)
        return

    api_key = os.getenv("GEMINI_API_KEY")
    if not api_key:
        print("❌ GEMINI_API_KEY가 환경 변수에 없습니다. Codespace Secret을 확인하세요.")
        return

    # 시작 시 지식 지도 갱신
    update_knowledge_map()
    
    # 초기 모델은 Flash로 시작 (비용 절감)
    agent = TutorAgent(api_key, model_name="gemini-2.0-flash")
    
    print(f"🎓 Riemannian Geometry Tutor Active")
    print(f"📍 Root: {root}")
    print(f"💡 명령어: ':pro' (고성능), ':flash' (고속), ':exit' (종료)")

    while True:
        try:
            # 프롬프트에 현재 활성화된 모델 표시
            model_label = "PRO" if "pro" in agent.model_name else "FLASH"
            user_input = input(f"\n[{model_label}] User >> ").strip()
            
            if not user_input: continue

            # 1. 특수 명령어 처리
            if user_input.startswith(":"):
                cmd = user_input.lower()
                if cmd == ":pro":
                    if agent.switch_model("gemini-2.0-pro"):
                        print("🔥 엔진 교체: Gemini 2.0 Pro (지능 중심 모드, 맥락 유지됨)")
                    continue
                elif cmd == ":flash":
                    if agent.switch_model("gemini-2.0-flash"):
                        print("⚡ 엔진 교체: Gemini 2.0 Flash (속도/비용 중심 모드, 맥락 유지됨)")
                    continue
                elif cmd in [":exit", ":quit"]:
                    print("👋 연구를 종료합니다.")
                    break
                else:
                    print("⚠️ 알 수 없는 명령어입니다.")
                    continue

            # 2. PDF 파일 업로드 처리
            payloads = []
            if user_input.startswith("pdf:"):
                parts = user_input.split(" ", 1)
                pdf_rel_path = parts[0].replace("pdf:", "")
                user_input = parts[1] if len(parts) > 1 else "이 PDF의 내용을 분석해줘."
                
                pdf_full_path = os.path.join(root, pdf_rel_path)
                
                if os.path.exists(pdf_full_path):
                    print(f"📄 PDF 업로드 중: {pdf_rel_path}...")
                    uploaded_file = agent.client.files.upload(file=pdf_full_path)
                    payloads.append(uploaded_file)
                else:
                    print(f"⚠️ 파일을 찾을 수 없습니다: {pdf_full_path}")

            # 3. 질문 전송 및 답변 출력
            response = agent.send_query(user_input, file_payloads=payloads)
            print(f"\nTutor >> {response.text}")
            
        except Exception as e:
            # 유료 요금제 미연동 시 429 에러 발생 가능성 고지
            if "429" in str(e):
                print("\n⚠️ Quota 초과: 무료 티어의 한계입니다. 1분 후 시도하거나 결제를 연동하세요.")
            else:
                print(f"\n⚠️ 오류 발생: {e}")

if __name__ == "__main__":
    main()
