-- lua/configs/treesitter.lua
local ensure_installed = {
	"bash",
	"lua",
	"luadoc",
	"markdown",
	"markdown_inline",
	"typescript",
	"javascript",
	"printf",
	"python",
	"toml",
	"rust",
	"xml",
	"dart",
	"terraform",
	"vim",
	"vimdoc",
	"yaml",
	"yuck",
	"nginx",
	"make",
	"json",
	"helm",
	"groovy",
	"go",
	"gomod",
	"gosum",
	"gotmpl",
	"gowork",
	"gitignore",
	"bicep",
	"awk",
	"ron",
	"svelte",
	"nix",
}

local options = {
	highlight = {
		enable = true,
		use_languagetree = true,
	},
	indent = { enable = true },
}

require("nvim-treesitter").install(ensure_installed)
require("nvim-treesitter").setup(options)

vim.treesitter.language.register("gotmpl", "mustache")
vim.treesitter.language.register("javascript", "dataviewjs")
vim.treesitter.language.register("yaml", "base")
