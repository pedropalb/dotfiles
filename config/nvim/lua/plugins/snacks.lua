return {
  {
    "folke/snacks.nvim",
    enable = true,
    opts = {
      picker = {
        sources = {
          projects = {
            patterns = { "stylua.toml" },
          }
        }
      }
    }
  }
}
