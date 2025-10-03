local util = require("conform.util")
-- https://github.com/stevearc/conform.nvim#setupopts
local options = {
  default_format_opts = {
    timeout_ms = 3000,
    lsp_format = "fallback",
    quiet = false,
    async = false,
  },
  -- format_on_save = {
  -- 	lsp_fallback = true,
  -- 	async = false,
  -- 	timeout_ms = 500,
  -- },
  formatters_by_ft = {
    lua = { "stylua" },
    nix = { "nixfmt" }, -- nixfmt official (haskel), alejandra unofficial (rust)
    bash = { "shfmt" },
    sh = { "shfmt" },
    python = { "ruff_format" },
    -- use the lsp
    -- go = { "gofumpt", "goimports-reviser", "golines" },
    -- gomod = { "gofumpt", "goimports-reviser" },
    -- gowork = { "gofumpt", "goimports-reviser" },
    -- gotmpl = { "gofumpt", "goimports-reviser" },
    yaml = { "prettierd" },
    yml = { "prettierd" },
    -- javascript = { "prettierd" },
    -- typescript = { "prettierd" },
    -- css = { "prettierd" },
    -- html = { "prettierd" },
    -- json = { "prettierd" },
  },
  formatters = {
    -- https://github.com/mvdan/sh
    shfmt = {
      inherit = false,
      command = "shfmt",
      args = { "-i", "2", "-filename", "$FILENAME" },
    },
    golines = {
      prepend_args = { "--max-len=80" },
    },
    ["goimports-reviser"] = {
      prepend_args = { "-rm-unused" },
    },
  },
}

return options
