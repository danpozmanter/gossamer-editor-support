#!/usr/bin/env bash
# Install the Gossamer Zed extension as a dev extension.
#
# Stages a copy of zed/ under $XDG_DATA_HOME/gossamer-zed-extension with
# the [grammars.gossamer] entry rewritten to a local file:// URL, so Zed
# does not need to fetch the grammar from GitHub when loading.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SRC_DIR="$ROOT/zed"

if [ ! -f "$SRC_DIR/extension.toml" ]; then
    echo "missing $SRC_DIR/extension.toml" >&2
    exit 1
fi

if [ ! -d "$ROOT/.git" ]; then
    echo "warning: $ROOT is not a git repo; Zed may fail to clone the file:// grammar source" >&2
fi

if [ ! -f "$ROOT/tree-sitter-gossamer/src/parser.c" ]; then
    if ! command -v tree-sitter >/dev/null 2>&1; then
        echo "tree-sitter CLI not found and tree-sitter-gossamer/src/parser.c is missing." >&2
        echo "install it with 'npm install -g tree-sitter-cli' (or 'cargo install tree-sitter-cli') and re-run." >&2
        exit 1
    fi
    (cd "$ROOT/tree-sitter-gossamer" && tree-sitter generate)
    echo "generated $ROOT/tree-sitter-gossamer/src/parser.c"
fi

STAGE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/gossamer-zed-extension"
mkdir -p "$STAGE_DIR"
rm -rf "$STAGE_DIR"/* "$STAGE_DIR"/.[!.]* 2>/dev/null || true
cp -a "$SRC_DIR"/. "$STAGE_DIR"/

# Rewrite the grammar block only (leave the top-level extension `repository`
# field alone so the manifest still describes its upstream home).
sed -i.bak \
    "/^\[grammars\.gossamer\]/,/^\[/{
        s|^repository = .*|repository = \"file://$ROOT\"|
        s|^commit = .*|commit = \"HEAD\"|
        s|^path = .*|path = \"tree-sitter-gossamer\"|
    }" \
    "$STAGE_DIR/extension.toml"
rm -f "$STAGE_DIR/extension.toml.bak"

echo "staged Zed extension at: $STAGE_DIR"
echo "  grammar source: file://$ROOT (path: tree-sitter-gossamer)"
echo
echo "To install, in Zed:"
echo "  1. Open the command palette (Cmd/Ctrl+Shift+P)"
echo "  2. Run: zed: install dev extension"
echo "  3. Select: $STAGE_DIR"
echo "  4. Reload the window"
echo
echo "Open a .gos file to confirm highlighting."
echo
echo "LSP: Zed launches language servers from a Rust/WASM extension. To"
echo "     wire \`gos lsp\` without compiling the extension, merge the"
echo "     snippet at $SRC_DIR/settings.json.snippet"
echo "     into your Zed user settings (Cmd/Ctrl+, in Zed)."
