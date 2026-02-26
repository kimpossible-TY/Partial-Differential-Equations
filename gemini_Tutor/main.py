import os
from src.core import TutorAgent
from src.tools import update_knowledge_map, get_project_root

def main():
    try:
        root = get_project_root()
    except EnvironmentError as e:
        print(e)
        return

    # GitHub User Secret 또는 Codespace Secret에서 키 로드
    api_key = os.getenv("GEMINI_API_KEY")
    if not api_key:
        print("❌ GEMINI_API_KEY가 없습니다. GitHub Secrets 설정을 확인하세요.")
        return

    # 시작 시 지식 지도 갱신
    update_knowledge_map()
    
    agent = TutorAgent(api_key)
    print(f"🎓 Riemannian Geometry Tutor Active")
    print(f"📍 Project Root: {root}")

    while True:
        try:
            user_input = input("\nUser >> ").strip()
            if user_input.lower() in ['exit', 'quit']: break
            if not user_input: continue

            payloads = []
            # PDF 입력 처리 예시: pdf:extracts/book.pdf 질문내용
            if user_input.startswith("pdf:"):
                parts = user_input.split(" ", 1)
                pdf_rel_path = parts[0].replace("pdf:", "")
                user_input = parts[1] if len(parts) > 1 else "이 내용을 분석하라."
                
                pdf_full_path = os.path.join(root, pdf_rel_path)
                
                if os.path.exists(pdf_full_path):
                    print(f"📄 PDF 분석 중: {pdf_rel_path}...")
                    uploaded_file = agent.client.files.upload(file=pdf_full_path)
                    payloads.append(uploaded_file)
                else:
                    print(f"⚠️ 파일을 찾을 수 없습니다: {pdf_full_path}")

            response = agent.send_query(user_input, file_payloads=payloads)
            print(f"\nTutor >> {response.text}")
            
        except Exception as e:
            print(f"⚠️ 오류 발생: {e}")

if __name__ == "__main__":
    main()
