return {
	anti_conceal = {
		enabled = true,
	},
	checkbox = {
		position = "inline",
		left_pad = 3,
		unchecked = {
			icon = "󰄱 ",
		},
		checked = {
			icon = "󰱒 ",
			scope_highlight = "CheckBoxed",
		},
	},
	heading = {
		sign = false,
		-- width = "block",
		width = { "full", "block", "block", "block", "block", "block" },
		icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
		position = "inline",
		-- position = "eol",
		left_pad = 1,
		right_pad = 1,
		border = true,
		border_virtual = false,
		-- above = "─",
		-- below = " ",
		backgrounds = {
			"HeadlineBg",
		},
		foregrounds = {
			"HeadlineFg",
		},
	},
	code = {
		language = true,
		sign = false,
		position = "right",
		conceal_delimiters = true,
		border = "thin",
		language_name = true,
		language_border = "▀",
		above = "▀",
		below = "▄",
		language_left = "█",
		language_right = "█",
		width = "block",
		left_pad = 0,
		right_pad = 1,
		inline_pad = 1,
		disable_background = true,
		highlight_language = "HeadlineFg",
	},
	link = {
		wiki = {
			icon = "󰥧 ",
		},
		custom = {
			mailto = { pattern = "^mailto", icon = " " },
			asset = { pattern = "^Pasted", icon = "󰥶 " },
		},
	},
	pipe_table = {
		preset = "round",
		-- breaks when open file tree
		cell = "trimmed",
		-- cell = "overlay",
		head = "RenderMarkdownTable",
	},
	bullet = {
		left_pad = 0,
		icons = { "", "", "", "" },
		highlight = "HeadlineFg",
	},
	paragraph = {
		enabled = false,
	},
}
