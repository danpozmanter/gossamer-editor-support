# Gossamer for Sublime Text

Drop the contents of this directory into your Sublime Text `Packages/`
directory under a `Gossamer/` folder:

```bash
# Linux
cp -r . "$HOME/.config/sublime-text/Packages/Gossamer"

# macOS
cp -r . "$HOME/Library/Application Support/Sublime Text/Packages/Gossamer"
```

`.gos` files will pick up the `Gossamer.sublime-syntax` highlighter
automatically. `Gossamer.sublime-settings` sets sensible defaults
(4-space indent, trim trailing whitespace, newline at EOF).

## LSP

The install script (`scripts/install-sublime.sh`) merges
`LSP-gossamer.sublime-settings` into
`Packages/User/LSP.sublime-settings` so the Sublime LSP package
launches `gos lsp` for `.gos` buffers. Install the **LSP** package
via Package Control to activate it. If `gos` is not on `PATH`, the
client is inactive and syntax highlighting still works.
