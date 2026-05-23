import subprocess

# Read main.typ
with open("main.typ", "r") as f:
    original = f.read()

# Comment out the header: margin: auto, header: context { ... },
# Let's find "header: context" and comment out from there to "footer:"
# We can do a simpler replace in the string for testing:
header_start = "  header: context {"
header_end = "  footer: context ["

try:
    if header_start in original and header_end in original:
        start_idx = original.find(header_start)
        end_idx = original.find(header_end)
        modified = original[:start_idx] + "  // header commented out\n" + original[end_idx:]
        
        with open("main.typ", "w") as f:
            f.write(modified)
        print("Temporarily commented out header in main.typ")
        
        # Compile
        res = subprocess.run(
            ["typst", "compile", "--root", ".", "main.typ", "scratch/test_header.pdf"],
            capture_output=True,
            text=True
        )
        print("Compilation exit code:", res.returncode)
        print("Stderr:")
        print(res.stderr)
    else:
        print("Could not find header markers in main.typ")

finally:
    # Revert
    with open("main.typ", "w") as f:
        f.write(original)
    print("Reverted main.typ")
