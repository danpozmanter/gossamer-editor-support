#!/usr/bin/env bash
# Install Gossamer Neovim support: filetype detection and tree-sitter
# highlight queries. Treesitter parser installation is left to your
# plugin manager (see ../neovim/README.md for an nvim-treesitter recipe).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SRC_NVIM="$ROOT/neovim"
SRC_QUERIES="$ROOT/tree-sitter-gossamer/queries"

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
QUERIES_DST="$CONFIG_DIR/queries/gossamer"

mkdir -p "$CONFIG_DIR/ftdetect" "$QUERIES_DST"

for f in "$SRC_NVIM/ftdetect"/*; do
    [ -e "$f" ] || continue
    target="$CONFIG_DIR/ftdetect/$(basename "$f")"
    if [ -L "$target" ] || [ -e "$target" ]; then
        rm -f "$target"
    fi
    ln -s "$f" "$target"
    echo "linked $target"
done

cp "$SRC_QUERIES"/*.scm "$QUERIES_DST/"
echo "copied highlight queries to $QUERIES_DST"

cat <<EOF

filetype detection and queries are installed.
to enable tree-sitter highlighting, install the parser via your plugin
manager - see $ROOT/neovim/README.md for a lazy.nvim recipe.
EOF
