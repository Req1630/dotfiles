-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
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

-- This is where you actually apply your config choices

-- For example, changing the color scheme:

config.window_frame = {
    inactive_titlebar_bg = "none",
    active_titlebar_bg = "none",
}

local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle
config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false
config.colors = {
    tab_bar = {
        inactive_tab_edge = "none",
    },
}

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local background = "#5c6d74"
    local foreground = "#FFFFFF"
    local edge_background = "none"
    if tab.is_active then
        background = "#640244"
        foreground = "#FFFFFF"
    end

    local edge_foreground = background
    local tab_title = tab.tab_title
    if not tab_title or tab_title == "" then
	    tab_title = tab.active_pane.title
    end
    local title = "   " .. wezterm.truncate_right(tab_title, max_width) .. "   "

    return {
        { Background = { Color = edge_background } },
        { Foreground = { Color = edge_foreground } },
        { Text = SOLID_LEFT_ARROW },
        { Background = { Color = background } },
        { Foreground = { Color = foreground } },
        { Text = title },
        { Background = { Color = edge_background } },
        { Foreground = { Color = edge_foreground } },
        { Text = SOLID_RIGHT_ARROW }
    }
end)

config.disable_default_key_bindings = true
config.keys = require("keybinds").keys
config.key_tables = require("keybinds").key_tables


-- //////////////////////////////
--	UE Project Setting.
-- //////////////////////////////
local fg_project = require "ue_projects.FG"

local projects = {
	fg_project,
}

local function open_ue_project(window, pane, project)
	local root = project.root
	local tab, command_pane, window = window:mux_window():spawn_tab{
		cwd = root,
		args = {
			"powershell.exe",
			"-NoExit",
			"-Command",
			"Set-Location '" .. root .."';",
			[[
Write-Host @"
 ██████╗ ██████╗ ███╗   ███╗███╗   ███╗ █████╗ ███╗   ██╗██████╗
██╔════╝██╔═══██╗████╗ ████║████╗ ████║██╔══██╗████╗  ██║██╔══██╗
██║     ██║   ██║██╔████╔██║██╔████╔██║███████║██╔██╗ ██║██║  ██║
██║     ██║   ██║██║╚██╔╝██║██║╚██╔╝██║██╔══██║██║╚██╗██║██║  ██║
╚██████╗╚██████╔╝██║ ╚═╝ ██║██║ ╚═╝ ██║██║  ██║██║ ╚████║██████╔╝
 ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝
"@
]],
		}
	}
	--command_pane:set_title("Command")

	local git_pane = command_pane:split{
		direction = "Right",
		size = 0.5,
		cwd = root,
		args = {
			"powershell.exe",
			"-NoExit",
			"-Command",
			"Set-Location '" .. root .."';",
			[[
Write-Host @"
 ██████╗ ██╗████████╗
██╔════╝ ██║╚══██╔══╝
██║  ███╗██║   ██║
██║   ██║██║   ██║
╚██████╔╝██║   ██║
 ╚═════╝ ╚═╝   ╚═╝
"@
]],
		}
		
	}
	--git_pane:set_title("Git")

	local build_pane = command_pane:split{
		direction = "Bottom",
		size = 0.5,
		cwd = root,
		args = {
			"powershell.exe",
			"-NoExit",
			"-Command",
			"Set-Location '" .. root .."';",
			[[
Write-Host @"
██████╗ ██╗   ██╗██╗██╗     ██████╗
██╔══██╗██║   ██║██║██║     ██╔══██╗
██████╔╝██║   ██║██║██║     ██║  ██║
██╔══██╗██║   ██║██║██║     ██║  ██║
██████╔╝╚██████╔╝██║███████╗██████╔╝
╚═════╝  ╚═════╝ ╚═╝╚══════╝╚═════╝
"@
]],
		}		
	}
	--build_pane:set_title("Build")

	local log_pane = git_pane:split{
		direction = "Bottom",
		size = 0.5,
		cwd = project.log,
		args = {
			"powershell.exe",
			"-NoExit",
			"-Command",
			"Set-Location '" .. project.log .."';",
			[[
Write-Host @"
██╗      ██████╗  ██████╗
██║     ██╔═══██╗██╔════╝
██║     ██║   ██║██║  ███╗
██║     ██║   ██║██║   ██║
███████╗╚██████╔╝╚██████╔╝
╚══════╝ ╚═════╝  ╚═════╝
"@
]],
		}
		
	}
	--log_pane:set_title("Log")

	tab:set_title("UE - " .. project.name)
end


wezterm.on("augment-command-palette", function(window, pane)
	return {
		{
			brief = "Open UE Project",
			doc = "Select an Unreal Engine Project",
			action = wezterm.action_callback(function(window, pane)
				local choices = {}
				for _, project in ipairs(projects) do
					table.insert(
						choices,
						{
							label = project.name,
							id = project.name,
						}
					)
				end

				window:perform_action(
					wezterm.action.InputSelector {
						title = "Select UE Project",
						choices = choices,
						fuzzy = true,
						action = wezterm.action_callback(function(window, pane, id, label)
							if not id then
								return
							end

							for _, project in ipairs(projects) do
								if project.name == id then
									open_ue_project(
										window,
										pane,
										project
									)
									return
								end
							end
						end),
					},
					pane
				)
			end),
		}
	}
end)

-- and finally, return the configuration to wezterm
return config
