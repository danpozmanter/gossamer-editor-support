# gossamer-editor-support

Editor integrations for the [Gossamer programming language](https://github.com/gossamer-lang/gossamer):
syntax highlighting, file detection, comments, brackets, and (where the
editor supports it) tree-sitter queries.

(Support is built in for [Lite Anvil](https://github.com/danpozmanter/lite-anvil/)).
## Editors

| Editor                     | Path                       | Mechanism             |
|----------------------------|----------------------------|-----------------------|
| **Visual Studio Code**     | `vscode/`                  | TextMate grammar      |
| **Tree-sitter (library)**  | `tree-sitter-gossamer/`    | tree-sitter grammar   |
| **Vim**                    | `vim/`                     | Vim syntax + ftplugin |
| **Neovim**                 | `neovim/`                  | tree-sitter wrapper   |
| **Helix**                  | `helix/`                   | tree-sitter + config  |
| **Emacs**                  | `emacs/`                   | `gossamer-mode.el`    |
| **Sublime Text**           | `sublime/`                 | `.sublime-syntax`     |
| **Zed**                    | `zed/`                     | extension + grammar   |

All integrations cover at minimum:

- `.gos` file detection
- Comments (`//`, `/* ... */`)
- Keywords, primitive types, common stdlib types
- Numeric literals (decimal, hex, binary, octal) with type suffixes
- String, byte-string, raw-string, and char literals
- The forward-pipe operator `|>`
- Attributes (`#[...]`, `#![...]`)
- Function-call detection (identifier-before-paren)

None of them ship a language server today - `gos` does not yet expose
one. When that lands upstream, the LSP-aware editors (VSCode, Helix,
Neovim, Zed, Emacs) will be wired up here.

## Install

Per-editor install scripts live in `scripts/`:

```bash
./scripts/install-vscode.sh
./scripts/install-zed.sh
./scripts/install-helix.sh
./scripts/install-vim.sh
./scripts/install-neovim.sh
./scripts/install-sublime.sh
```

Each script is idempotent and prints what it did. See the per-editor
`README.md` files for manual installation steps and the underlying
mechanism.

## Contributing

The grammar of record for highlighting is the lite-anvil reference
syntax, mirrored as the `tree-sitter-gossamer/` grammar. When adding
tokens, update both:

1. `tree-sitter-gossamer/grammar.js` (and re-run `tree-sitter generate`)
2. `tree-sitter-gossamer/queries/highlights.scm`

then propagate equivalent additions to the per-editor configs that do
not consume tree-sitter (VSCode TextMate grammar, Vim syntax, Emacs
font-lock, Sublime syntax).

## License

Same as upstream Gossamer (Apache-2.0). See `LICENSE`.
