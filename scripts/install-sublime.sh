#!/usr/bin/env bash
# Install Gossamer Sublime Text syntax + settings into the Packages
# directory for the host OS.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$(cd "$SCRIPT_DIR/../sublime" && pwd)"

case "$(uname -s)" in
    Darwin) PKG_DIR="$HOME/Library/Application Support/Sublime Text/Packages" ;;
    Linux)  PKG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/sublime-text/Packages" ;;
    MINGW*|MSYS*|CYGWIN*) PKG_DIR="$APPDATA/Sublime Text/Packages" ;;
    *) echo "unsupported platform: $(uname -s)" >&2; exit 1 ;;
esac

DST="$PKG_DIR/Gossamer"
mkdir -p "$PKG_DIR"

if [ -e "$DST" ] || [ -L "$DST" ]; then
    rm -rf "$DST"
fi

cp -r "$SRC" "$DST"
echo "installed: $DST"
echo "open a .gos file in Sublime Text to confirm highlighting."
