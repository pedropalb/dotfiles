-- Use Tokyo Night's dark Night variant with a charcoal and stone palette.
return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = {
      style = "night",
      on_colors = function(c)
        local util = require("tokyonight.util")

        -- Dark charcoal and basalt surfaces (no warm/yellow tint).
        c.bg = "#161617"
        c.bg_dark = "#121213"
        c.bg_dark1 = "#0d0d0e"
        c.bg_highlight = "#1f2022"
        c.bg_visual = "#2a2b2f"
        c.bg_search = "#383a40"
        c.black = "#0b0b0c"
        c.border = c.black
        c.border_highlight = "#35363a"

        -- Clean silver stone neutrals (neutral slate/ash, zero khaki/sand).
        c.fg = "#c8c9ce"
        c.fg_dark = "#9ea0a6"
        c.fg_gutter = "#424347"
        c.comment = "#6b6d76"
        c.dark3 = "#4a4b52"
        c.dark5 = "#5e6068"
        c.terminal_black = "#393a40"

        -- Vivid syntax accents (functions, types, classes) on dark stone.
        c.blue = "#7aa2f7"
        c.blue0 = "#2a2c34"
        c.blue1 = "#2ac3de"
        c.blue2 = "#0db9d7"
        c.blue5 = "#8a8c96"
        c.blue7 = "#32353e"
        c.cyan = "#7dcfff"
        c.magenta = "#bb9af7"
        -- Keep purple as the keyword accent; treesitter uses it directly.

        -- These values are derived before on_colors runs, so refresh them
        -- against the new palette instead of retaining the old blue values.
        c.bg_popup = c.bg_dark
        c.bg_statusline = c.bg_dark
        c.bg_sidebar = c.bg_dark
        c.bg_float = c.bg_dark
        c.fg_sidebar = c.fg_dark
        c.fg_float = c.fg
        c.diff = {
          add = util.blend_bg(c.green2, 0.25, c.bg),
          delete = util.blend_bg(c.red1, 0.25, c.bg),
          change = util.blend_bg(c.blue7, 0.15, c.bg),
          text = c.blue7,
        }
        c.git.ignore = c.dark3
        c.git.change = "#bfa070"
        c.todo = c.blue
        c.info = c.blue2
        c.rainbow = {
          c.blue,
          c.yellow,
          c.green,
          c.teal,
          c.magenta,
          c.purple,
          c.orange,
          c.red,
        }
        c.terminal = {
          black = c.black,
          black_bright = c.terminal_black,
          red = c.red,
          red_bright = util.brighten(c.red),
          green = c.green,
          green_bright = util.brighten(c.green),
          yellow = c.yellow,
          yellow_bright = util.brighten(c.yellow),
          blue = c.blue,
          blue_bright = util.brighten(c.blue),
          magenta = c.magenta,
          magenta_bright = util.brighten(c.magenta),
          cyan = c.cyan,
          cyan_bright = util.brighten(c.cyan),
          white = c.fg_dark,
          white_bright = c.fg,
        }
      end,
      on_highlights = function(hl, c)
        -- Keep built-in types (int, str, bool, list, dict, None) as vivid as custom types
        hl["@type.builtin"] = { fg = c.blue1 }
        -- In Python, class constructor calls (e.g. MyClass()) match the class type color
        hl["@constructor.python"] = { fg = c.blue1 }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
  },
}
