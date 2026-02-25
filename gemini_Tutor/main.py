import os
import sys
from dotenv import load_dotenv
from src.core import TutorAgent
from src.tools import update_knowledge_map

# .env 파일이 없어도 무시하고 시스템 환경 변수를 사용하도록 설정
load_dotenv(os.path.join('config', '.env'))

def main():
    # GitHub Codespaces Secret이 주입된 환경 변수를 읽어옴
    api_key = os.getenv("GEMINI_API_KEY")
    
    if not api_key:
        print("❌ 에러: GEMINI_API_KEY를 찾을 수 없습니다.")
        print("GitHub Settings > Secrets > Codespaces에 키가 등록되었는지 확인하세요.")
        return

    # 지식 지도 자동 갱신
    update_knowledge_map()
    
    try:
        agent = TutorAgent(api_key)
        print("🎓 Riemannian Geometry Tutor가 활성화되었습니다. (GitHub Secrets 로드 완료)")
    except Exception as e:
        print(f"❌ 에이전트 초기화 실패: {e}")
        return

    while True:
        user_input = input("\nUser >> ")
        if user_input.lower() in ['exit', 'quit']: break
        if not user_input.strip(): continue

        payloads = []
        if user_input.startswith("pdf:"):
            # PDF 경로와 메시지 분리 로직
            parts = user_input.split(" ", 1)
            pdf_path = parts[0].replace("pdf:", "")
            user_input = parts[1] if len(parts) > 1 else "이 PDF의 내용을 분석해줘."
            
            # 상위 디렉토리의 PDF 파일을 찾기 위해 경로 확인
            if os.path.exists(pdf_path):
                print(f"📄 PDF '{pdf_path}'를 서버로 전송 중...")
                uploaded_file = agent.client.files.upload(file=pdf_path)
                payloads.append(uploaded_file)
            else:
                print(f"⚠️ 파일을 찾을 수 없습니다: {pdf_path}")

        try:
            response = agent.send_query(user_input, file_payloads=payloads)
            print(f"\nTutor >> {response.text}")
        except Exception as e:
            print(f"⚠️ 오류 발생: {e}")

if __name__ == "__main__":
    main()
