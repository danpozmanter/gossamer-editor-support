#!/usr/bin/env bash
# Install the Gossamer VSCode extension (development install via symlink).
# Re-runnable. Refresh the extension by reloading the VSCode window.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$(cd "$SCRIPT_DIR/../vscode" && pwd)"

case "$(uname -s)" in
    Darwin|Linux) EXT_DIR="$HOME/.vscode/extensions" ;;
    MINGW*|MSYS*|CYGWIN*) EXT_DIR="$APPDATA/Code/User/extensions" ;;
    *) echo "unsupported platform: $(uname -s)" >&2; exit 1 ;;
esac

TARGET="$EXT_DIR/gossamer-lang.gossamer-0.1.0"

mkdir -p "$EXT_DIR"

if [ -L "$TARGET" ] || [ -e "$TARGET" ]; then
    rm -rf "$TARGET"
fi

ln -s "$SRC_DIR" "$TARGET"

echo "installed: $TARGET -> $SRC_DIR"
echo "reload VSCode (Cmd/Ctrl+Shift+P -> 'Developer: Reload Window') and open a .gos file."
