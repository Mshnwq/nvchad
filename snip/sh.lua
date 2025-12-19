local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({ trig = "#!bash" }, {
		t("#!/usr/bin/env bash"),
		t({ "", "" }),
		i(0),
	}),
}
