"""Shell execution helpers for NightWatch."""

from __future__ import annotations

import os
import subprocess
from typing import Mapping


def run_command(command: str, shell: bool = True, env: Mapping[str, str] | None = None):
    """Run a command while streaming stdout/stderr to the console."""
    current_env = os.environ.copy()
    if env:
        current_env.update(env)

    process = subprocess.Popen(
        command,
        shell=shell,
        env=current_env,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        bufsize=1,
        universal_newlines=True,
    )

    output: list[str] = []
    if process.stdout:
        for line in process.stdout:
            print(line, end="", flush=True)
            output.append(line)

    process.wait()
    if process.returncode != 0:
        print(f"❌ Command failed with return code {process.returncode}")
    return process.returncode, "".join(output)

