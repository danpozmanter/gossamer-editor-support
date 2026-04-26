#!/usr/bin/env bash
# Install Gossamer support for Helix:
#   - merges the [[language]] / [[grammar]] entries into ~/.config/helix/languages.toml
#     (the grammar source is rewritten to the local tree-sitter-gossamer/
#     directory so nothing is fetched from GitHub)
#   - copies tree-sitter highlight queries into the runtime
#   - builds the grammar via `hx --grammar build`
#
# Idempotent: re-runs skip the merge if a Gossamer entry is already present.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SRC_TOML="$ROOT/helix/languages.toml"
GRAMMAR_DIR="$ROOT/tree-sitter-gossamer"
QUERIES_SRC="$GRAMMAR_DIR/queries"

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/helix"
TARGET_TOML="$CONFIG_DIR/languages.toml"
QUERIES_DST="$CONFIG_DIR/runtime/queries/gossamer"

mkdir -p "$CONFIG_DIR" "$QUERIES_DST"

if [ ! -f "$GRAMMAR_DIR/src/parser.c" ]; then
    if ! command -v tree-sitter >/dev/null 2>&1; then
        echo "tree-sitter CLI not found and $GRAMMAR_DIR/src/parser.c is missing." >&2
        echo "install it with 'npm install -g tree-sitter-cli' (or 'cargo install tree-sitter-cli') and re-run." >&2
        exit 1
    fi
    (cd "$GRAMMAR_DIR" && tree-sitter generate)
    echo "generated $GRAMMAR_DIR/src/parser.c"
fi

if [ -f "$TARGET_TOML" ] && grep -q '^name = "gossamer"' "$TARGET_TOML"; then
    echo "languages.toml already contains a gossamer entry; skipping merge"
else
    {
        echo ""
        echo "# --- gossamer (added by gossamer-editor-support) ---"
        sed "s|^source = { git = .*\$|source = { path = \"$GRAMMAR_DIR\" }|" "$SRC_TOML"
    } >> "$TARGET_TOML"
    echo "merged gossamer entries into $TARGET_TOML"
    echo "  grammar source: $GRAMMAR_DIR"
fi

cp "$QUERIES_SRC"/*.scm "$QUERIES_DST/"
echo "copied highlight queries to $QUERIES_DST"

if command -v hx >/dev/null 2>&1; then
    hx --grammar build
else
    echo "hx not found on PATH; run 'hx --grammar build' manually"
fi

echo "done. open a .gos file in helix to confirm."
