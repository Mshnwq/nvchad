-- lua/configs/obsidian.lua
local vault = "~/Documents/Obsidian/Home"
return {
	legacy_commands = false,
	workspaces = {
		{
			name = vim.fn.fnamemodify(vault, ":t"),
			path = vault,
		},
	},
	footer = {
		enabled = true,
		hl_group = "St_Lint",
		format = "{{backlinks}} <- | {{words}} words {{chars}} chars | -> {{outlinks}}",
	},
	open = {
		use_advanced_uri = true,
		func = vim.ui.open,
		schemes = { "https", "http", "file", "mailto" },
	},
	attachments = {
		folder = "Assets",
		confirm_img_paste = false,
	},
	checkbox = {
		enabled = true,
		create_new = true,
		order = { " ", "x" },
	},
	frontmatter = {
		enabled = false, -- ERRORs IDK
	},
	ui = {
		enable = false,
	},
	picker = {
		name = nil,
		note_mappings = {
			new = "<C-n>",
			insert_link = "<C-l>",
		},
		tag_mappings = {
			tag_note = "<C-n>",
			insert_tag = "<C-l>",
		},
	},
	note_id_func = function(title)
		if title ~= nil then
			return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
		end
		return nil
	end,
	note = {
		template = "default.md",
	},
	templates = {
		folder = "Templates",
		substitutions = {
			date = function()
				return os.date("%Y-%m-%d-%A")
			end,
			time = function()
				local h = tonumber(os.date("%H"))
				local m = os.date("%M")
				local ampm = h >= 12 and "pm" or "am"
				h = h % 12
				if h == 0 then
					h = 12
				end
				return string.format("%d:%s%s", h, m, ampm)
			end,
		},
		customizations = (function()
			local result = {}
			local files = vim.fn.glob(vault .. "/Templates/*.md", false, true)
			for _, file in ipairs(files) do
				local name = vim.fn.fnamemodify(file, ":t:r")
				name = name:sub(1, 1):upper() .. name:sub(2)
				local key = name:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", "")
				result[key] = { notes_subdir = name }
			end
			return result
		end)(),
	},
	-- TODO:
	-- https://github.com/obsidian-nvim/obsidian.nvim/wiki/Autocmds
	-- Do Autocmds to constantly match scroll with of GUI
	-- or see callbacks = {},
	callbacks = {
		enter_note = function()
			vim.keymap.set("n", "<leader>c", "<cmd>Obsidian toggle_checkbox<cr>", {
				buffer = true,
			})
		end,
	},
	-- TODO:
	daily_notes = {
		enabled = false,
		folder = nil,
		date_format = "YYYY-MM-DD",
		alias_format = nil,
		default_tags = { "daily-notes" },
		workdays_only = true,
	},
	unique_note = {
		enabled = false,
		format = "YYYYMMDDHHmm",
		folder = nil,
		template = nil,
	},
}
