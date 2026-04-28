-- Neovim 0.11+ native LSP config for Gossamer.
-- Drop into ~/.config/nvim/lsp/gossamer.lua (the install script does this
-- for you), then enable in your init.lua with:
--
--   vim.lsp.enable("gossamer")
--
-- The Gossamer language server is the `lsp` subcommand of the `gos`
-- CLI. `gos` must be on PATH; if it is missing the client fails to
-- start and tree-sitter highlighting still works.

return {
  cmd = { "gos", "lsp" },
  filetypes = { "gossamer" },
  root_markers = { "project.toml", ".git" },
  settings = {},
}
