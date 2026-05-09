local map = vim.keymap.set
return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("configs.treesitter")
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("configs.lspconfig")
		end,
	},
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("configs.lint")
		end,
	},
	{
		require("configs.conform"),
	},

	-- My Plugins --
	{
		"kevinhwang91/nvim-ufo",
		event = "VeryLazy",
		dependencies = {
			"kevinhwang91/promise-async",
		},
		config = function()
			require("ufo").setup({
				provider_selector = function()
					return { "treesitter", "indent" }
				end,
			})
		end,
	},
	{
		"folke/todo-comments.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			signs = true, -- show icons in the signs column
			sign_priority = 8, -- sign priority
			-- keywords recognized as todo comments
			keywords = {
				FIX = {
					icon = " ", -- icon used for the sign, and in search results
					color = "error", -- can be a hex color, or a named color (see below)
					alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords
					-- signs = false, -- configure signs for some keywords individually
				},
				TODO = { icon = " ", color = "info" },
				WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
				HACK = { icon = " ", color = "hint" },
				PERF = { icon = " ", color = "hint", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
				NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
				TEST = { icon = "󰂓 ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
			},
			colors = {
				error = { "TodoError" },
				warning = { "TodoWarn" },
				info = { "TodoInfo" },
				hint = { "TodoHint" },
				test = { "TodoTest" },
				default = { "TodoDefault" },
			},
		},
	},
	{
		"folke/ts-comments.nvim",
		event = "VeryLazy",
		enabled = vim.fn.has("nvim-0.10.0") == 1,
		opts = {
			lang = {
				terraform = { "# %s" },
				yuck = { "; %s" },
				ron = { "// %s" },
			},
		},
	},
	{
		"towolf/vim-helm",
		ft = "helm",
	},
	{
		"rachartier/tiny-code-action.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope.nvim" },
		},
		event = "LspAttach",
		config = function()
			require("tiny-code-action").setup()
		end,
	},

	-- Nice UI additions
	{
		require("configs.nvimtree"),
	},
	{
		require("configs.neominimap"),
	},
	{
		"rcarriga/nvim-notify",
		keys = {
			map("n", "<leader>nn", "<Cmd>lua require('notify').dismiss()<CR>"),
		},
		config = function()
			require("notify").setup({
				background_colour = "#000000",
			})
		end,
	},
	{
		"folke/noice.nvim",
		enabled = true,
		lazy = false, -- NO NEED to Lazy load
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = function()
			return require("configs.noice")
		end,
	},

	-- git helpers
	{
		"NeogitOrg/neogit",
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration
			"nvim-telescope/telescope.nvim", -- optional
		},
		config = function()
			require("neogit").setup()
		end,
	},
	{
		"Juksuu/worktrees.nvim",
		event = "VeryLazy",
		config = function()
			require("worktrees").setup()
		end,
	},

	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		opts = function()
			return require("configs.cmp")
		end,
	},
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",
		require("luasnip.loaders.from_lua").load({ paths = "~/Documents/NeoVim/snip/" }),
	},

	-- AI helpers
	--{
	--  "zbirenbaum/copilot.lua",
	--  cmd = "Copilot",
	--  event = "InsertEnter",
	--  config = function()
	--    return require("configs.copilot")
	--  end,
	--},
	--{
	--  "zbirenbaum/copilot-cmp",
	--  event = "InsertEnter",
	--  config = function()
	--    require("copilot_cmp").setup()
	--  end,
	--  dependencies = {
	--    "zbirenbaum/copilot.lua",
	--    -- cmd = "Copilot",
	--    -- config = function()
	--    --   require("copilot").setup({
	--    --     suggestion = { enabled = false },
	--    --     panel = { enabled = false },
	--    --   })
	--    -- end,
	--  },
	--},

	-- {
	--   "jackMort/ChatGPT.nvim",
	--   event = "VeryLazy",
	--   config = function()
	--     require("chatgpt").setup()
	--     require("chatgpt").setup({
	--       api_key_cmd = 'pass show mshnwq/chatgpt-api',
	--     })
	--   end,
	--   dependencies = {
	--     "MunifTanjim/nui.nvim",
	--     "nvim-lua/plenary.nvim",
	--     "folke/trouble.nvim", -- optional
	--     "nvim-telescope/telescope.nvim"
	--   }
	-- },

	{
		"lervag/vimtex",
		lazy = false,
		keys = {
			{ "<leader>ml", "<Cmd>VimtexCompile<CR>", { desc = "Toggle Latex" } },
		},
		init = function()
			vim.g.vimtex_view_method = "zathura"
			vim.g.vimtex_compiler_method = "latexmk"
			-- vim.g.vimtex_compiler_latexmk = {
			-- 	options = {
			-- 		"-xelatex",
			-- 		"-verbose",
			-- 		"-file-line-error",
			-- 		"-synctex=1",
			-- 		"-interaction=nonstopmode",
			-- 	},
			-- }
			vim.g.vimtex_compiler_latexmk_engines = {
				-- _ = "-xelatex",
				_ = "-lualatex",
			}
		end,
	},
	{
		"nvim-tree/nvim-web-devicons",
		build = function()
			local function prepend_before_last(filepath, new_line)
				local lines = {}
				for line in io.lines(filepath) do
					table.insert(lines, line)
				end
				-- insert before last line
				table.insert(lines, #lines, new_line)
				local f = io.open(filepath, "w")
				f:write(table.concat(lines, "\n"))
				f:close()
			end
			local file1 = vim.fn.stdpath("data")
				.. "/lazy/nvim-web-devicons/lua/nvim-web-devicons/default/icons_by_file_extension.lua"
			prepend_before_last(
				file1,
				'  ["dataviewjs"]     = { icon = "", color = "#CBCB41", cterm_color = "185", name = "DV"                         },'
			)
			prepend_before_last(
				file1,
				'  ["base"]     = { icon = "", color = "#CBCB41", cterm_color = "185", name = "Base"                         },'
			)
			local file2 = vim.fn.stdpath("data") .. "/lazy/nvim-web-devicons/lua/nvim-web-devicons/filetypes.lua"
			prepend_before_last(file2, '  ["dataviewjs"] = "dataviewjs",')
			prepend_before_last(file2, '  ["base"] = "base",')
		end,
		opts = {},
	},

	{
		"mshnwq/obsidian.nvim", -- switch when merged
		-- event = nvim-obsidian-script enables it
		version = "*", --latest
		build = function()
			local file = vim.fn.stdpath("data") .. "/lazy/obsidian.nvim/lua/obsidian/search/ripgrep.lua"
			local content = table.concat(vim.fn.readfile(file), "\n")
			content =
				content:gsub("local additional_opts = {}", 'local additional_opts = { "--glob", "!_templates/**" }')
			vim.fn.writefile(vim.split(content, "\n"), file)
		end,
		event = {
			"BufReadPre " .. vim.fn.expand("~/Documents/Obsidian/**.md"),
			"BufNewFile " .. vim.fn.expand("~/Documents/Obsidian/**.md"),
		},
		keys = require("configs.obsidian").keys,
		opts = require("configs.obsidian").opts,
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		-- event = nvim-obsidian-script enables it
		-- apply quote callout patch
		build = function()
			local file = vim.fn.stdpath("data")
				.. "/lazy/render-markdown.nvim/lua/render-markdown/render/markdown/quote.lua"
			local content = table.concat(vim.fn.readfile(file), "\n")
			content = content:gsub(
				"virt_text = { { title or config.rendered, config.highlight } }",
				"virt_text = { { title or config%.rendered %.%. %" .. "' '" .. ', "RenderMarkdownQuoteTitle" } }'
			)
			content = content:gsub("return icon .. ' ' .. title", "return icon %.%. ' ' %.%. title %.%. ' '")
			content = content:gsub(
				"virt_text = { { self.data.icon, self.data.highlight } }",
				'virt_text = { { self%.data%.icon, "RenderMarkdownQuoteIcon" } }'
			)
			vim.fn.writefile(vim.split(content, "\n"), file)
		end,
		keys = {
			map("n", "<leader>mt", function()
				require("lazy").load({ plugins = { "render-markdown.nvim" } })
				require("render-markdown").buf_toggle()
			end, { desc = "Toggle Buffer Render Markdown" }),
			map("n", "<leader>mT", function()
				require("lazy").load({ plugins = { "render-markdown.nvim" } })
				require("render-markdown").toggle()
			end, { desc = "Toggle Render Markdown" }),
			map("n", "<leader>mv", function()
				require("lazy").load({ plugins = { "render-markdown.nvim" } })
				require("render-markdown").preview()
			end, { desc = "Preview Render Markdown" }),
		},
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-mini/mini.nvim",
		},
		opts = require("configs.markdown"),
	},
	{
		"hedyhli/outline.nvim",
		lazy = true,
		cmd = { "Outline", "OutlineOpen" },
		keys = {
			{ "<leader>mo", "<cmd>Outline<CR>", desc = "Toggle outline" },
		},
		opts = {
			width = 10,
			preview_window = {
				auto_preview = true,
			},
		},
	},
	{
		"nvim-mini/mini.ai",
		version = "*", --stable
		event = "VeryLazy",
		config = function()
			require("mini.ai").setup()
		end,
	},
	{
		"nvim-mini/mini.surround",
		version = "*", --stable
		event = "VeryLazy",
		opts = {
			silent = true,
			mappings = {
				replace = "ss",
			},
		},
		config = function(_, opts)
			require("mini.surround").setup(opts)
			vim.keymap.set("n", "s", "<Nop>")
		end,
	},
}
