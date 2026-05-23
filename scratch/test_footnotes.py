import subprocess

# Read 2.5.typ
with open("chapter 2/2.5.typ", "r") as f:
    original = f.read()

# Remove footnotes from the mannot-scope equation block
modified = original.replace("#footnote[where the summation convention is used.]", "")
modified = modified.replace("#footnote[becuase $a$ and $b$ are dummy indices and $g^(a j)=g^(j a)$ by the symmetric property of metric. Note that $j$ isn't dummy index.]", "")

try:
    with open("chapter 2/2.5.typ", "w") as f:
        f.write(modified)
    print("Temporarily removed footnotes from 2.5.typ")
    
    # Compile
    res = subprocess.run(
        ["typst", "compile", "--pages", "98", "main.typ", "scratch/test_footnotes_page98.png"],
        capture_output=True,
        text=True
    )
    print("Compilation exit code:", res.returncode)
    print("Stderr:")
    print(res.stderr)

finally:
    # Revert
    with open("chapter 2/2.5.typ", "w") as f:
        f.write(original)
    print("Reverted 2.5.typ")
