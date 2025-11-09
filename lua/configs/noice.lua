require("noice").setup({
	presets = {
		long_message_to_split = true,
		lsp_doc_border = true,
	},
	cmdline = {
		format = {
			shell = {
				pattern = "^:%s*!",
				icon = "󰘧",
				lang = "bash",
			},
		},
	},
	views = {
		cmdline_popup = {
			position = {
				row = "90%",
				col = "50%",
			},
			size = {
				width = "25%",
				height = "auto",
			},
		},
		popupmenu = {
			relative = "editor",
			anchor = "NE",
			position = {
				row = "90%",
				col = "37.5%",
			},
			size = {
				width = "auto",
				height = "auto",
			},
			border = {
				style = "rounded",
			},
			win_options = {
				winhighlight = {
					Normal = "Normal",
					FloatBorder = "DiagnosticInfo",
				},
			},
		},
	},
	routes = {
		{
			filter = {
				event = "msg_show",
				any = {
					-- filters rename messages
					-- { find = '%-+>' },
					-- filters save messages
					{ find = "%d+L, %d+B" },
					{ find = "; after #%d+" },
					{ find = "; before #%d+" },
					{ find = "%d fewer lines" },
					{ find = "%d more lines" },
				},
			},
			opts = { skip = true },
		},
	},
})
