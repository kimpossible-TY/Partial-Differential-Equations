import subprocess
import os

def test_compile(includes_to_keep):
    # Read main.typ
    with open("main.typ", "r") as f:
        lines = f.readlines()
    
    # Modify includes
    new_lines = []
    for line in lines:
        if "include" in line:
            # Check if this include is in the keep list
            keep = False
            for inc in includes_to_keep:
                if inc in line:
                    keep = True
                    break
            if not keep:
                new_lines.append("// " + line)
                continue
        new_lines.append(line)
        
    # Write to a temporary file in root
    with open("temp_main.typ", "w") as f:
        f.writelines(new_lines)
        
    # Compile
    res = subprocess.run(
        ["typst", "compile", "--root", ".", "temp_main.typ", "scratch/temp_main.pdf"],
        capture_output=True,
        text=True
    )
    print(f"Testing {includes_to_keep}:")
    print(f"Exit code: {res.returncode}")
    # Print only lines containing warnings or errors, or the last few lines
    stderr_lines = res.stderr.splitlines()
    for l in stderr_lines:
        if "warning" in l or "error" in l or "hint" in l:
            print(l)
    print("=" * 40)
    
    # Clean up
    if os.path.exists("temp_main.typ"):
        os.remove("temp_main.typ")

# Test combinations
test_compile(["cover.typ", "chapter 2"])
test_compile(["cover.typ", "chapter 1"])
test_compile(["cover.typ", "Preliminaries"])
