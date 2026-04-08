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
vim.api.nvim_create_user_command("ToggleBinary", function()
	local line = vim.api.nvim_get_current_line()
	local new_line = line
	-- Try each replacement in order
	if line:find("yes") then
		new_line = line:gsub("yes", "no")
	elseif line:find("no") then
		new_line = line:gsub("no", "yes")
	elseif line:find("Yes") then
		new_line = line:gsub("Yes", "No")
	elseif line:find("No") then
		new_line = line:gsub("No", "Yes")
	else
		print("No binary found on line")
		return
	end
	vim.api.nvim_set_current_line(new_line)
end, { desc = "Toggle Binary String" })

vim.api.nvim_create_user_command("GB", function()
	-- Extract the first https URL from the current line
	local line = vim.api.nvim_get_current_line()
	local url = line:match("https?://[%w%.%-%_%~%:%/%?%#%[%]%@%!%$%&%'%(%)%*%+%,%;%=]+")
	if not url then
		vim.notify("No URL found on current line", vim.log.levels.WARN)
		return
	end
	if url then
    url = url:gsub("%)$", "")
	end
	vim.fn.system("wl-copy " .. vim.fn.shellescape(url))
	vim.fn.jobstart("$BROWSER $(wl-paste)", { detach = true })
end, { desc = "Stupid GX" })

-- switching to last active tab
-- https://stackoverflow.com/a/72907994
vim.api.nvim_create_autocmd("TabLeave", {
	pattern = "*",
	callback = function()
		vim.api.nvim_set_keymap(
			"n",
			"<leader>tl",
			"<cmd>tabn " .. vim.api.nvim_tabpage_get_number(0) .. "<CR>",
			{ noremap = true, silent = true }
		)
	end,
})

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local reload_flag = vim.fn.expand("~/.cache/wal/nvim_reload")
		if vim.fn.filereadable(reload_flag) == 1 then
			vim.cmd("!sh ~/.local/bin/executer/wal.sh --theme nvchad")
			vim.fn.delete(reload_flag)
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		local function wrap(key)
			local orig = vim.fn.maparg(key, "n", false, true)
			vim.keymap.set("n", key, function()
				if orig and orig.callback then
					orig.callback()
				elseif orig and orig.rhs and orig.rhs ~= "" then
					vim.cmd("normal! " .. orig.rhs)
				else
					vim.cmd("normal! " .. key)
				end
				vim.cmd("normal! zz")
			end, { buffer = true, silent = true, desc = key .. " + center" })
		end
		-- centerings for markdown
		wrap("]]")
		wrap("[[")
	end,
})
