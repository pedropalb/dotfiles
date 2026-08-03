-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Python IDE server: astral's ty (semantic tokens, type checking) instead of
-- pyright, whose semantic tokens are a Pylance-only feature. Ruff stays for
-- lint/format.
vim.g.lazyvim_python_lsp = "ty"
