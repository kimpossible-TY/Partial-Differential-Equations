import os
import re

def get_project_root():
    # Priority check for Codespaces environment
    for env_var in ["CONTAINER_WORKSPACE_FOLDER", "GITHUB_WORKSPACE", "CODESPACE_VSCODE_FOLDER"]:
        root = os.getenv(env_var)
        if root and os.path.exists(root):
            return root
    return "/workspaces/Partial-Differential-Equations"

def update_knowledge_map():
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

def read_project_knowledge():
    root = get_project_root()
    exclude_dirs = {'.git', 'gemini_Tutor', 'Styles', 'Tools', 'fonts', 'test'}
    full_context = []
    for r, dirs, files in os.walk(root):
        dirs[:] = [d for d in dirs if d not in exclude_dirs]
        for file in files:
            if file.endswith('.typ'):
                with open(os.path.join(r, file), 'r', encoding='utf-8') as f:
                    full_context.append(f"--- PATH: {os.path.relpath(os.path.join(r, file), root)} ---\n{f.read()}\n")
    return "\n".join(full_context)
