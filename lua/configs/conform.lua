-- https://github.com/stevearc/conform.nvim#setupopts
return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	opts = {
		log_level = vim.log.levels.DEBUG,
		format_on_save = {
		  lsp_fallback = true,
		  async = false,
		},
		default_format_opts = {
			timeout_ms = 3000,
			lsp_format = "fallback",
			quiet = false,
			async = false,
		},
		formatters_by_ft = {
			lua = { "stylua" },
			nix = { "nixfmt" }, -- nixfmt official (haskel), alejandra unofficial (rust)
			bash = { "shfmt" },
			sh = { "shfmt" },
			python = { "isort", "ruff_format" },
			-- go = { "gofumpt", "goimports-reviser", "golines" },
			-- gomod = { "gofumpt", "goimports-reviser" },
			-- gowork = { "gofumpt", "goimports-reviser" },
			-- gotmpl = { "gofumpt", "goimports-reviser" },
			-- web --
			-- javascript = { "prettierd" },
			-- typescript = { "prettierd" },
			-- css = { "prettierd" },
			-- html = { "prettierd" },
			-- json = { "prettierd" },
			-- devops --
			yaml = { "prettierd" },
			yml = { "prettierd" },
			["yaml.docker-compose"] = { "prettierd" },
			["yaml.gitlab"] = { "prettierd" },
			dockerfile = { "dockerfmt" },
		},
		formatters = {
			nixfmt = {
				append_args = { "--width", "80" },
			},
			-- golines = {
			--   prepend_args = { "--max-len=80" },
			-- },
			-- ["goimports-reviser"] = {
			--   prepend_args = { "-rm-unused" },
			-- },
		},
	},
}
