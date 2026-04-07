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
		-- find better look
		format = "{{backlinks}} backlinks {{outlinks}} outlinks {{words}} words {{chars}} chars",
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
	-- TODO:
	-- https://github.com/obsidian-nvim/obsidian.nvim/wiki/Autocmds
	-- Do Autocmds to constantly match scroll with of GUI
	-- or see callbacks = {},
	callbacks = {
		enter_note = function(note)
			vim.keymap.set("n", "<leader>ch", "<cmd>Obsidian toggle_checkbox<cr>", {
				buffer = true,
				desc = "Toggle checkbox",
			})
		end,
	},
	checkbox = {
		enabled = true,
		create_new = true,
		order = { " ", "x" },
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
	frontmatter = {
		enabled = false, -- ERRORs IDK
		-- func = require("obsidian.builtin").frontmatter,
		-- sort = { "id", "aliases", "tags" },
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
	ui = {
		enable = false,
	},
	------@class obsidian.config.NoteOpts
	------
	------Default template to use, relative to template.folder or an absolute path.
	------
	------@field template string|?
	---note = {
	---	template = (function()
	---		local root = vim.iter(vim.api.nvim_list_runtime_paths()):find(function(path)
	---			return vim.endswith(path, "obsidian.nvim")
	---		end)
	---		if not root then
	---			return nil
	---		end
	---		return vim.fs.joinpath(root, "data/default_template.md")
	---	end)(),
	---},
	-- templates = {
	-- 	enabled = true,
	-- 	folder = "Templates",
	-- 	date_format = "YYYY-MM-DD",
	-- 	time_format = "HH:mm",
	-- 	substitutions = {
	-- 		date = function(_, suffix)
	-- 			local format = suffix or Obsidian.opts.templates.date_format
	-- 			return require("obsidian.util").format_date(os.time(), format)
	-- 		end,
	-- 		time = function(_, suffix)
	-- 			local format = suffix or Obsidian.opts.templates.time_format
	-- 			return require("obsidian.util").format_date(os.time(), format)
	-- 		end,
	-- 		title = function(ctx)
	-- 			return ctx.partial_note and ctx.partial_note:display_name()
	-- 		end,
	-- 		id = function(ctx)
	-- 			return ctx.partial_note and ctx.partial_note.id
	-- 		end,
	-- 		path = function(ctx)
	-- 			return ctx.partial_note and tostring(ctx.partial_note.path)
	-- 		end,
	-- 	},
	-- },
}
