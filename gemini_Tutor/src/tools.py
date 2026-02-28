import os
import re

def get_project_root():
    """Codespace 또는 로컬 환경에 맞는 프로젝트 루트 경로를 반환합니다."""
    # Priority check for Codespaces environment
    for env_var in ["CONTAINER_WORKSPACE_FOLDER", "GITHUB_WORKSPACE", "CODESPACE_VSCODE_FOLDER"]:
        root = os.getenv(env_var)
        if root and os.path.exists(root):
            return root
    return "/workspaces/Partial-Differential-Equations"

def update_knowledge_map():
    """프로젝트 내의 .typ 파일 목록을 스캔하여 지식 지도를 갱신합니다."""
    root = get_project_root()
    output_path = os.path.join(root, 'gemini_Tutor', 'data', 'knowledge_map.txt')
    exclude_dirs = {'.git', 'gemini_Tutor', 'Styles', 'Tools', 'fonts', 'test'}
    knowledge_map = []
    
    for r, dirs, files in os.walk(root):
        dirs[:] = [d for d in dirs if d not in exclude_dirs]
        for file in files:
            if file.endswith('.typ'):
                knowledge_map.append(f"📄 File: {os.path.relpath(os.path.join(r, file), root)}")
    
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write("# PROJECT KNOWLEDGE MAP\n\n" + "\n".join(knowledge_map))
    print(f"✅ 지식 지도가 갱신되었습니다: {output_path}")

def read_project_knowledge(query: str):
    """프로젝트 내의 .typ 및 .md(스타일 가이드 등) 파일을 읽어 연구 지식을 제공합니다."""
    print(f"\n🔍 DEBUG: 튜터가 '{query}'와 관련된 지식 및 가이드를 검색 중입니다...")
    
    root = get_project_root()
    exclude_dirs = {'.git', 'gemini_Tutor', 'Styles', 'Tools', 'fonts', 'test'}
    full_context = []
    
    # 가이드라인(.md)과 연구 노트(.typ)를 모두 포함합니다.
    allowed_extensions = ('.typ', '.md', '.txt')
    
    for r, dirs, files in os.walk(root):
        dirs[:] = [d for d in dirs if d not in exclude_dirs]
        for file in files:
            if file.endswith(allowed_extensions):
                file_path = os.path.join(r, file)
                try:
                    with open(file_path, 'r', encoding='utf-8') as f:
                        full_context.append(f"--- PATH: {os.path.relpath(file_path, root)} ---\n{f.read()}\n")
                except Exception as e:
                    print(f"⚠️ 읽기 실패 {file}: {e}")

    return "\n".join(full_context) if full_context else "검색된 지식이 없습니다."

