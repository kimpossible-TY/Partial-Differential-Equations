import subprocess
import os

def test_compile(includes_to_keep):
    # Read chapter 2.typ
    fpath = "chapter 2/chapter 2.typ"
    with open(fpath, "r") as f:
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
        
    # Write back to chapter 2.typ
    with open(fpath, "w") as f:
        f.writelines(new_lines)
        
    # Read main.typ and comment out everything except chapter 2
    with open("main.typ", "r") as f:
        main_original = f.read()
    main_modified = main_original.replace('#include "Preliminaries/preliminaries.typ"', '// #include "Preliminaries/preliminaries.typ"')
    main_modified = main_modified.replace('#include "chapter 1/chapter 1.typ"', '// #include "chapter 1/chapter 1.typ"')
    with open("main.typ", "w") as f:
        f.write(main_modified)

    # Compile
    res = subprocess.run(
        ["typst", "compile", "--root", ".", "main.typ", "scratch/temp_main.pdf"],
        capture_output=True,
        text=True
    )
    
    # Revert main.typ
    with open("main.typ", "w") as f:
        f.write(main_original)
        
    # Revert chapter 2.typ
    with open(fpath, "w") as f:
        f.writelines(lines)
        
    print(f"Testing {includes_to_keep}:")
    print(f"Exit code: {res.returncode}")
    stderr_lines = res.stderr.splitlines()
    for l in stderr_lines:
        if "warning" in l or "error" in l or "hint" in l:
            print(l)
    print("=" * 40)

# Test each include one by one
includes = ["2.2.typ", "2.3.typ", "2.4.typ", "2.5.typ"]
for inc in includes:
    test_compile([inc])
