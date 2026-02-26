import os
import re

def get_project_root():
    """컨테이너 환경 변수를 기반으로 프로젝트 루트를 반환합니다."""
    root = os.getenv("CONTAINER_WORKSPACE_FOLDER") or os.getenv("GITHUB_WORKSPACE")
    if not root:
        raise EnvironmentError("❌ 에러: 컨테이너 환경 변수를 찾을 수 없습니다. Dev Container 내부에서 실행하세요.")
    return root

def update_knowledge_map():
    """프로젝트 전체의 Typst 헤더를 추출하여 지식 지도를 갱신합니다."""
    project_root = get_project_root()
    output_path = os.path.join(project_root, 'Gemini_Tutor', 'data', 'knowledge_map.txt')
    
    exclude_dirs = {'.git', 'Gemini_Tutor', 'Styles', 'Tools', 'fonts', 'test'}
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

def read_project_knowledge():
    """Gemini가 스스로 판단하여 호출하는 도구: 프로젝트 전체 노트를 읽어 반환합니다."""
    project_root = get_project_root()
    exclude_dirs = {'.git', 'Gemini_Tutor', 'Styles', 'Tools', 'fonts', 'test'}
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
