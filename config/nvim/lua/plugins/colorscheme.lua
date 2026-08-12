-- Use OneDark Vivid from OneDark Pro as the default LazyVim colorscheme.
return {
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000,
    opts = {},
    config = function(_, opts)
      require("onedarkpro").setup(opts)
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark_vivid",
    },
  },
}
