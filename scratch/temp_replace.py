import os

files_to_modify = [
    "Preliminaries/Riemannian manifolds/covariant Derivatives of tensor fields.typ",
    "Preliminaries/Riemannian manifolds/parallel_transport.typ",
    "chapter 1/1.11.typ"
]

# Read original contents
originals = {}
for fpath in files_to_modify:
    if os.path.exists(fpath):
        with open(fpath, "r") as f:
            originals[fpath] = f.read()

try:
    # Modify files: replace annot-cetz( with annot-cetz-local(
    for fpath in files_to_modify:
        if fpath in originals:
            content = originals[fpath]
            # Replace annot-cetz( with annot-cetz-local(
            # First, check if annot-cetz-local is already imported (styles.typ imports it)
            modified = content.replace("annot-cetz(", "annot-cetz-local(")
            with open(fpath, "w") as f:
                f.write(modified)
            print(f"Modified {fpath}")

    # Compile main.typ
    import subprocess
    res = subprocess.run(
        ["typst", "compile", "--root", ".", "main.typ", "scratch/test_replace.pdf"],
        capture_output=True,
        text=True
    )
    print("Compilation exit code:", res.returncode)
    print("Stderr:")
    print(res.stderr)

finally:
    # Revert changes
    for fpath, content in originals.items():
        with open(fpath, "w") as f:
            f.write(content)
        print(f"Reverted {fpath}")
