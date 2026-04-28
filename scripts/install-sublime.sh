#!/usr/bin/env bash
# Install Gossamer Sublime Text syntax + settings into the Packages
# directory for the host OS. Also merges the Gossamer LSP client into
# Packages/User/LSP.sublime-settings (the Sublime LSP package reads
# from there) so `gos lsp` is launched for .gos buffers when the LSP
# package is installed.
#
# Re-runnable: any prior gossamer install is removed and replaced.

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
USER_DIR="$PKG_DIR/User"
LSP_USER_SETTINGS="$USER_DIR/LSP.sublime-settings"
LSP_SNIPPET="$SRC/LSP-gossamer.sublime-settings"

mkdir -p "$PKG_DIR" "$USER_DIR"

if [ -e "$DST" ] || [ -L "$DST" ]; then
    rm -rf "$DST"
fi

cp -r "$SRC" "$DST"
echo "installed: $DST"

# Merge the gossamer LSP client into Packages/User/LSP.sublime-settings.
# Sublime's LSP package reads its `clients` map from that file.
if command -v python3 >/dev/null 2>&1; then
    python3 - "$LSP_USER_SETTINGS" "$LSP_SNIPPET" <<'PY'
import json
import re
import sys
from pathlib import Path

target = Path(sys.argv[1])
snippet = Path(sys.argv[2])

def load_relaxed(p: Path) -> dict:
    if not p.exists():
        return {}
    text = p.read_text()
    # strip // and /* */ comments so json.loads accepts ST-style settings
    text = re.sub(r"/\*.*?\*/", "", text, flags=re.S)
    text = re.sub(r"^\s*//.*$", "", text, flags=re.M)
    text = re.sub(r",(\s*[}\]])", r"\1", text)
    text = text.strip() or "{}"
    try:
        return json.loads(text)
    except json.JSONDecodeError as e:
        print(f"warning: could not parse {p}: {e}; LSP merge skipped", file=sys.stderr)
        sys.exit(0)

current = load_relaxed(target)
add = json.loads(snippet.read_text())
clients = current.setdefault("clients", {})
clients["gossamer"] = add["clients"]["gossamer"]

target.parent.mkdir(parents=True, exist_ok=True)
target.write_text(json.dumps(current, indent=2) + "\n")
print(f"merged gossamer LSP client into {target}")
PY
else
    echo "warning: python3 not found; skipping LSP.sublime-settings merge."
    echo "         add the contents of $LSP_SNIPPET to"
    echo "         $LSP_USER_SETTINGS manually to enable LSP."
fi

cat <<EOF

open a .gos file in Sublime Text to confirm highlighting.

LSP: install the "LSP" package via Package Control. The Gossamer client
launches \`gos lsp\` when \`gos\` is on PATH; if it is missing the LSP
client is inactive and syntax highlighting still works.
EOF
