#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

HOST="${HOST:-0.0.0.0}"
PORT="${PORT:-8000}"
SERVE_DIR="${SERVE_DIR:-$PWD}"

# Typst watch settings
TYPST_INPUT="${TYPST_INPUT:-main.typ}"
TYPST_OUTPUT="${TYPST_OUTPUT:-main.pdf}"

cleanup() {
  local exit_code=$?
  if [[ -n "${WATCH_PID:-}" ]] && kill -0 "$WATCH_PID" 2>/dev/null; then
    kill "$WATCH_PID" 2>/dev/null || true
    wait "$WATCH_PID" 2>/dev/null || true
  fi
  exit "$exit_code"
}
trap cleanup EXIT INT TERM

if ! command -v typst >/dev/null 2>&1; then
  echo "Error: typst command not found. Please install Typst in this environment."
  exit 1
fi

if [[ ! -f "$TYPST_INPUT" ]]; then
  echo "Error: Typst input file not found: $TYPST_INPUT"
  exit 1
fi

echo "Starting Typst watcher: $TYPST_INPUT -> $TYPST_OUTPUT"
typst watch "$TYPST_INPUT" "$TYPST_OUTPUT" &
WATCH_PID=$!

echo "Starting PDF server on http://$HOST:$PORT (serving: $SERVE_DIR)"
python3 "$SCRIPT_DIR/pdf_server.py" \
  --host "$HOST" \
  --port "$PORT" \
  --directory "$SERVE_DIR"
