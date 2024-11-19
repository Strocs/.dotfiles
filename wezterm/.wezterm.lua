local wezterm = require("wezterm")
local mux = wezterm.mux

local config = wezterm.config_builder()
-- Configs
config.window_decorations = "RESIZE"
config.color_scheme = "Sonokai (Gogh)"
config.hide_tab_bar_if_only_one_tab = true
config.font = wezterm.font("CaskaydiaCove NF")
config.font_size = 12.3
config.window_background_opacity = 0.6
config.initial_rows = 48
config.initial_cols = 209
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.default_domain = "WSL:Ubuntu-24.04"

-- Set dedicated GPU for improve performance --
local gpus = wezterm.gui.enumerate_gpus()
config.webgpu_preferred_adapter = gpus[1]
config.front_end = "WebGpu"

-- Keymaps
config.keys = {
	{ key = "n", mods = "SHIFT|CTRL", action = wezterm.action.ToggleFullScreen }, 
	{ key = "o", mods = "SHIFT|CTRL", action = wezterm.action.EmitEvent("toggle-opacity") },
}

-- Actions

-- Toggle opacity
wezterm.on("toggle-opacity", function(window)
	local overrides = window:get_config_overrides() or {}
	if not overrides.window_background_opacity then
		overrides.window_background_opacity = 1
	else
		overrides.window_background_opacity = nil
	end
	window:set_config_overrides(overrides)
end)

-- Windows position on start
wezterm.on("gui-startup", function(cmd)
	mux.spawn_window( cmd or { position = { x = 12, y = 20, origin = "MainScreen" }})
end)

return config




