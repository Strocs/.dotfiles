-- wezterm.lua

local wezterm = require("wezterm")
local mux = wezterm.mux

-- 1. Basic Config
local config = wezterm.config_builder()
config.front_end = "WebGpu"
config.max_fps = 120
config.enable_scroll_bar = false

-- 2. Cursor
config.default_cursor_style = "BlinkingBlock"
config.animation_fps = 1
config.cursor_blink_rate = 500

-- 3. Font
config.font = wezterm.font("FiraCode Nerd Font")
config.font_size = 11

-- 4. Colors & Theme
local theme = "tokyonight_moon"
local scheme = wezterm.color.get_builtin_schemes()[theme]
config.color_scheme = theme
config.color_schemes = { [theme] = scheme }
config.window_background_opacity = 1

-- 5. Window
config.initial_rows = 53
config.initial_cols = 210
config.window_padding = { left = 3, right = 0, top = 0, bottom = 0 }
local border_color = scheme.ansi[8]
local border_width = 2
config.window_frame = {
	border_left_width = border_width,
	border_right_width = border_width,
	border_top_height = border_width,
	border_bottom_height = border_width,
	border_left_color = border_color,
	border_right_color = border_color,
	border_top_color = border_color,
	border_bottom_color = border_color,
}
config.window_decorations = "NONE"
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.enable_kitty_graphics = true

-- 6. Domain/Startup
config.default_domain = "WSL:Ubuntu"

-- 7. Events
wezterm.on("toggle-opacity", function(window)
	local overrides = window:get_config_overrides() or {}
	if not overrides.window_background_opacity then
		overrides.window_background_opacity = 0.9
	else
		overrides.window_background_opacity = nil
	end
	window:set_config_overrides(overrides)
end)

wezterm.on("gui-startup", function(cmd)
	mux.spawn_window(cmd or { position = { x = 14, y = 10 } })
end)

wezterm.on("window-focus-changed", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	local new_color = window:is_focused() and border_color or "#666666"
	local frame = overrides.window_frame or config.window_frame or {}

	frame.border_left_color = new_color
	frame.border_right_color = new_color
	frame.border_top_color = new_color
	frame.border_bottom_color = new_color

	overrides.window_frame = frame
	window:set_config_overrides(overrides)
end)

-- 8. Keymaps
config.disable_default_key_bindings = true
config.leader = { key = "b", mods = "CTRL" }
config.keys = {
	{ key = "n", mods = "LEADER", action = wezterm.action.ToggleFullScreen },
	{ key = "o", mods = "LEADER", action = wezterm.action.EmitEvent("toggle-opacity") },
	{
		key = "w",
		mods = "LEADER",
		action = wezterm.action.SpawnCommandInNewTab({ args = { "pwsh.exe" }, domain = { DomainName = "local" } }),
	},
	{
		key = "n",
		mods = "LEADER",
		action = wezterm.action.SpawnCommandInNewTab({ args = { "wsl.exe" }, domain = { DomainName = "local" } }),
	},
	{ key = "x", mods = "LEADER", action = wezterm.action.CloseCurrentPane({ confirm = false }) },
	{ key = "[", mods = "LEADER", action = wezterm.action.ActivateCopyMode },
	{ key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
	{ key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },
	{ key = "Tab", mods = "CTRL", action = wezterm.action.ActivateTabRelative(1) },
}

return config
