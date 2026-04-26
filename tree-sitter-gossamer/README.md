# tree-sitter-gossamer

A [tree-sitter](https://tree-sitter.github.io/) grammar for the Gossamer
programming language.

## Build

```bash
npm install
npx tree-sitter generate
npx tree-sitter build
```

To smoke-test against a `.gos` source:

```bash
npx tree-sitter parse path/to/file.gos
```

## Editor wiring

- **Neovim** via `nvim-treesitter`: see `../neovim/`.
- **Helix**: see `../helix/`.
- **Zed**: see `../zed/`.
- Any other tree-sitter consumer: register `scope = "source.gossamer"`,
  file types `["gos"]`, and point the highlights query at
  `queries/highlights.scm`.

## Status

Lexically complete; parser is "good enough" for highlighting and
folding. It does not yet aim for full grammatical fidelity with the
upstream `gos` parser, so a malformed program may produce ERROR nodes
that don't impact highlighting elsewhere in the file.
