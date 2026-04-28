-- lua/configs/obsidian.lua
local vault = "~/Documents/Obsidian/Home"
local inbox_dir = "0_Inbox"
local notes_dir = "1_Notes"
local topics_dir = "2_Topics"
local indexes_dir = "3_Indexes"
local months = {
	"January",
	"February",
	"March",
	"April",
	"May",
	"June",
	"July",
	"August",
	"September",
	"October",
	"November",
	"December",
}
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
			-- post_write_note = function()
			-- 	vim.cmd("Obsidian open")
			-- end,
			pre_write_note = function(note)
				local bufnr = vim.fn.bufnr(tostring(note.path))
				if bufnr == -1 then
					return
				end
				local days = { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" }
				local t = os.date("*t")
				local hour = t.hour % 12
				if hour == 0 then
					hour = 12
				end
				local ampm = t.hour < 12 and "am" or "pm"
				local timestamp = string.format(
					"%04d-%02d-%02d-%s %02d:%02d %s",
					t.year,
					t.month,
					t.day,
					days[t.wday],
					hour,
					t.min,
					ampm
				)
				local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
				for i, line in ipairs(lines) do
					if line:match("^id:") then
						lines[i] = string.format('id: "%s"', tostring(note.id))
					end
					if vim.bo[bufnr].modified and line:match("^updated_on:") then
						lines[i] = string.format('updated_on: "%s"', timestamp)
					end
				end
				vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
				vim.api.nvim_buf_call(bufnr, function()
					vim.cmd("noautocmd write")
				end)
			end,
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
			-- use pre write
			enabled = false,
			sort = vim.NIL,
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
		templates = {
			folder = "_templates",
			substitutions = {
				custom_date_1 = function(ctx)
					local name = ctx.partial_note and ctx.partial_note:display_name() or ""
					local y, m, d = name:match("^(-?%d+)-(%d+)-(%d+)$")
					if not y then
						return ""
					end
					return string.format("%d %s %d", tonumber(d), months[tonumber(m)], tonumber((y:gsub("^-", ""))))
				end,
				custom_date_2 = function(ctx)
					local name = ctx.partial_note and ctx.partial_note:display_name() or ""
					local y, m, d = name:match("^(-?%d+)-(%d+)-(%d+)$")
					if not y then
						return ""
					end
					return string.format("%s %d, %d", months[tonumber(m)], tonumber(d), tonumber((y:gsub("^-", ""))))
				end,
				absolute_date = function(ctx)
					local name = ctx.partial_note and ctx.partial_note:display_name() or ""
					local n = tonumber((name:gsub("^-", "")))
					if not n then
						return ""
					end
					return string.format("%d", n)
				end,
			},
			customizations = (function()
				local result = {}
				local subdir_map = {
					["Index"] = indexes_dir,
					["Date-bc-year"] = indexes_dir .. "/Dates/BC/Years",
					["Date-bc"] = indexes_dir .. "/Dates/BC",
					["Date-year"] = indexes_dir .. "/Dates/Years",
					["Date"] = indexes_dir .. "/Dates",
					["Topic"] = topics_dir,
					["Book"] = notes_dir .. "/Books",
					["Company-brand"] = notes_dir .. "/Companies/Brand",
					["Company-distributor"] = notes_dir .. "/Companies/DST",
					["Contact-distributor"] = notes_dir .. "/Contacts/DST",
					["Item"] = notes_dir .. "/Items",
					["People-figure"] = notes_dir .. "/People/Figures",
					["Quotation"] = notes_dir .. "/Quotas",
				}
				local files = vim.fn.glob(vault .. "/_templates/*.md", false, true)
				for _, file in ipairs(files) do
					local name = vim.fn.fnamemodify(file, ":t:r")
					name = name:sub(1, 1):upper() .. name:sub(2)
					local key = name:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", "")
					local subdir = subdir_map[name] or notes_dir
					result[key] = { notes_subdir = subdir }
					if name == "Quotation" then
						result[key].note_id_func = function()
							return "quo-" .. tostring(os.time())
						end
					end
				end
				return result
			end)(),
		},
		-- matches daily notes core plugin behavior
		daily_notes = {
			enabled = true,
			folder = inbox_dir,
			template = "daily",
			date_format = "YYYY-MM-DD-dddd",
			alias_format = nil,
			default_tags = { "daily" },
			workdays_only = false,
		},
	},
}
return M
