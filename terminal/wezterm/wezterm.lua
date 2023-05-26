local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = 'Tokyo Night (Gogh)'
config.default_prog = { "C:/Program Files/nu/bin/nu.exe", "-l" }

config.font = wezterm.font_with_fallback {
	"Cascadia Code",
	"CaskaydiaCove Nerd Font Mono",
}

return config
