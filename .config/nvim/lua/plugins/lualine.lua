
return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },

    opts = {
        icons_enabled = true,
        theme = "auto",
        --component_separators = { left = "", right = "" },
        --section_separators = { left = "", right = "" },
        disabled_filetypes = { statusline = {}, winbar = {}, },
        ignoer_forcus = {},
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
            refresh_time = 16, -- ~60fps
            events = {
                "WinEnter",
                "BufEnter",
                "BufWritePost",
                "SessionLoadPost",
                "FileChangedShellPost",
                "VimResized",
                "Filetype",
                "CursorMoved",
                "CursorMovedl",
                "ModeChanged",
            },
        },
    },

    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },

    inacive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
    },

    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {},

    config = function(_, opts, sections, inacive_sections)
        require("lualine").setup(opts, sections, inactive_sections)
    end
}
