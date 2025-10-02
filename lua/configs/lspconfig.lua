require("nvchad.configs.lspconfig").defaults()
local nvlsp = require("nvchad.configs.lspconfig")
local lspconfig = require("lspconfig")

local map = vim.keymap.set
-- local nomap = vim.keymap.del
local custom_on_attach = function(_, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end
  map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
  map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
  map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
  map("n", "gs", vim.lsp.buf.hover, opts "Show Info")
  map("n", "gh", vim.lsp.buf.signature_help, opts "Show signature help")
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
  map("n", "<leader>wd", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")
  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts "List workspace folders")
  map("n", "gt", vim.lsp.buf.type_definition, opts "Go to type definition")
  map("n", "<leader>ra", require "nvchad.lsp.renamer", opts "NvRenamer")
  -- map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
  map("n", "<leader>ca", function()
    require("tiny-code-action").code_action()
  end, opts "Code action")
  map("i", "<A-Return>", function()
    require("tiny-code-action").code_action()
  end, opts "Code action")
  map("n", "gr", vim.lsp.buf.references, opts "Show references")
end

-- list of all servers configured.
lspconfig.servers = {
  "bashls",
  "dockerls",
}

lspconfig.bashls.setup({
  on_attach = custom_on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  cmd = { "bash-language-server", "start" }
})

lspconfig.dockerls.setup({
  on_attach = custom_on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  cmd = { "docker-langserver", "--stdio" },
})
