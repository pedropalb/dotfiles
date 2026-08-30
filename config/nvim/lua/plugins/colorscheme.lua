-- Use OneDark Dark (onedarkpro.nvim) as the default LazyVim colorscheme.
return {
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000,
    opts = {
      highlights = {
        ["@variable"] = { fg = "${fg}" },
        ["@variable.builtin"] = { fg = "${yellow}" },
        ["@variable.parameter"] = { fg = "${fg}" },
        ["@variable.member"] = { fg = "${fg}" },
        ["@property"] = { fg = "${fg}" },
        ["@field"] = { fg = "${fg}" },
        Identifier = { fg = "${fg}" },

        -- Parameters
        ["@parameter"] = { fg = "${fg}" },
        ["@parameter.typescript"] = { fg = "${fg}" },
        ["@parameter.tsx"] = { fg = "${fg}" },
        ["@parameter.go"] = { fg = "${fg}" },

        -- Language-specific variables and fields
        ["@variable.rust"] = { fg = "${fg}" },
        ["@field.rust"] = { fg = "${fg}" },
        ["@variable.typescript"] = { fg = "${fg}" },
        ["@variable.javascript"] = { fg = "${fg}" },
        ["@variable.go"] = { fg = "${fg}" },
        ["@field.go"] = { fg = "${fg}" },
        ["@property.go"] = { fg = "${fg}" },

        -- Structured formats & markup
        ["@label.json"] = { fg = "${cyan}" },
        ["@field.yaml"] = { fg = "${cyan}" },
        ["@markup.heading"] = { fg = "${blue}", bold = true },
        ["@text.title.markdown"] = { fg = "${blue}", bold = true },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark_dark",
    },
  },
}
