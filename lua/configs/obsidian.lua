-- lua/configs/obsidian.lua
return {
	legacy_commands = false,
	workspaces = {
		{
			name = "Home",
			path = "~/Documents/Obsidian/Home",
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
	-- Inserting tag/outlink is nice,
	-- TODO: Would be nice to insert outlink paragraph as well
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
		date_format = "YYYY-MM-DD",
		time_format = "HH:mm",
		-- substitutions = { for custom values },
	},
	-- TODO:
	-- https://github.com/obsidian-nvim/obsidian.nvim/wiki/Autocmds
	-- Do Autocmds to constantly match scroll with of GUI
	-- or see callbacks = {},
	callbacks = {
		enter_note = function(note)
			vim.keymap.set("n", "<leader>c", "<cmd>Obsidian toggle_checkbox<cr>", {
				buffer = true,
				desc = "Toggle checkbox",
			})
		end,
	},
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
