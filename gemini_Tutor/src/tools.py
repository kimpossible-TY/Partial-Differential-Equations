import os
import re

def update_knowledge_map(root_dir='..', output_path='data/knowledge_map.txt'):
    """프로젝트 전체의 Typst 헤더를 추출하여 지식 지도를 갱신합니다."""
    exclude_dirs = {'.git', 'Gemini_Tutor', 'Styles', 'Tools', 'fonts', 'test'}
    knowledge_map = []
    
    for root, dirs, files in os.walk(root_dir):
        dirs[:] = [d for d in dirs if d not in exclude_dirs]
        for file in files:
            if file.endswith('.typ'):
                path = os.path.join(root, file)
                rel_path = os.path.relpath(path, root_dir)
                knowledge_map.append(f"📄 File: {rel_path}")
                try:
                    with open(path, 'r', encoding='utf-8') as f:
                        for line in f:
                            if line.strip().startswith('='):
                                match = re.match(r'^(={1,6})\s+(.+)$', line.strip())
                                if match:
                                    level = len(match.group(1))
                                    title = match.group(2)
                                    knowledge_map.append(f"{'  ' * (level-1)}- {title}")
                    knowledge_map.append("")
                except: continue
                
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write("# PROJECT KNOWLEDGE MAP\n\n" + "\n".join(knowledge_map))
    return output_path

def read_project_knowledge(root_dir='..'):
    """Gemini가 호출할 함수: 프로젝트 내 모든 수학 노트를 읽어 반환합니다."""
    exclude_dirs = {'.git', 'Gemini_Tutor', 'Styles', 'Tools', 'fonts', 'test'}
    full_context = []
    
    for root, dirs, files in os.walk(root_dir):
        dirs[:] = [d for d in dirs if d not in exclude_dirs]
        for file in files:
            if file.endswith('.typ'):
                path = os.path.join(root, file)
                with open(path, 'r', encoding='utf-8') as f:
                    full_context.append(f"--- PATH: {os.path.relpath(path, root_dir)} ---\n{f.read()}\n")
    return "\n".join(full_context)
