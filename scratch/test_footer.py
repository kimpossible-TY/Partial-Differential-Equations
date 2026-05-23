import subprocess

# Read main.typ
with open("main.typ", "r") as f:
    original = f.read()

# Replace footer: context [ ... ] with footer: none
# Find footer: context [ ... ]
# Let's do a replace:
footer_str = """  footer: context [
    #align(right)[
      #counter(page).display("1") / #counter(page).final().last()
    ]
  ],"""

modified = original.replace(footer_str, "  footer: none,")

try:
    with open("main.typ", "w") as f:
        f.write(modified)
    print("Temporarily disabled footer in main.typ")
    
    # Compile
    res = subprocess.run(
        ["typst", "compile", "--root", ".", "main.typ", "scratch/test_footer.pdf"],
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
