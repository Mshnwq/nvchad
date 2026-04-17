-- lua/configs/obsidian.lua
local vault = "~/Documents/Obsidian/Home"
local inbox = "0_Inbox"
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
			format = "{{backlinks}} <- | links | -> {{outlinks}}",
		},
		open = {
			use_advanced_uri = true,
			-- BUG: when toggling on same line,
			-- it returns to last previous line uri command
			func = function(uri)
				vim.ui.open(uri)
				if uri:find("advanced%-uri") and uri:find("line=") then
					local line = tonumber(uri:match("line=(%d+)"))
					if line then
						local encoded_vault = uri:match("vault=([^&]+)")
						local encoded_path = uri:match("filepath=([^&]+)")
						local uri_toggle = ("obsidian://advanced-uri?vault=%s&filepath=%s&line=%i&commandid=markdown%%3Atoggle-preview"):format(
							encoded_vault,
							encoded_path,
							line - 1
						)
						vim.defer_fn(function()
							vim.ui.open(uri_toggle)
						end, 100)
					end
				end
			end,
		},
		callbacks = {
			-- pre_write_note = function()
			-- 	vim.cmd("Obsidian open")
			-- end,
			enter_note = function()
				vim.keymap.del("n", "<CR>", { buffer = true })
				vim.keymap.del("n", "]o", { buffer = true })
				vim.keymap.del("n", "[o", { buffer = true })
				vim.keymap.set("n", "]o", function()
					require("obsidian.api").nav_link("next")
					vim.cmd("normal! zz")
				end, { buffer = true, desc = "Obsidian Next Link" })
				vim.keymap.set("n", "[o", function()
					require("obsidian.api").nav_link("prev")
					vim.cmd("normal! zz")
				end, { buffer = true, desc = "Obsidian Prev Link" })
				vim.keymap.set("n", "<leader>c", "<cmd>Obsidian toggle_checkbox<cr>", {
					buffer = true,
				})
			end,
		},
		attachments = {
			folder = "_attachments",
			confirm_img_paste = false,
		},
		checkbox = {
			enabled = true,
			create_new = true,
			order = { " ", "x" },
		},
		frontmatter = {
			enabled = true,
			sort = { "date", "time", "id", "aliases", "tags", "topics" },
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
		unique_note = {
			enabled = false,
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
		-- TODO: eventually move to luasnip
		templates = {
			folder = "_templates",
			substitutions = {
				dummy = function()
					return "dummy"
				end,
			},
			customizations = (function()
				local result = {}
				local files = vim.fn.glob(vault .. "/.templates/*.md", false, true)
				for _, file in ipairs(files) do
					local name = vim.fn.fnamemodify(file, ":t:r")
					name = name:sub(1, 1):upper() .. name:sub(2)
					local key = name:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", "")
					result[key] = { notes_subdir = inbox }
				end
				return result
			end)(),
		},
		-- matches daily notes core plugin behavior
		daily_notes = {
			enabled = true,
			folder = inbox,
			template = "daily",
			date_format = "YYYY-MM-DD-dddd",
			alias_format = nil,
			default_tags = { "daily" },
			workdays_only = false,
		},
	},
}
return M
