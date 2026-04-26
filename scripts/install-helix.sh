#!/usr/bin/env bash
# Install Gossamer support for Helix:
#   - merges the [[language]] / [[grammar]] entries into ~/.config/helix/languages.toml
#   - copies tree-sitter highlight queries into the runtime
#   - fetches and builds the grammar via `hx --grammar`
#
# Idempotent: re-runs skip the merge if a Gossamer entry is already present.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SRC_TOML="$ROOT/helix/languages.toml"
QUERIES_SRC="$ROOT/tree-sitter-gossamer/queries"

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/helix"
TARGET_TOML="$CONFIG_DIR/languages.toml"
QUERIES_DST="$CONFIG_DIR/runtime/queries/gossamer"

mkdir -p "$CONFIG_DIR" "$QUERIES_DST"

if [ -f "$TARGET_TOML" ] && grep -q '^name = "gossamer"' "$TARGET_TOML"; then
    echo "languages.toml already contains a gossamer entry; skipping merge"
else
    {
        echo ""
        echo "# --- gossamer (added by gossamer-editor-support) ---"
        cat "$SRC_TOML"
    } >> "$TARGET_TOML"
    echo "merged gossamer entries into $TARGET_TOML"
fi

cp "$QUERIES_SRC"/*.scm "$QUERIES_DST/"
echo "copied highlight queries to $QUERIES_DST"

if command -v hx >/dev/null 2>&1; then
    hx --grammar fetch
    hx --grammar build
else
    echo "hx not found on PATH; run 'hx --grammar fetch && hx --grammar build' manually"
fi

echo "done. open a .gos file in helix to confirm."
