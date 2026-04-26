# gossamer-vscode

VSCode language support for [Gossamer](https://github.com/gossamer-lang/gossamer):
syntax highlighting, comment toggling, bracket matching, indentation.

## Install (development)

From this directory:

```bash
# Package as a .vsix
npm install -g @vscode/vsce
vsce package

# Then install the produced .vsix
code --install-extension gossamer-0.1.0.vsix
```

Or symlink the directory into your extensions folder for live editing:

```bash
ln -s "$PWD" ~/.vscode/extensions/gossamer-lang.gossamer-0.1.0
```

Open any `.gos` file to confirm highlighting.

## What it covers

- File extension: `.gos`
- Line and block comments
- Keywords, primitive types, common stdlib types, literals (`true`, `false`,
  `None`, `Some`, `Ok`, `Err`)
- Numeric literals (decimal, hex, binary, octal) with optional type suffix
- String and byte-string literals, raw strings, char literals
- The forward-pipe operator `|>`
- Attributes (`#[...]`, `#![...]`)
- Function-call detection (identifier-before-paren)

## Limitations

This is a TextMate grammar — purely lexical highlighting. There is no LSP
integration yet; `gos` does not ship a language server. When one lands
upstream, it will be wired in here.
