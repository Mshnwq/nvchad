-- lua/configs/lspconfig.lua
require("nvchad.configs.lspconfig").defaults()
local nvlsp = require("nvchad.configs.lspconfig")
local map = vim.keymap.set
local nomap = vim.keymap.del

local custom_on_attach = function(_, bufnr)
	local function opts(desc)
		return { buffer = bufnr, desc = "LSP " .. desc }
	end
	map("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
	map("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
	pcall(nomap, "n", "gri")
	map("n", "gi", vim.lsp.buf.implementation, opts("Go to implementation"))
	pcall(nomap, "n", "grt")
	map("n", "gt", vim.lsp.buf.type_definition, opts("Go to type definition"))
	pcall(nomap, "n", "grr")
	map("n", "gr", vim.lsp.buf.references, opts("Show references"))
	pcall(nomap, "n", "grn")
	map("n", "gn", vim.lsp.buf.rename, opts("Rename"))
	map("n", "gh", vim.lsp.buf.hover, opts("Show hover"))
	pcall(nomap, "n", "gra")
	map("n", "<leader>da", function()
		require("tiny-code-action").code_action()
	end, opts("Code action"))

	-- Override handler with custom options
	local sig_win_id = nil
	vim.lsp.config("*", {
		handlers = {
			["textDocument/signatureHelp"] = function(err, result, ctx, config)
				vim.lsp.handlers["textDocument/signatureHelp"](
					err,
					result,
					ctx,
					vim.tbl_extend("force", config or {}, {
						border = "single",
						max_height = 7,
						focusable = false,
						silent = true,
					})
				)
			end,
		},
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
	"nil_ls",
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

-- https://oxide.md/README#Neovim
vim.lsp.config("markdown_oxide", {
	filetypes = { "markdown" },
	cmd = { "markdown-oxide" },
	capabilities = vim.tbl_deep_extend("force", nvlsp.capabilities, {
		workspace = {
			didChangeWatchedFiles = {
				dynamicRegistration = true,
			},
		},
		textDocument = {
			codeLens = {
				dynamicRegistration = true,
			},
		},
	}),
	on_attach = function(client, bufnr)
		custom_on_attach(client, bufnr)
		for _, cmd in ipairs({ "today", "tomorrow", "yesterday" }) do
			vim.api.nvim_buf_create_user_command(bufnr, cmd:gsub("^%l", string.upper), function()
				client:exec_cmd({
					title = ("Markdown-Oxide-%s"):format(cmd),
					command = "jump",
					arguments = { cmd },
				}, { bufnr = bufnr })
			end, { desc = ("Open %s daily note"):format(cmd) })
		end
	end,
})
vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave", "CursorHold", "BufEnter" }, {
	callback = function(args)
		for _, c in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
			if c.name == "markdown_oxide" then
				vim.lsp.codelens.enable(true, { bufnr = args.buf })
				break
			end
		end
	end,
})
vim.lsp.enable("markdown_oxide")

-- NOTE: for this to work
-- must patch neovim/runtime/lua/vim/lsp/codelens.lua
-- with M._Provider = Provider to publicize it
local Provider = vim.lsp.codelens._Provider
Provider.on_win = function(self, toprow, botrow)
	local bufnr = self.bufnr
	for row = toprow, botrow do
		if self.row_version[row] == self.version then
			goto continue -- skip if already up to date
		end
		for client_id, state in pairs(self.client_state) do
			vim.api.nvim_buf_clear_namespace(bufnr, state.namespace, row, row + 1)
			local titles = {}
			for _, lens in ipairs(state.row_lenses[row] or {}) do
				if lens.command then
					titles[#titles + 1] = lens.command.title
				else
					self:resolve(vim.lsp.get_client_by_id(client_id), lens)
				end
			end
			if #titles > 0 then
				vim.api.nvim_buf_set_extmark(bufnr, state.namespace, row, 0, {
					virt_text = { { "  " .. table.concat(titles, " | "), "LspCodeLens" } },
					virt_text_pos = "eol",
				})
			end
			self.row_version[row] = self.version
		end
		::continue::
	end
end

vim.lsp.config("harper_ls", {
	filetypes = { "markdown" },
	root_markers = { ".obsidian" },
	settings = {
		["harper-ls"] = {
			userDictPath = "~/Documents/spell/en.utf-8.add",
			-- https://writewithharper.com/docs/rules
			linters = {
				-- https://github.com/Automattic/harper/issues/1573#issuecomment-3777776431
				ToDoHyphen = false,
			},
			codeActions = {
				ForceStable = false,
			},
			markdown = {
				-- [ignores this part]()
				IgnoreLinkTitle = true,
			},
			isolateEnglish = true,
		},
	},
})
vim.lsp.enable("harper_ls")

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.keymap.set("n", "zG", function()
			vim.lsp.buf.code_action({
				filter = function(action)
					return action.title:lower():find("to the user dictionary") ~= nil
				end,
				apply = true,
			})
		end, { buffer = true, desc = "Harper: add word to user dictionary" })
		vim.keymap.set("n", "zw", function()
			vim.lsp.buf.code_action({
				filter = function(action)
					return action.title:lower():find("ignore") ~= nil
				end,
				apply = true,
			})
		end, { buffer = true, desc = "Harper: Ignore" })
	end,
})
