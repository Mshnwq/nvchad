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

map("n", "<A-k>", "<Cmd>t-1<CR>")
map("n", "<A-j>", "<Cmd>t.<CR>")
map("n", "<A-K>", "<Cmd>normal gcc<CR><Cmd>t-1<CR><Cmd>normal gcc<CR>")
map("n", "<A-J>", "<Cmd>normal gcc<CR><Cmd>t.<CR><Cmd>normal gcc<CR>")

-- In visual mode, paste over selected text WITHOUT yanking the deleted text
map("x", "p", [["_dP]])
map("n", "x", '"_x') -- use x or X in Visual mode to cut
map("n", "X", "Vx") -- to cut is to visual first

-- Change without overwriting registers or clipboard
map({ "n", "v" }, "d", '"_d')
map({ "n", "v" }, "D", '"_D')
map({ "n", "v", "x" }, "c", '"_c', { noremap = true })
map({ "n", "v", "x" }, "C", '"_C', { noremap = true })

map("i", "{", "{", { noremap = true })
map("i", "}", "}", { noremap = true })

nomap("n", "<leader>n")
nomap("n", "<leader>rn")
map("n", "<leader>nt", "<Cmd>set nu!<CR>", { desc = "toggle line number" })
map("n", "<leader>nr", "<Cmd>set rnu!<CR>", { desc = "toggle relative number" })

map("n", "<leader>mp", function()
	require("conform").format({
		lsp_fallback = true,
		async = false,
		timeout_ms = 500,
	})
end, { desc = "Format file" })
map("n", "<leader>mf", function()
	require("conform").format({ formatters = { "injected" }, timeout_ms = 1500 })
end, { desc = "Injected Formater" })

map("n", "<leader>do", "<Cmd> lua vim.diagnostic.open_float() <CR>", { desc = "Show diagnostic" })
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
-- map({ "n", "i" }, "<C-k>", "<Cmd>lua vim.lsp.buf.hover()<CR>")

nomap("n", "<leader>ma")
nomap("n", "<leader>fm")
map("n", "<leader>fm", "<Cmd>Telescope marks<CR>", { desc = "telescope find marks" })
nomap("n", "<leader>cm")
map("n", "<leader>gc", "<Cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
map("n", "<leader>gs", "<Cmd>!sh OpenApps --serie<CR>", { desc = "Open Serie" })

-- Tabs
map("n", "<leader><A-.>", "<Cmd> tabnext <CR>", { desc = "Next Tab" })
map("n", "<leader><A-,>", "<Cmd> tabprev <CR>", { desc = "Prev Tab" })
map("n", "<leader><A-c>", "<Cmd> tabnew <CR>", { desc = "New Tab" })
map("n", "<leader><A-C>", "<Cmd> tabedit % <CR>", { desc = "New Tab on file" })
map("n", "<leader><A-q>", "<Cmd> tabclose <CR>", { desc = "Close Tab" })
-- map("n", "<leader><A-l>", "<Cmd> tab <CR>", { desc = "Last Tab" })

-- Windows
map("n", "<leader>X", "<Cmd> %bd|e# <CR>", { desc = "buffer close all" })
map("n", "<leader><A-->", "<Cmd> sp <CR>", { desc = "Split window horizontally" })
map("n", "<leader><A-\\>", "<Cmd> vsp <CR>", { desc = "Split window vertically" })
map("n", "<leader><A-w>", "<C-w>q", { desc = "Close Window" })

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
map("n", "<C-e>", "<Cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })

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

map("n", "<A-=>", "<Cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })
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
map("n", "<leader>gn", "<Cmd>Neogit<CR>", { desc = "Open NeoGit" })
-- Worktree
require("telescope").load_extension("worktrees")
map(
	"n",
	"<leader>gws",
	"<Cmd>lua require('telescope').extensions.worktrees.list_worktrees(opts)<CR>",
	{ desc = "Manage Worktree" }
)
map("n", "<leader>gwb", "<Cmd>GitWorktreeCreateExisting<CR>", { desc = "Create Existing Worktree" })
map("n", "<leader>gwc", "<Cmd>GitWorktreeCreate<CR>", { desc = "Create New Worktree" })

-- Todo
map("n", "]t", function()
	require("todo-comments").jump_next()
end, { desc = "Next todo comment" })
map("n", "[t", function()
	require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })
map("n", "<leader>tdt", "<Cmd>TodoTelescope<CR>", { desc = "Telescope TODO" })
map("n", "<leader>tdl", "<Cmd>TodoLocList<CR>", { desc = "Local TODO" })
map("n", "<leader>tdg", "<Cmd>TodoQuickFix<CR>", { desc = "Global TODO" })

-- nomap("n", "<leader>tt")
-- map("n", "<leader>tt", function()
-- 	require("base46").toggle_transparency()
-- end, { desc = "Toggle transparency" })
nomap("n", "<leader>ch")
nomap("n", "<leader>th")
map("n", "<leader>tw", "<Cmd>!sh wal.sh --theme nvchad<CR>", {
	silent = true,
	desc = "Refresh Wal",
})

map("n", "tb", "<Cmd>ToggleBoolean<CR>", { desc = "Toggle Boolean String" })
map("n", "tn", "<Cmd>ToggleBinary<CR>", { desc = "Toggle Binary String" })
map("n", "<leader><A-x>", "<Cmd>!chmod +x %<CR>", { silent = true })
map("n", "gb", "<Cmd>GB<CR>", { silent = true })

-- replace template
map("n", "<leader>rs", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- centering
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map({ "n", "v" }, "<C-d>", "<C-d>zz")
map({ "n", "v" }, "<C-u>", "<C-u>zz")
map({ "n", "v" }, "}", "}zz")
map({ "n", "v" }, "{", "{zz")
map({ "n", "v" }, "''", "''zz")

-- repeatable norm command
-- https://github.com/neovim/neovim/issues/26503
local function rmap(mode, lhs, cmd)
	map(mode, lhs, function()
		local cr = vim.api.nvim_replace_termcodes("<cr>", true, false, true)
		vim.api.nvim_feedkeys(cmd .. cr, "t", false)
	end)
end
map("n", "<C-.>", "@:", { noremap = true })

--        bash'isms
--    word    ->   "word"
--   "word"   ->    word
--   {word}   ->    word
--  [ word ]  -> [[ word ]]
-- [[ word ]] -> (( word ))
rmap("n", '<leader>r"', ':exe "norm viwxi\\"\\"\\<esc>hp"') --exe treats with my custom
-- rmap("n", "<leader>r'", ':norm F"xf"x') -- use mini.surround <leader>ss"'
-- rmap("n", "<leader>r{", ":norm F{xf}x") -- use mini.surround <leader>sd{ or sdb
rmap("n", "<leader>r[", ':exe "norm vi[xi[]\\<esc>hp"') -- can also vabsa[
rmap("n", "<leader>r(", ":norm 2F[r(lr(f]r)lr)")

--- from https://github.com/linkarzu/dotfiles-latest/tree/main/neovim
-------------------------------------------------------------------------------
--                           Folding section
-------------------------------------------------------------------------------

-- Checks each line to see if it matches a markdown heading (#, ##, etc.):
-- It’s called implicitly by Neovim’s folding engine by vim.opt_local.foldexpr
function _G.markdown_foldexpr()
	local lnum = vim.v.lnum
	local line = vim.fn.getline(lnum)
	local heading = line:match("^(#+)%s")
	if heading then
		local level = #heading
		if level == 1 then
			-- Special handling for H1
			if lnum == 1 then
				return ">1"
			else
				local frontmatter_end = vim.b.frontmatter_end
				if frontmatter_end and (lnum == frontmatter_end + 1) then
					return ">1"
				end
				return ">1" -- add this fallback
			end
		elseif level >= 2 and level <= 6 then
			-- Regular handling for H2-H6
			return ">" .. level
		end
	end
	return "="
end

local function set_markdown_folding()
	vim.opt_local.foldmethod = "expr"
	vim.opt_local.foldexpr = "v:lua.markdown_foldexpr()"
	vim.opt_local.foldlevel = 99

	-- Detect frontmatter closing line
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local found_first = false
	local frontmatter_end = nil
	for i, line in ipairs(lines) do
		if line == "---" then
			if not found_first then
				found_first = true
			else
				frontmatter_end = i
				break
			end
		end
	end
	vim.b.frontmatter_end = frontmatter_end
end

-- Use autocommand to apply only to markdown files
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = set_markdown_folding,
})

-- Function to fold all headings of a specific level
local function fold_headings_of_level(level)
	-- Move to the top of the file without adding to jumplist
	vim.cmd("keepjumps normal! gg")
	-- Get the total number of lines
	local total_lines = vim.fn.line("$")
	for line = 1, total_lines do
		-- Get the content of the current line
		local line_content = vim.fn.getline(line)
		if vim.bo.filetype == "typst" then
			if line_content:match("^" .. string.rep("=", level) .. "%s") then
				-- Move the cursor to the current line without adding to jumplist
				vim.cmd(string.format("keepjumps call cursor(%d, 1)", line))
				-- Check if the current line has a fold level > 0
				local current_foldlevel = vim.fn.foldlevel(line)
				if current_foldlevel > 0 then
					-- Fold the heading if it matches the level
					if vim.fn.foldclosed(line) == -1 then
						vim.cmd("normal! za")
					end
					-- else
					--   vim.notify("No fold at line " .. line, vim.log.levels.WARN)
				end
			end
		else
			-- "^" -> Ensures the match is at the start of the line
			-- string.rep("#", level) -> Creates a string with 'level' number of "#" characters
			-- "%s" -> Matches any whitespace character after the "#" characters
			-- So this will match `## `, `### `, `#### ` for example, which are markdown headings
			if line_content:match("^" .. string.rep("#", level) .. "%s") then
				-- Move the cursor to the current line without adding to jumplist
				vim.cmd(string.format("keepjumps call cursor(%d, 1)", line))
				-- Check if the current line has a fold level > 0
				local current_foldlevel = vim.fn.foldlevel(line)
				if current_foldlevel > 0 then
					-- Fold the heading if it matches the level
					if vim.fn.foldclosed(line) == -1 then
						vim.cmd("normal! za")
					end
					-- else
					--   vim.notify("No fold at line " .. line, vim.log.levels.WARN)
				end
			end
		end
	end
end

local function fold_markdown_headings(levels)
	-- I save the view to know where to jump back after folding
	local saved_view = vim.fn.winsaveview()
	for _, level in ipairs(levels) do
		fold_headings_of_level(level)
	end
	vim.cmd("nohlsearch")
	-- Restore the view to jump to where I was
	vim.fn.winrestview(saved_view)
end

for level = 1, 4 do
	local levels = {}
	for l = 6, level, -1 do
		table.insert(levels, l)
	end
	vim.keymap.set("n", "z" .. level, function()
		vim.cmd("silent update")
		vim.cmd("normal! zX")
		vim.cmd("normal! zR")
		fold_markdown_headings(levels)
		vim.cmd("normal! zz")
	end, { desc = "[P]Fold all headings level " .. level .. " or above" })
end

map("n", "<leader>db", "<Cmd>CopyCodeBlock<CR>", { desc = "Copy code block contents" })
