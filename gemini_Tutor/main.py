import os
import sys
from dotenv import load_dotenv
from src.core import TutorAgent
from src.tools import update_knowledge_map

load_dotenv('config/.env')

def main():
    api_key = os.getenv("GEMINI_API_KEY")
    if not api_key:
        print("❌ API 키가 설정되지 않았습니다. config/.env 파일을 확인하세요.")
        return

    # 시작 시 지식 지도 자동 갱신
    update_knowledge_map()
    
    agent = TutorAgent(api_key)
    print("🎓 Riemannian Geometry Tutor가 준비되었습니다.")
    print("팁: PDF 파일을 대화에 포함하려면 'pdf:파일명'을 입력하세요.")

    while True:
        user_input = input("\nUser >> ")
        if user_input.lower() in ['exit', 'quit']: break

        payloads = []
        # PDF 파일 처리 로직 (간단 구현)
        if user_input.startswith("pdf:"):
            parts = user_input.split(" ", 1)
            pdf_path = parts[0].replace("pdf:", "")
            user_input = parts[1] if len(parts) > 1 else "이 PDF의 내용을 분석해줘."
            
            if os.path.exists(pdf_path):
                print(f"📄 PDF '{pdf_path}' 업로드 중...")
                uploaded_file = agent.client.files.upload(file=pdf_path)
                payloads.append(uploaded_file)

        response = agent.send_query(user_input, file_payloads=payloads)
        print(f"\nTutor >> {response.text}")

if __name__ == "__main__":
    main()
