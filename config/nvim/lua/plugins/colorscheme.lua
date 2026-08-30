local theme = require("config.theme")

-- Use Tokyo Night's dark Night variant with a charcoal and stone palette.
return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = {
      style = "night",
      on_colors = theme.custom_on_colors,
      on_highlights = theme.custom_on_highlights,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
  },
}
