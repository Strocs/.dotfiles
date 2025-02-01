local wezterm = require("wezterm")
local mux = wezterm.mux

-- Actions
---- Toggle opacity
wezterm.on("toggle-opacity", function(window)
	local overrides = window:get_config_overrides() or {}
	if not overrides.window_background_opacity then
		overrides.window_background_opacity = 1
	else
		overrides.window_background_opacity = nil
	end
	window:set_config_overrides(overrides)
end)

---- Windows position on start
wezterm.on("gui-startup", function(cmd)
	mux.spawn_window(cmd or { position = { x = 8, y = 14, origin = "MainScreen" } })
end)

local config = wezterm.config_builder()
-- Configs

-- local sonokai = wezterm.get_builtin_color_schemes()["Sonokai (Gogh)"]
-- sonokai.background = "#412121"

config.window_decorations = "RESIZE"
-- config.color_schemes = {
-- 	["Sonokai (Gogh)"] = sonokai,
-- }
config.color_scheme = "Sonokai (Gogh)"
config.hide_tab_bar_if_only_one_tab = true
config.font = wezterm.font("CaskaydiaCove NF")
config.font_size = 12.3
config.window_background_opacity = 0.6
config.initial_rows = 49
config.initial_cols = 210
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.front_end = "OpenGL"

-- TODO: detect default wsl distro and set it here
config.default_domain = "WSL:Ubuntu-24.04"

-- Keymaps
config.keys = {
	{ key = "n", mods = "SHIFT|CTRL", action = wezterm.action.ToggleFullScreen },
	{ key = "o", mods = "SHIFT|CTRL", action = wezterm.action.EmitEvent("toggle-opacity") },
}

return config
