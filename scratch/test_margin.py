import subprocess

# Read main.typ
with open("main.typ", "r") as f:
    original = f.read()

# Replace margin: auto with margin: 2.5cm
modified = original.replace("margin: auto", "margin: 2.5cm")

try:
    with open("main.typ", "w") as f:
        f.write(modified)
    print("Temporarily set fixed margin in main.typ")
    
    # Compile
    res = subprocess.run(
        ["typst", "compile", "--root", ".", "main.typ", "scratch/test_margin.pdf"],
        capture_output=True,
        text=True
    )
    print("Compilation exit code:", res.returncode)
    print("Stderr:")
    print(res.stderr)

finally:
    # Revert
    with open("main.typ", "w") as f:
        f.write(original)
    print("Reverted main.typ")
