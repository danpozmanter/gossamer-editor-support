# Gossamer for Helix

Helix uses tree-sitter natively. Add the language and grammar entries
from `languages.toml` here into your `~/.config/helix/languages.toml`,
then:

```bash
hx --grammar fetch
hx --grammar build
```

Copy the highlight queries into your runtime so Helix finds them:

```bash
mkdir -p ~/.config/helix/runtime/queries/gossamer
cp ../tree-sitter-gossamer/queries/*.scm ~/.config/helix/runtime/queries/gossamer/
```

Open a `.gos` file to confirm.

## LSP

The `[language-server.gossamer-lsp]` block in `languages.toml` wires
Helix to launch `gos lsp` for `.gos` buffers. If `gos` is not on
`PATH`, Helix skips the LSP client and tree-sitter highlighting still
works.
