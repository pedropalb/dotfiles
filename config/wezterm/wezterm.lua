local wezterm = require("wezterm")
local config = wezterm.config_builder()

local light_scheme = "tokyonight-day"
local dark_scheme = "Default"

-- Helper to select a scheme based on appearance string
local function scheme_for_appearance(appearance)
  if appearance:find("Dark") then
    return dark_scheme
  else
    return light_scheme
  end
end

-- 1. Initial Sync with OS appearance
local initial_appearance = wezterm.gui.get_appearance()
config.color_scheme = scheme_for_appearance(initial_appearance)
wezterm.GLOBAL.last_appearance = initial_appearance

-- 2. Live Update on OS Appearance Change
wezterm.on("window-config-reloaded", function(window, _)
  local appearance = window:get_appearance()

  if wezterm.GLOBAL.last_appearance == nil then
    wezterm.GLOBAL.last_appearance = appearance
  end

  -- Only update if the OS appearance has ACTUALLY changed.
  -- This prevents overwriting manual toggles and ignores stale events.
  if appearance ~= wezterm.GLOBAL.last_appearance then
    wezterm.GLOBAL.last_appearance = appearance

    local overrides = window:get_config_overrides() or {}
    overrides.color_scheme = scheme_for_appearance(appearance)
    window:set_config_overrides(overrides)
  end
end)

-- 3. Toggle via shortcut
wezterm.on("toggle-color-scheme", function(window, _)
  local overrides = window:get_config_overrides() or {}
  local current_scheme = overrides.color_scheme or window:effective_config().color_scheme

  if current_scheme == light_scheme then
    overrides.color_scheme = dark_scheme
  else
    overrides.color_scheme = light_scheme
  end

  window:set_config_overrides(overrides)
end)

config.keys = {
  {
    key = "T",
    mods = "ALT|SHIFT",
    action = wezterm.action.EmitEvent("toggle-color-scheme"),
  },
}

return config
