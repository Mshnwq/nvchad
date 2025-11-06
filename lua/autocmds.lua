require("nvchad.autocmds")

local highlight_group = vim.api.nvim_create_augroup("yankhighlight", { clear = true })
vim.api.nvim_create_autocmd("textyankpost", {
	group = highlight_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank()
	end,
})
vim.api.nvim_create_autocmd("TextYankPost", {
	group = highlight_group,
	pattern = "*",
	callback = function()
		local ev = vim.v.event
		if ev.operator == "y" or ev.operator == "d" then
			vim.fn.system("wl-copy", vim.fn.getreg('"'))
		end
	end,
})

-- Paste from system clipboard with Ctrl-V newline cleanup
vim.keymap.set("n", '"+p', function()
	local paste = vim.fn.system("wl-paste --no-newline")
	paste = string.gsub(paste, "\r", "")
	vim.fn.setreg('"', paste)
	vim.cmd("normal! p")
end, { noremap = true, silent = true })

-- Paste from primary selection
vim.keymap.set("n", '"*p', function()
	local paste = vim.fn.system("wl-paste --no-newline --primary")
	paste = string.gsub(paste, "\r", "")
	vim.fn.setreg('"', paste)
	vim.cmd("normal! p")
end, { noremap = true, silent = true })

-- -----------------------------------------------------------------------------
-- filetype functions
-- -----------------------------------------------------------------------------
local ft_lsp_group = vim.api.nvim_create_augroup("ft_lsp_group", { clear = true })

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
	pattern = "*compose*.{yml,yaml}",
	group = ft_lsp_group,
	desc = "Fix the issue where the LSP does not start with docker-compose.",
	callback = function()
		vim.bo.filetype = "yaml.docker-compose"
	end,
})
-- TODO: fix in conform
vim.api.nvim_create_user_command("DCLint", function()
	local file = vim.fn.expand("%:p")
	---@diagnostic disable-next-line: unused-local
	vim.system({ "dclint", "--quiet", "--fix", file }, { text = true }, function(obj)
		vim.schedule(function()
			vim.cmd("edit!") -- reload buffer with fixed content
		end)
	end)
end, { desc = "Fix docker-compose" })

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
	pattern = { "*.gitlab-ci*.{yml,yaml}", "*/.gitlab-ci/*.{yml,yaml}" },
	group = ft_lsp_group,
	desc = "Fix the issue where the LSP does not start with gitlab-ci.",
	callback = function()
		vim.bo.filetype = "yaml.gitlab"
	end,
})
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
	pattern = "*.{yml,yaml}.tftpl",
	group = ft_lsp_group,
	desc = "Fix the issue where the LSP for yaml.tftpl.",
	callback = function()
		vim.bo.filetype = "yaml"
	end,
})

-- TODO: fix folding
-- vim.opt.foldmethod = "indent"
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

local M = {}
-- function to create a list of commands and convert them to autocommands
-------- This function is taken from https://github.com/norcalli/nvim_utils
-- Modern version of nvim_create_augroups using Neovim Lua API
function M.nvim_create_augroups(definitions)
	for group_name, autocmds in pairs(definitions) do
		local group = vim.api.nvim_create_augroup(group_name, { clear = true })
		for _, def in ipairs(autocmds) do
			local event = def[1]
			local opts = vim.tbl_deep_extend("force", { group = group }, def[2] or {})
			vim.api.nvim_create_autocmd(event, opts)
		end
	end
end

local autoCommands = {
	open_folds = {
		{
			{ "BufReadPost", "FileReadPost", "VimEnter" },
			{
				pattern = "*",
				command = "normal! zR",
			},
		},
	},
}
M.nvim_create_augroups(autoCommands)

-- Notification on macro start
vim.api.nvim_create_autocmd("RecordingEnter", {
	callback = function()
		local register = vim.fn.reg_recording()
		if register ~= "" then
			local icon = " "
			local message = " Macro started on register: " .. register
			vim.notify(message, vim.log.levels.INFO, { icon = icon, title = "Macro Started" })
		end
	end,
	desc = "Notify macro start",
})

-- Notification on macro end
vim.api.nvim_create_autocmd("RecordingLeave", {
	callback = function()
		local register = vim.fn.reg_recording()
		if register ~= "" then
			local icon = " "
			local message = " Macro ended on register: " .. register
			vim.notify(message, vim.log.levels.INFO, { icon = icon, title = "Macro Ended" })
		end
	end,
	desc = "Notify macro end",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "txt", "env" },
	---@diagnostic disable-next-line: unused-local
	callback = function(opts)
		-- local cmp = require("cmp")
		-- cmp.setup.buffer({ enabled = false })
		-- have to "re-enable" spellchecking for these files
		vim.opt.spell = true
		vim.opt.spelllang = "en_us"
	end,
})
-- vim.opt.spell = true
-- vim.opt.spelllang = "en_us"

vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	callback = function()
		vim.opt_local.spell = false
	end,
})

-- Toggle boolean string under cursor
vim.api.nvim_create_user_command("ToggleBoolean", function()
	local line = vim.api.nvim_get_current_line()
	local new_line = line
	-- Try each replacement in order
	if line:find("true") then
		new_line = line:gsub("true", "false")
	elseif line:find("false") then
		new_line = line:gsub("false", "true")
	elseif line:find("True") then
		new_line = line:gsub("True", "False")
	elseif line:find("False") then
		new_line = line:gsub("False", "True")
	else
		print("No boolean found on line")
		return
	end
	vim.api.nvim_set_current_line(new_line)
end, { desc = "Toggle Boolean String" })
