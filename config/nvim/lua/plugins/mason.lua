return {
  -- Disable tool auto-installation for general tools (formatters/linters)
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = {}
    end,
  },
  -- Disable Mason for all LSP servers configured via LazyVim extras
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      for server, server_opts in pairs(opts.servers or {}) do
        if server_opts == true then
          opts.servers[server] = { mason = false }
        elseif type(server_opts) == "table" then
          server_opts.mason = false
        end
      end
    end,
  },
  -- Disable auto-installation for LSP servers in mason-lspconfig
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {},
      automatic_installation = false,
    },
  },
  -- Disable auto-installation for Debuggers (DAP)
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = {},
      automatic_installation = false,
    },
  },
}

