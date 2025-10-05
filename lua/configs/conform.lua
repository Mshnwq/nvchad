-- https://github.com/stevearc/conform.nvim#setupopts
return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	opts = {
		log_level = vim.log.levels.TRACE,
		-- format_on_save = {
		--   lsp_fallback = true,
		--   async = false,
		-- },
		default_format_opts = {
			timeout_ms = 3000,
			lsp_format = "fallback",
			quiet = false,
			async = false,
		},
		formatters_by_ft = {
			lua = { "stylua" },
			nix = { "nixfmt" },
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
			["yaml.gitlab"] = { "prettierd" },
			["yaml.docker-compose"] = { "dclint" },
			dockerfile = { "dockerfmt" },
		},
		formatters = {
			nixfmt = {
				append_args = { "--width", "80" },
			},
			dclint = {
				command = "dclint",
				args = {
					"--fix",
					"$FILENAME",
				},
			},
		},
	},
}
