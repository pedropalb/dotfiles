local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

config.color_scheme = 'Github Dark'
config.font = wezterm.font 'MesloLGS NF'

return config
