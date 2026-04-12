-- lua/configs/obsidian.lua
local vault = "~/Documents/Obsidian/Home"
local M = {
	keys = {
		{ "<leader>on", ":Obsidian new " }, -- args: title
		{ "<leader>om", ":Obsidian toc<cr>" },
		{ "<leader>og", ":Obsidian tags<cr>" },
		{ "<leader>oo", ":Obsidian open<cr>" },
		{ "<leader>oz", ":Obsidian search<cr>" },
		{ "<leader>or", ":Obsidian rename<cr>" }, -- works updating
		{ "<leader>ot", ":Obsidian template<cr>" },
		{ "<leader>ow", ":Obsidian workspace<cr>" },
		{ "<leader>op", ":Obsidian paste_img<cr>" },
		{ "<leader>ob", ":Obsidian backlinks<cr>" },
		{ "<leader>ou", ":Obsidian unique_note<cr>" },
		{ "<leader>of", ":Obsidian follow_link<cr>" },
		{ "<leader>os", ":Obsidian quick_switch<cr>" },
		{ "<leader>oa", ":Obsidian new_from_template<cr>" },
		-- visual (not block or inline)
		{ "<leader>ox", ":Obsidian extract_note<cr>", mode = "v" },
		{ "<leader>oL", ":Obsidian link_new<cr>", mode = "v" }, -- inline
		{ "<leader>ol", ":Obsidian link<cr>", mode = "v" }, -- inline
		-- workflow
		{ "<leader>od", ":Obsidian dailies<cr>" }, -- list out
		{ "<leader>oy", ":Obsidian today " }, -- args: offset, default is 0
	},
	opts = {
		legacy_commands = false,
		workspaces = {
			{
				name = vim.fn.fnamemodify(vault, ":t"),
				path = vault,
			},
		},
		footer = {
			enabled = true,
			hl_group = "LspCodeLens",
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
			enabled = true,
			sort = false,
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
				dummy = function()
					return "dummy"
				end,
			},
			customizations = (function()
				local result = {}
				local files = vim.fn.glob(vault .. "/Templates/*.md", false, true)
				for _, file in ipairs(files) do
					local name = vim.fn.fnamemodify(file, ":t:r")
					name = name:sub(1, 1):upper() .. name:sub(2)
					local key = name:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", "")
					result[key] = { notes_subdir = "Notes" }
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
				-- TODO: add the [o centering here too
				vim.keymap.del("n", "<CR>", { buffer = true })
				vim.keymap.set("n", "<leader>c", "<cmd>Obsidian toggle_checkbox<cr>", {
					buffer = true,
				})
			end,
		},
		-- matches daily notes core plugin behavior
		daily_notes = {
			enabled = true,
			folder = "Notes",
			template = "daily",
			date_format = "YYYY-MM-DD-dddd",
			alias_format = nil,
			default_tags = { "daily" },
			workdays_only = false,
		},
		unique_note = {
			enabled = false,
		},
	},
}
return M
