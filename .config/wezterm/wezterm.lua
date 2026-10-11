
function merge_config(config, new_config)
    for k, v in pairs(new_config) do
        config[k] = v
    end
end

local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.default_cwd = "C:/Program Files/WezTerm"
config.default_prog = {
	"powershell.exe",
	"-NoLogo"
}
config.automatically_reload_config = true
config.font_size = 11.0
config.use_ime = true
config.window_decorations = "RESIZE"
config.window_frame = {
    inactive_titlebar_bg = "none",
    active_titlebar_bg = "none",
}
config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false

-- colors config
local color_config = require("color")
merge_config(config, color_config)

-- key config
local key_config = require("keybinds")
merge_config(config, key_config)

-- UE Project Setting.
require("ue_setting.ue_setting")

-- and finally, return the configuration to wezterm
return config
