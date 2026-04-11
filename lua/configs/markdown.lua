return {
	anti_conceal = {
		enabled = false,
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
	quote = {
		-- TODO: make it look like markview
		enabled = true,
		-- Whether to repeat icon on wrapped lines. Requires neovim >= 0.10. This will obscure text
		-- if incorrectly configured with :h 'showbreak', :h 'breakindent' and :h 'breakindentopt'.
		-- A combination of these that is likely to work follows.
		-- | showbreak      | '  ' (2 spaces)   |
		-- | breakindent    | true              |
		-- | breakindentopt | '' (empty string) |
		-- These are not validated by this plugin. If you want to avoid adding these to your main
		-- configuration then set them in win_options for this plugin.
		repeat_linebreak = false,
	},
}
