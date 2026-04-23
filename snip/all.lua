local ls = require("luasnip")
local t = ls.text_node

return {
	ls.snippet({ trig = "hi" }, { t("Hello, world!") }),
}
