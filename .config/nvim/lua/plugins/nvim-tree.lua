
return {
	"nvim-tree/nvim-tree.lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },

	opts = {
		view = {
			width = 30,
			centralize_selection = true,
		},
		update_focused_file = {
			enable = true,
		},
		renderer = { 
			group_empty = true,
		},
		filters = {
			dotfiles = false,
			git_ignored = false,
		},
	},
	config = function(_, opts)
		require("nvim-tree").setup(opts)
	end
}
