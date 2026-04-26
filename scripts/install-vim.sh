#!/usr/bin/env bash
# Install Gossamer Vim filetype detection, syntax, and indent files
# into ~/.vim/. Files are symlinked so updates flow through.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$(cd "$SCRIPT_DIR/../vim" && pwd)"
DST="$HOME/.vim"

for sub in ftdetect ftplugin indent syntax; do
    mkdir -p "$DST/$sub"
    for f in "$SRC/$sub"/*; do
        [ -e "$f" ] || continue
        target="$DST/$sub/$(basename "$f")"
        if [ -L "$target" ] || [ -e "$target" ]; then
            rm -f "$target"
        fi
        ln -s "$f" "$target"
        echo "linked $target"
    done
done

echo "done. open a .gos file in vim to confirm."
