#!/usr/bin/env bash
# Install the Gossamer Zed extension as a dev extension.
# Zed loads dev extensions from the command palette, so this script
# prints the steps and confirms the source path is ready.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$(cd "$SCRIPT_DIR/../zed" && pwd)"

if [ ! -f "$SRC_DIR/extension.toml" ]; then
    echo "missing $SRC_DIR/extension.toml" >&2
    exit 1
fi

echo "Gossamer Zed extension source: $SRC_DIR"
echo
echo "To install, in Zed:"
echo "  1. Open the command palette (Cmd/Ctrl+Shift+P)"
echo "  2. Run: zed: install dev extension"
echo "  3. Select the directory above"
echo "  4. Reload the window"
echo
echo "Open a .gos file to confirm highlighting."
