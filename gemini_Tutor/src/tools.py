import os
import re

def get_project_root():
    """
    Codespace / Dev Container 환경 변수를 통해 프로젝트 루트를 반환합니다.
    컨테이너 네이티브(Container-Native) 환경에 최적화된 방식입니다.
    """
    # CONTAINER_WORKSPACE_FOLDER가 없으면 GITHUB_WORKSPACE를 찾음
    env_root = os.getenv("CONTAINER_WORKSPACE_FOLDER") or os.getenv("GITHUB_WORKSPACE")
    
    if not env_root:
        # 이 도구가 컨테이너 밖에서 실행되는 참사를 막기 위한 하드 스톱(Hard Stop)
        raise EnvironmentError("❌ 치명적 오류: 이 에이전트는 Dev Container 또는 GitHub Codespaces 환경 내부에서만 실행되어야 합니다.")
        
    return env_root

def read_project_knowledge():
    """Gemini가 호출할 함수: 프로젝트 내 모든 수학 노트를 읽어 반환합니다."""
    project_root = get_project_root()
    
    exclude_dirs = {'.git', 'Gemini_Tutor', 'Styles', 'Tools', 'fonts', 'test'}
    full_context = []
    
    for root, dirs, files in os.walk(project_root):
        dirs[:] = [d for d in dirs if d not in exclude_dirs]
        for file in files:
            if file.endswith('.typ'):
                path = os.path.join(root, file)
                try:
                    with open(path, 'r', encoding='utf-8') as f:
                        rel_path = os.path.relpath(path, project_root)
                        full_context.append(f"--- PATH: {rel_path} ---\n{f.read()}\n")
                except Exception as e:
                    print(f"⚠️ {rel_path} 읽기 실패: {e}")
                    
    return "\n".join(full_context)

