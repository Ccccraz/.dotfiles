local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "Tokyo Night (Gogh)"
config.default_prog = { "pwsh.exe", "-l" }

config.font = wezterm.font_with_fallback({
	"Cascadia Code PL",
	"等距更纱黑体 SC"
})

return config
