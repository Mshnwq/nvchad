require "nvchad.mappings"

-- <tab>
-- <S-tab>
-- <A-tab>

local map = vim.keymap.set
local nomap = vim.keymap.del

vim.api.nvim_set_keymap("n", "S", "A", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "A", "I", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "s", "a", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "a", "i", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "E", "W", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "e", "w", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "W", "B", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "w", "b", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "E", "W", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "e", "w", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "W", "B", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "w", "b", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "J", "L", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "J", "L", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "K", "H", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "K", "H", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "L", "$", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "L", "$", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "H", "^", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "H", "^", { noremap = true, silent = true })


map("n", ";", ":", { desc = "CMD enter command mode" })

map("n", "<A-k>", "<cmd>t-1<CR>")
map("n", "<A-j>", "<cmd>t.<CR>")

map({ "n", "i" }, "<C-x>", "<cmd>d<CR>")

nomap("n", "<leader>n")
nomap("n", "<leader>rn")
map("n", "<leader>nn", "<cmd>set nu!<CR>", { desc = "toggle line number" })
map("n", "<leader>nr", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })
