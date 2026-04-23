dofile(vim.g.base46_cache .. "cmp")

local cmp = require("cmp")

local sources = {
	{
		name = "nvim_lsp",
		option = {
			markdown_oxide = {
				keyword_pattern = [[\(\k\| \|\/\|#\)\+]],
			},
		},
	},
	{ name = "luasnip", keyword_length = 2 },
	{ name = "buffer" },
	{ name = "nvim_lua" },
	{ name = "path" },
}

local options = {
	completion = { completeopt = "menu,menuone" },

	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},

	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},

	mapping = {
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif require("luasnip").expand_or_jumpable() then
				require("luasnip").expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif require("luasnip").jumpable(-1) then
				require("luasnip").jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),

		["<ESC>"] = cmp.mapping.abort(),

		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),

		["<S-CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select = true,
		}),
	},

	sources = sources,
}

-- patch luasnip keyword_length for markdown
local md_sources = vim.deepcopy(sources)
for _, s in ipairs(md_sources) do
	if s.name == "luasnip" then
		s.keyword_length = 1
	end
end
cmp.setup.filetype("markdown", {
	sources = cmp.config.sources(md_sources),
})

return vim.tbl_deep_extend("force", options, require("nvchad.cmp"))
