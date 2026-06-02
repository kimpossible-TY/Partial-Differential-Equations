#!/usr/bin/env python3
"""Wrapper for the reusable pdf-versioning server tool."""

from __future__ import annotations

import runpy
import sys
from pathlib import Path


def main() -> None:
    root = Path(__file__).resolve().parent
    candidates = [
        root / "typst-packages" / "tools" / "pdf-versioning" / "pdf_version_server.py",
        root.parent.parent / "typst-packages" / "tools" / "pdf-versioning" / "pdf_version_server.py",
    ]

    for tool_path in candidates:
        if tool_path.exists():
            sys.argv[0] = str(tool_path)
            runpy.run_path(str(tool_path), run_name="__main__")
            return

    raise SystemExit(
        "Missing pdf-versioning tool. Expected typst-packages/tools/pdf-versioning/"
        "pdf_version_server.py next to this checkout or under /Users/taeyoung/Documents."
    )


if __name__ == "__main__":
    main()
