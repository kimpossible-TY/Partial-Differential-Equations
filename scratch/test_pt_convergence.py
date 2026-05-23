import subprocess
import re
import os

fpath = "Preliminaries/Riemannian manifolds/parallel_transport.typ"
with open(fpath, "r") as f:
    content = f.read()

# Replace preview first
modified = content.replace("@preview", "__PREVIEW__")
# Replace all @label with "Equation"
modified = re.sub(r'@[a-zA-Z0-9_-]+', '"Equation"', modified)
# Replace back preview
modified = modified.replace("__PREVIEW__", "@preview")

# Write to temp file
temp_path = "Preliminaries/Riemannian manifolds/temp_pt.typ"
with open(temp_path, "w") as f:
    f.write(modified)

# Compile temp_pt.typ
res = subprocess.run(
    ["typst", "compile", "--root", ".", temp_path, "scratch/temp_pt.pdf"],
    capture_output=True,
    text=True
)
print("Exit code:", res.returncode)
print("Stderr:")
print(res.stderr)

# Clean up
if os.path.exists(temp_path):
    os.remove(temp_path)
