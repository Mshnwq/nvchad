return {
	"Isrothy/neominimap.nvim",
	version = "v3.*.*",
	enabled = true,
	lazy = false, -- NOTE: NO NEED to Lazy load
	keys = {
		{ "<leader>mm", "<cmd>Neominimap Toggle<cr>", desc = "Toggle global minimap" },
	},
	init = function()
		vim.opt.wrap = true
		vim.opt.sidescrolloff = 16
		vim.g.neominimap = {
			auto_enable = false,
			layout = "split",
			split = {
				minimap_width = 15,
				fix_width = false,
				direction = "right",
				close_if_last_window = false,
			},
			click = {
				enabled = true,
				auto_switch_focus = false,
			},
			fold = {
				enabled = true,
			},
		}
	end,
}
