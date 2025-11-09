require("nvchad.mappings")

local map = vim.keymap.set
local nomap = vim.keymap.del

map("n", ";", ":", { desc = "CMD enter command mode" })

-- Focus buffer by number using tabufline (with safety check)
for i = 1, 6 do
	map("n", "<leader>" .. i, function()
		local bufs = vim.t.bufs or {}
		if bufs[i] then
			vim.api.nvim_set_current_buf(bufs[i])
		else
			vim.notify("Buffer " .. i .. " doesn't exist", vim.log.levels.WARN)
		end
	end, { desc = "Go to buffer " .. i })
end
map("n", "<leader><leader>", function()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-6>", true, false, true), "n", true)
end, { desc = "Last Buffer" })

map("n", "<leader>[", "<cmd>t-1<CR>")
map("n", "<leader>]", "<cmd>t.<CR>")

-- In visual mode, paste over selected text WITHOUT yanking the deleted text
map("x", "p", [["_dP]])
map("n", "x", '"_x') -- use x or X in Visual mode to cut

-- Change without overwriting registers or clipboard
map({ "n", "v" }, "d", '"_d')
map({ "n", "v" }, "D", '"_D')
map({ "n", "v", "x" }, "c", '"_c', { noremap = true })
map({ "n", "v", "x" }, "C", '"_C', { noremap = true })

nomap("n", "<leader>n")
nomap("n", "<leader>rn")
map("n", "<leader>nt", "<cmd>set nu!<CR>", { desc = "toggle line number" })
map("n", "<leader>nr", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })

map("n", "<leader>mp", function()
	require("conform").format({
		lsp_fallback = true,
		async = false,
		timeout_ms = 500,
	})
end, { desc = "Format file or range" })
-- map("v", "<leader>mp", "<cmd>FormatYaml<CR>", { desc = "Format yaml range" })

map("n", "<leader>tt", function()
	require("base46").toggle_transparency()
end, { desc = "Toggle transparency" })

map("n", "<leader>do", "<cmd> lua vim.diagnostic.open_float() <cr>", { desc = "Show diagnostic" })
map("n", "<leader>dc", function()
	local line = vim.api.nvim_win_get_cursor(0)[1] - 1 -- get current line (0-indexed)
	local diagnostics = vim.diagnostic.get(0, { lnum = line })
	if #diagnostics > 0 then
		local msgs = {}
		for _, d in ipairs(diagnostics) do
			table.insert(msgs, d.message)
		end
		local text = table.concat(msgs, "\n")
		vim.fn.setreg("+", text) -- copy to system clipboard
		vim.notify("Copied diagnostic to clipboard", vim.log.levels.INFO)
	else
		vim.notify("No diagnostics on this line", vim.log.levels.WARN)
	end
end, { desc = "Copy diagnostic" })
-- map({ "n", "i" }, "<C-k>", "<cmd>lua vim.lsp.buf.hover()<cr>")

nomap("n", "<leader>ma")
nomap("n", "<leader>fm")
map("n", "<leader>fm", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
nomap("n", "<leader>cm")
map("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
map("n", "<leader>gs", "<cmd>!Serie<CR>", { desc = "Refresh Wal" })

-- Windows
map("n", "<leader><A-->", "<cmd> sp <cr>", { desc = "Split window horizontally" })
map("n", "<leader><A-\\>", "<cmd> vsp <cr>", { desc = "Split window vertically" })
map("n", "<leader><A-w>", "<C-w>q", { desc = "Close Window" })
map("n", "<leader>X", "<cmd> %bd|e# <cr>", { desc = "buffer close all" })

-- Navigate windows
vim.keymap.set({ "n", "t" }, "<A-Left>", function()
	if vim.fn.mode() == "t" then
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n><C-w>h", true, false, true), "n", true)
	else
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>h", true, false, true), "n", true)
	end
end, { desc = "Switch window left" })
vim.keymap.set({ "n", "t" }, "<A-Right>", function()
	if vim.fn.mode() == "t" then
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n><C-w>l", true, false, true), "n", true)
	else
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>l", true, false, true), "n", true)
	end
end, { desc = "Switch window right" })
vim.keymap.set({ "n", "t" }, "<A-Down>", function()
	if vim.fn.mode() == "t" then
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n><C-w>j", true, false, true), "n", true)
	else
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>j", true, false, true), "n", true)
	end
end, { desc = "Switch window down" })
vim.keymap.set({ "n", "t" }, "<A-Up>", function()
	if vim.fn.mode() == "t" then
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n><C-w>k", true, false, true), "n", true)
	else
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>k", true, false, true), "n", true)
	end
end, { desc = "Switch window up" })

-- NvimTree
nomap("n", "<C-n>")
map("n", "<C-e>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })

-- Notifications
map("n", "<leader>nn", "<cmd>lua require('notify').dismiss()<CR>", { desc = "Dismiss notifications" })

-- Terminal mappings
nomap("n", "<leader>h")
nomap("n", "<leader>v")
nomap({ "n", "t" }, "<A-v>")
nomap({ "n", "t" }, "<A-h>")
nomap({ "n", "t" }, "<A-i>")
nomap("n", "<leader>pt")

-- Helper function to get preferred shell
local function get_shell()
	local current_shell = vim.o.shell
	-- If current shell is bash (devenv), use zsh instead
	if current_shell:match("bash$") then
		return "zsh"
	end
	return ""
end

map("n", "<A-=>", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })
map({ "n", "t" }, "<A-\\>", function()
	require("nvchad.term").toggle({ pos = "vsp", id = "vtoggleTerm", size = 0.325, cmd = get_shell() })
end, { desc = "vterm" })
map({ "n", "t" }, "<A-->", function()
	require("nvchad.term").toggle({ pos = "sp", id = "htoggleTerm", size = 0.275, cmd = get_shell() })
end, { desc = "hterm" })
map({ "n", "t" }, "<A-f>", function()
	require("nvchad.term").toggle({ pos = "float", id = "floatTerm", cmd = get_shell() })
end, { desc = "floating term" })

map({ "n", "t" }, "<A-]>", function()
	require("nvchad.term").toggle({
		pos = "float",
		id = "vfloatTerm",
		cmd = get_shell(),
		float_opts = {
			row = 0.05,
			col = 0.8,
			width = 0.3,
			height = 0.9,
		},
	})
end, { desc = "floating vterm" })

map({ "n", "t" }, "<A-[>", function()
	require("nvchad.term").toggle({
		pos = "float",
		id = "hfloatTerm",
		cmd = get_shell(),
		float_opts = {
			row = 0.9,
			col = 0.15,
			width = 0.9,
			height = 0.3,
		},
	})
end, { desc = "floating hterm" })

-- NeoGit
map("n", "<leader>gn", "<cmd>Neogit<CR>", { desc = "Open NeoGit" })
-- Worktree
require("telescope").load_extension("worktrees")
map(
	"n",
	"<leader>gws",
	"<cmd>lua require('telescope').extensions.worktrees.list_worktrees(opts)<CR>",
	{ desc = "Manage Worktree" }
)
map("n", "<leader>gwb", "<cmd>GitWorktreeCreateExisting<CR>", { desc = "Create Existing Worktree" })
map("n", "<leader>gwc", "<cmd>GitWorktreeCreate<CR>", { desc = "Create New Worktree" })

-- Todo
map("n", "]t", function()
	require("todo-comments").jump_next()
end, { desc = "Next todo comment" })
map("n", "[t", function()
	require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })
map("n", "<leader>tdt", "<cmd>TodoTelescope<CR>", { desc = "Telescope TODO" })
map("n", "<leader>tdl", "<cmd>TodoLocList<CR>", { desc = "Local TODO" })
map("n", "<leader>tdg", "<cmd>TodoQuickFix<CR>", { desc = "Global TODO" })

nomap("n", "<leader>ch")
nomap("n", "<leader>tt")
nomap("n", "<leader>th")
map("n", "<leader>tw", "<cmd>!sh ~/.config/dots/scripts/executer/.wal_nvchad.sh<CR>", {
	silent = true,
	desc = "Refresh Wal",
})

map("n", "tb", "<cmd>ToggleBoolean<CR>", { desc = "Toggle Boolean String" })

map("n", "<leader>mv", "<cmd>Markview toggle<CR>", { desc = "Toggle Markview" })
