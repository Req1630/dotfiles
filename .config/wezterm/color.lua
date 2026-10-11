

local wezterm = require "wezterm"
local config = {}

config.colors = {
    -- text color
    foreground = "silver",
    -- backgound color
    background = "#000000",

    -- corsor color
    cursor_bg = "#52ad70",
    cursor_fg = "black",
    cursor_border = "#52ad70",

    -- select color
    selection_fg = "black",
    selection_bg = "#fffacd",

    -- scrolbar color
    scrollbar_thumb = "#222222",

    -- split color
    split = "#444444",

    -- tab split
    tab_bar = { inactive_tab_edge = "none" },
}

-- inactive panes
config.inactive_pane_hsb = {
    saturation = 0.1,
    brightness = 0.3,
}

-- background gradation
config.window_background_gradient = {
    orientation = "Vertical",

    colors = {
        "110101",
        "222222",
    }
}

-- tab
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_upper_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_lower_left_triangle

function tab_title(tab_info)
    local title = tab_info.tab_title
    if title and #title > 0 then
        return title
    end
    return tab_info.active_pane.title
end

wezterm.on(
    "format-tab-title",
    function(tab, tabs, panes, config, hover, max_width)
        local background = "#550101"
        local foreground = "#909090"

        if tab.is_active then
            background = "992222"
            foreground = "F0F0F0"
        elseif hover then
            background = "#440000"
            foreground = "#a0a0a0"
        end

        local edge_background = "#110101"
        local edge_foreground = background
        local title = tab_title(tab)

        title = "   " .. wezterm.truncate_right(title, max_width - 2) .. "   "

        return {
            { Background = { Color = edge_background } },
            { Foreground = { Color = edge_foreground } },
            { Text = SOLID_LEFT_ARROW },
            { Background = { Color = background } },
            { Foreground = { Color = foreground } },
            { Text = title },
            { Background = { Color = edge_background } },
            { Foreground = { Color = edge_foreground } },
            { Text = SOLID_RIGHT_ARROW },
        }
    end
)

return config
