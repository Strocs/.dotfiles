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

local config = wezterm.config_builder()
-- Configs

-- local sonokai = wezterm.get_builtin_color_schemes()["Sonokai (Gogh)"]
-- sonokai.background = "#412121"

config.front_end = "OpenGL"
config.max_fps = 144
-- config.color_schemes = {
-- 	["Sonokai (Gogh)"] = sonokai,
-- }
config.color_scheme = "Sonokai (Gogh)"

-- Cursor Config
config.default_cursor_style = "BlinkingBlock"
config.animation_fps = 1
config.cursor_blink_rate = 500

-- Font Config
config.font = wezterm.font("CaskaydiaCove NF")
config.font_size = 10.3

-- Window Config
config.window_background_opacity = 0.8
config.initial_rows = 61
config.initial_cols = 236

---- Windows position on start
wezterm.on("gui-startup", function(cmd)
	mux.spawn_window(cmd or { position = { x = 8, y = 14 } })
end)

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- Windows Manager Config
config.window_decorations = "NONE | RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

-- TODO: detect default wsl distro and set it here
config.default_domain = "WSL:Ubuntu"

-- Keymaps
config.leader = { key = "a", mods = "CTRL" }
config.keys = {
	{ key = "n", mods = "SHIFT|CTRL", action = wezterm.action.ToggleFullScreen },
	{ key = "o", mods = "SHIFT|CTRL", action = wezterm.action.EmitEvent("toggle-opacity") },
	{ key = "1", mods = "LEADER", action = wezterm.action({ ActivateTab = 0 }) },
	{ key = "2", mods = "LEADER", action = wezterm.action({ ActivateTab = 1 }) },
	{ key = "3", mods = "LEADER", action = wezterm.action({ ActivateTab = 2 }) },
	{ key = "4", mods = "LEADER", action = wezterm.action({ ActivateTab = 3 }) },
	{ key = "5", mods = "LEADER", action = wezterm.action({ ActivateTab = 4 }) },
	{ key = "6", mods = "LEADER", action = wezterm.action({ ActivateTab = 5 }) },
	{ key = "7", mods = "LEADER", action = wezterm.action({ ActivateTab = 6 }) },
	{ key = "8", mods = "LEADER", action = wezterm.action({ ActivateTab = 7 }) },
	{ key = "9", mods = "LEADER", action = wezterm.action({ ActivateTab = 8 }) },
	{ key = "c", mods = "LEADER", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
	{ key = "x", mods = "LEADER", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },
	{ key = "s", mods = "LEADER", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	{ key = "v", mods = "LEADER", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
	{ key = "[", mods = "LEADER", action = wezterm.action.ActivateCopyMode },
}

return config
