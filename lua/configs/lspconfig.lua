require("nvchad.configs.lspconfig").defaults()
local nvlsp = require("nvchad.configs.lspconfig")
local map = vim.keymap.set

local custom_on_attach = function(_, bufnr)
	local function opts(desc)
		return { buffer = bufnr, desc = "LSP " .. desc }
	end
	map("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
	map("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
	map("n", "gi", vim.lsp.buf.implementation, opts("Go to implementation"))
	map("n", "gt", vim.lsp.buf.type_definition, opts("Go to type definition"))
	map("n", "gr", vim.lsp.buf.references, opts("Show references"))
	map("n", "gh", vim.lsp.buf.hover, opts("Show hover"))
	map("n", "<leader>ca", function()
		require("tiny-code-action").code_action()
	end, opts("Code action"))
	-- Keep track of the last signature window ID
	local sig_win_id = nil
	-- Override handler with custom options
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "single",
		max_height = 7,
		focusable = false,
		silent = true,
	})
	-- Toggle function
	local function toggle_signature()
		if sig_win_id and vim.api.nvim_win_is_valid(sig_win_id) then
			vim.api.nvim_win_close(sig_win_id, true)
			sig_win_id = nil
		else
			vim.lsp.buf.signature_help()
			-- Capture the floating window ID
			local wins = vim.api.nvim_tabpage_list_wins(0)
			for _, w in ipairs(wins) do
				local config = vim.api.nvim_win_get_config(w)
				if config.relative ~= "" then
					sig_win_id = w
					break
				end
			end
		end
	end
	vim.keymap.set({ "n", "i" }, "<C-k>", toggle_signature, { desc = "Toggle signature help" })
end

-- override for all
vim.lsp.config("*", {
	capabilities = nvlsp.capabilities,
	on_init = nvlsp.on_init,
	on_attach = custom_on_attach,
})

-- list of all servers configured.
-- https://github.com/neovim/nvim-lspconfig/tree/master/lsp
local enabled_servers = {
	"bashls",
	"nil_ls", -- nil_ls (rust) or nixd (c++)
	"pyright",
	-- "gopls",
	-- WebDev
	"svelte",
	"ts_ls",
	"nginx_language_server",
	-- DevOps
	"helm_ls",
	"terraformls",
	"yamlls",
	"gitlab_ci_ls",
	"docker_compose_language_service",
	"dockerls",
}
vim.lsp.enable(enabled_servers)

vim.lsp.config("yamlls", {
	filetypes = { "yaml" },
	settings = {
		yaml = {
			schemaStore = {
				enable = true,
				url = "https://www.schemastore.org/api/json/catalog.json",
			},
			schemas = {
				-- use this if you want to match all '*.yaml' files
				-- [require('kubernetes').yamlls_schema()] = { "*manifest.yaml", "*/manifests/*.yaml" },
				-- ArgoCD ApplicationSet CRD
				-- ["https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/crds/applicationset-crd.yaml"] = "*/argo/*.yaml",
				-- ArgoCD Application CRD
				["https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/crds/application-crd.yaml"] = "*/argo/*.yaml",
				-- -- Kubernetes strict schemas
				-- ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.29.3-standalone-strict/all.json"] = "",
			},
			validate = true,
			completion = true,
			hover = true,
			format = {
				enable = true,
				bracketSpacing = true,
				printWidth = 80,
				proseWrap = "preserve",
				singleQuote = true,
			},
			customTags = {
				"!Ref",
				"!Sub sequence",
				"!Sub mapping",
				"!GetAtt",
			},
			disableAdditionalProperties = false,
			maxItemsComputed = 5000,
			trace = {
				server = "verbose",
			},
		},
		redhat = {
			telemetry = {
				enabled = false,
			},
		},
	},
})

-- Handeled from vim-helm plugin
vim.lsp.config("helm_ls", {
	filetypes = { "helm", "yaml.helm-values", "mustache" },
})
