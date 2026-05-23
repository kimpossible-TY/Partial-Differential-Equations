import subprocess
import re
import os

# Read 2.5.typ
with open("chapter 2/2.5.typ", "r") as f:
    content = f.read()

# Replace preview first
modified = content.replace("@preview", "__PREVIEW__")
# Replace all @label with "Equation"
modified = re.sub(r'@[a-zA-Z0-9_-]+', '"Equation"', modified)
# Replace back preview
modified = modified.replace("__PREVIEW__", "@preview")
# Replace all #(s.ref)("...") and #(l.ref)("...") with "Reference"
modified = re.sub(r'#\([a-z]\.ref\)\("[^"]+"\)', '"Reference"', modified)

# Write to chapter 2/temp_2_5.typ
temp_path = "chapter 2/temp_2_5.typ"
with open(temp_path, "w") as f:
    f.write(modified)

# Compile temp_2_5.typ
res = subprocess.run(
    ["typst", "compile", "--root", ".", temp_path, "scratch/temp_2_5.pdf"],
    capture_output=True,
    text=True
)
print("Exit code:", res.returncode)
print("Stderr:")
print(res.stderr)

# Clean up
if os.path.exists(temp_path):
    os.remove(temp_path)
