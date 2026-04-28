#!/usr/bin/env bash
# Install Gossamer Neovim support: filetype detection, tree-sitter
# highlight queries, and an LSP client config for `gossamer-lsp`.
# Treesitter parser installation is left to your plugin manager (see
# ../neovim/README.md for an nvim-treesitter recipe).
#
# Re-runnable: existing files are removed and replaced.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SRC_NVIM="$ROOT/neovim"
SRC_QUERIES="$ROOT/tree-sitter-gossamer/queries"

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
QUERIES_DST="$CONFIG_DIR/queries/gossamer"
LSP_SRC="$SRC_NVIM/lsp/gossamer.lua"
LSP_DST="$CONFIG_DIR/lsp/gossamer.lua"

mkdir -p "$CONFIG_DIR/ftdetect" "$CONFIG_DIR/lsp"
rm -rf "$QUERIES_DST"
mkdir -p "$QUERIES_DST"

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

if [ -f "$LSP_SRC" ]; then
    if [ -L "$LSP_DST" ] || [ -e "$LSP_DST" ]; then
        rm -f "$LSP_DST"
    fi
    ln -s "$LSP_SRC" "$LSP_DST"
    echo "linked $LSP_DST"
fi

cat <<EOF

filetype detection, queries, and LSP config are installed.

LSP: on neovim 0.11+ the client at ~/.config/nvim/lsp/gossamer.lua will
launch \`gos lsp\` for .gos buffers automatically once you call
\`vim.lsp.enable("gossamer")\` in your init.lua. \`gos\` must be on PATH;
if it is missing the client fails to start and tree-sitter highlighting
still works.

to enable tree-sitter highlighting, install the parser via your plugin
manager - see $ROOT/neovim/README.md for a lazy.nvim recipe.
EOF
