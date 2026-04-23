-- snip/md.lua
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local f = ls.function_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt
-- https://www.youtube.com/watch?v=FmHhonPjvvA

local function clipboard()
	return vim.fn.getreg("+")
end
local function is_email(str)
	local clean = string.match(str, "%S+@%S+")
	if clean then
		return string.match(clean, "^[%w._%+-]+@[%w.-]+%.%a%a+$")
	end
end
local function clipboard_if_email()
	local email = is_email(clipboard())
	-- local email = is_email(vim.fn.getreg("+"))
	if email then
		return email
	end
	return ""
end

-- read current file, find first [[link]] under ## Items
local function get_item_from_file()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local in_items = false
	for _, line in ipairs(lines) do
		if line:match("^##%s+Items") then
			in_items = true
		elseif in_items then
			local link = line:match("%[%[(.-)%]%]")
			if link then
				return link
			end
			-- stop at next heading
			if line:match("^##") then
				break
			end
		end
	end
	return "Item"
end

ls.add_snippets("markdown", {
	s(
		";email_item",
		fmt(
			[[
Dear @{name},
Hope you are doing well.

We would like to request a quotation for the following item:
- **{item}**:
  - Description:
  - Quantity: **{qty}**
]],
			{
				name = d(1, function()
					local email = clipboard_if_email()
					if email ~= "" then
						return sn(nil, { t(email) })
					else
						return sn(nil, { i(1, "email") })
					end
				end),
				qty = i(2, "1"),
				item = f(get_item_from_file),
			}
		)
	),
})

-- great it works with | in obsidian but gd broke in nvim
ls.add_snippets("markdown", {
	s(
		";email_table",
		fmt(
			[==[
|Receiver|Status|
|--|--|
{rows}]==],
			{
				rows = d(1, function()
					local fname = vim.fn.expand("%:t:r")
					local out = vim.fn.expand("~/Documents/Obsidian/Home/.dataview/" .. fname .. ".json")
					local ok, raw = pcall(vim.fn.readfile, out)
					if not ok or #raw == 0 then
						return sn(nil, { t("|[[unknown\\|unknown]]|Pending Response|") })
					end
					local data = vim.fn.json_decode(table.concat(raw, "\n"))
					local lines = {}
					for _, entry in ipairs(data) do
						local email = entry.email:match("<(.-)>") or entry.email
						local contact = entry.contact:match("([^/]+)%.md$") or entry.contact
						table.insert(lines, "|[[" .. contact .. "\\|" .. email .. "]]|Pending Response|")
					end
					return sn(nil, { t(lines) })
				end),
			}
		)
	),
})
