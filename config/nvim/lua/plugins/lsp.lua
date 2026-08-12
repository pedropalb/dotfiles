return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = { virtual_text = false },
      servers = {
        -- The lang.nix extra defaults to nil_ls; nixd is installed via Nix instead.
        nil_ls = { enabled = false },
        nixd = {},
      },
    },
  },
}
