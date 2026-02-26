import os
import re

def get_project_root():
    """
    Codespaces의 실제 경로와 환경 변수를 모두 체크하여 
    정확한 프로젝트 루트를 반환합니다.
    """
    # 1. Codespaces 표준 환경 변수들 확인
    for env_var in ["CONTAINER_WORKSPACE_FOLDER", "GITHUB_WORKSPACE", "CODESPACE_VSCODE_FOLDER"]:
        root = os.getenv(env_var)
        if root and os.path.exists(root):
            return root
            
    # 2. 이미지에서 확인된 실제 경로 강제 지정 (Fallback)
    # 당신의 Codespace 경로는 /workspaces/Partial-Differential-Equations 입니다.
    standard_path = "/workspaces/Partial-Differential-Equations"
    if os.path.exists(standard_path):
        return standard_path

    # 3. 최후의 수단: 현재 파일 위치 기준 계산
    current_file = os.path.abspath(__file__)
    return os.path.dirname(os.path.dirname(os.path.dirname(current_file)))

def read_project_knowledge():
    """
    오류 방지를 위해 인자(Parameter)를 제거했습니다.
    Gemini가 호출하면 자동으로 프로젝트 전체를 스캔합니다.
    """
    project_root = get_project_root()
    exclude_dirs = {'.git', 'gemini_Tutor', 'Styles', 'Tools', 'fonts', 'test'}
    full_context = []
    
    for root, dirs, files in os.walk(project_root):
        dirs[:] = [d for d in dirs if d not in exclude_dirs]
        for file in files:
            if file.endswith('.typ'):
                path = os.path.join(root, file)
                rel_path = os.path.relpath(path, project_root)
                with open(path, 'r', encoding='utf-8') as f:
                    full_context.append(f"--- PATH: {rel_path} ---\n{f.read()}\n")
    return "\n".join(full_context)
