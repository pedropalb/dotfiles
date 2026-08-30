-- Keep Tokyo Night's dark Night variant across system modes.
local function apply_colorscheme()
  vim.api.nvim_set_option_value("background", "dark", {})
  vim.cmd.colorscheme("tokyonight-night")
end

return {
  "f-person/auto-dark-mode.nvim",
  opts = {
    update_interval = 1000,
    set_dark_mode = apply_colorscheme,
    set_light_mode = apply_colorscheme,
  },
}
