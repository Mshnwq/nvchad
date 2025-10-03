local options = {
  ensure_installed = {
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
  },

  highlight = {
    enable = true,
    use_languagetree = true,
  },

  indent = { enable = true },
}

require("nvim-treesitter.configs").setup(options)

vim.treesitter.language.register('gotmpl', 'mustache')
