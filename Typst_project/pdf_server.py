#!/usr/bin/env python3
"""Simple PDF static server for GitHub Codespaces."""

from __future__ import annotations

import argparse
import functools
import http.server
import socketserver
from pathlib import Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Serve PDF files over HTTP")
    parser.add_argument(
        "--host",
        default="0.0.0.0",
        help="Host interface to bind (default: 0.0.0.0)",
    )
    parser.add_argument(
        "--port",
        type=int,
        default=8000,
        help="Port to bind (default: 8000)",
    )
    parser.add_argument(
        "--directory",
        default=".",
        help="Directory to serve (default: current directory)",
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    serve_dir = Path(args.directory).expanduser().resolve()

    if not serve_dir.exists() or not serve_dir.is_dir():
        raise SystemExit(f"Invalid directory: {serve_dir}")

    handler = functools.partial(http.server.SimpleHTTPRequestHandler, directory=str(serve_dir))

    with socketserver.TCPServer((args.host, args.port), handler) as httpd:
        print(f"Serving {serve_dir} on http://{args.host}:{args.port}")
        print("Press Ctrl+C to stop")
        httpd.serve_forever()


if __name__ == "__main__":
    main()
