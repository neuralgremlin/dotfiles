local wezterm = require 'wezterm'
local config = wezterm.config_builder()
config = {
    automatically_reload_config = true,
    window_decorations = "INTEGRATED_BUTTONS|RESIZE",
    color_scheme = 'Catppuccin Mocha',
    enable_tab_bar = false,
    font = wezterm.font 'JetBrains Mono',
    font_size = 16,
    macos_window_background_blur = 20,
    window_background_opacity = 0.8,
}
return config
