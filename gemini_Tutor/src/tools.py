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
    standard_path = "/workspaces/Partial-Differential-Equations"
    if os.path.exists(standard_path):
        return standard_path

    # 3. 최후의 수단: 현재 파일 위치 기준 계산
    current_file = os.path.abspath(__file__)
    return os.path.dirname(os.path.dirname(os.path.dirname(current_file)))

def update_knowledge_map():
    """
    프로젝트 전체의 Typst 헤더를 추출하여 지식 지도를 갱신합니다.
    (main.py에서 임포트하여 사용)
    """
    project_root = get_project_root()
    output_path = os.path.join(project_root, 'gemini_Tutor', 'data', 'knowledge_map.txt')
    
    exclude_dirs = {'.git', 'gemini_Tutor', 'Styles', 'Tools', 'fonts', 'test'}
    knowledge_map = []
    
    for root, dirs, files in os.walk(project_root):
        dirs[:] = [d for d in dirs if d not in exclude_dirs]
        for file in files:
            if file.endswith('.typ'):
                path = os.path.join(root, file)
                rel_path = os.path.relpath(path, project_root)
                knowledge_map.append(f"📄 File: {rel_path}")
                try:
                    with open(path, 'r', encoding='utf-8') as f:
                        for line in f:
                            if line.strip().startswith('='):
                                match = re.match(r'^(={1,6})\s+(.+)$', line.strip())
                                if match:
                                    level = len(match.group(1))
                                    knowledge_map.append(f"{'  ' * (level-1)}- {match.group(2).strip()}")
                    knowledge_map.append("")
                except Exception as e:
                    print(f"⚠️ {rel_path} 읽기 실패: {e}")

    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write("# PROJECT KNOWLEDGE MAP\n\n" + "\n".join(knowledge_map))
    print(f"✅ 지식 지도가 갱신되었습니다: {output_path}")

def read_project_knowledge():
    """
    Gemini가 호출하면 자동으로 프로젝트 전체를 스캔합니다.
    오류 방지를 위해 인자(Parameter)를 제거했습니다.
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
