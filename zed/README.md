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

## Status

Highlighting only. No language server yet.
