local map = vim.keymap.set
local M = {
	build = function()
		local file = vim.fn.stdpath("data")
			.. "/lazy/render-markdown.nvim/lua/render-markdown/render/markdown/quote.lua"
		local content = table.concat(vim.fn.readfile(file), "\n")
		content = content:gsub(
			"virt_text = { { title or config.rendered, config.highlight } }",
			"virt_text = { { title or config%.rendered %.%. %"
				.. "' '"
				.. ', "RenderMarkdownQuoteTitle" } }'
		)
		content = content:gsub(
			"return icon .. ' ' .. title",
			"return icon %.%. ' ' %.%. title %.%. ' '"
		)
		content = content:gsub(
			"virt_text = { { self.data.icon, self.data.highlight } }",
			'virt_text = { { self%.data%.icon, "RenderMarkdownQuoteIcon" } }'
		)
		vim.fn.writefile(vim.split(content, "\n"), file)
	end,
	keys = {
		map("n", "<leader>mt", function()
			require("lazy").load({ plugins = { "render-markdown.nvim" } })
			require("render-markdown").buf_toggle()
		end, { desc = "Toggle Buffer Render Markdown" }),
		map("n", "<leader>mT", function()
			require("lazy").load({ plugins = { "render-markdown.nvim" } })
			require("render-markdown").toggle()
		end, { desc = "Toggle Render Markdown" }),
		map("n", "<leader>mv", function()
			require("lazy").load({ plugins = { "render-markdown.nvim" } })
			require("render-markdown").preview()
		end, { desc = "Preview Render Markdown" }),
	},
	opts = {
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
			highlight = "St_Lint",
		},
		paragraph = {
			enabled = false,
		},
	},
}
return M
