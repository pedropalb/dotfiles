-- OneDark Vivid is dark-only, so keep the background dark in every system mode.
local function apply_colorscheme()
  vim.api.nvim_set_option_value("background", "dark", {})
  vim.cmd.colorscheme("onedark_vivid")
end

return {
  "f-person/auto-dark-mode.nvim",
  opts = {
    update_interval = 1000,
    set_dark_mode = apply_colorscheme,
    set_light_mode = apply_colorscheme,
  },
}
