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

Tracks Gossamer 0.12.0: `arena { }` blocks, `let ... else`,
`if let` / `while let`, both closure forms (`|x| body` and
`fn(x) { }`), the format macros plus `vec![...]`, `?` propagation,
`as` casts, turbofish calls (`from_json::<T>(...)`), closure trait
types (`Fn(i64) -> i64`), variant-level attributes (`#[default]`),
and UAX #31 Unicode identifiers. Nested block comments are lexed by
the external scanner in `src/scanner.c` (compile it alongside
`src/parser.c`).

Every example and feature-test file in the Gossamer repository parses
without ERROR nodes; `test/corpus/` locks the tree shapes
(`npx tree-sitter test`). The grammar still favors highlighting over
full fidelity with the upstream `gos` parser, so a malformed program
may produce local ERROR nodes that don't impact highlighting elsewhere
in the file.
