# Gossamer for Zed

A Zed extension that registers Gossamer as a language and points at
the tree-sitter grammar in `../tree-sitter-gossamer/`.

## Install (development)

In Zed, open the command palette and run **`zed: install dev extension`**,
then point at this directory. Reload the window and `.gos` files will
highlight.

## Layout

```
extension.toml                     # extension manifest
languages/gossamer/config.toml     # language config (file extension, comments…)
languages/gossamer/highlights.scm  # tree-sitter highlight queries
languages/gossamer/brackets.scm    # bracket pairs
languages/gossamer/indents.scm     # indentation rules
```

## LSP

Zed launches language servers from a Rust/WASM extension; this
extension does not ship compiled WASM. Until that lands, wire `gos
lsp` into your Zed user settings — copy `settings.json.snippet` in
this directory into your settings (Cmd/Ctrl+`,` in Zed):

```json
{
  "languages": {
    "Gossamer": { "language_servers": ["gossamer-lsp"] }
  },
  "lsp": {
    "gossamer-lsp": {
      "binary": { "path": "gos", "arguments": ["lsp"] }
    }
  }
}
```

If `gos` is not on `PATH`, Zed reports a startup failure and
tree-sitter highlighting still works.
