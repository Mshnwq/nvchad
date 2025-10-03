-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()
local nvlsp = require("nvchad.configs.lspconfig")
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

-- override for all
vim.lsp.config('*', {
  capabilities = nvlsp.capabilities,
  on_init = nvlsp.on_init,
  on_attach = custom_on_attach,
})

-- list of all servers configured.
-- https://github.com/neovim/nvim-lspconfig/tree/master/lsp
local enabled_servers = {
  "bashls",
  "nixd", -- nil_ls (rust) or nixd (c++)
  "pyright",
  -- "gopls",
  -- WebDev
  -- "svelte",
  -- "eslint",
  -- "ts_ls",
  -- DevOps
  -- "helm_ls",
  "terraformls",
  "yamlls",
  "gitlab_ci_ls",
  "docker_compose_language_service",
  "dockerls",
}
vim.lsp.enable(enabled_servers)

vim.lsp.config('yamlls', {
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
        ["https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/crds/application-crd.yaml"] =
        "*/argo/*.yaml",
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

vim.lsp.config('pyright', {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "off",
      },
    },
  },
})

-- Handeled from vim-helm plugin
-- vim.lsp.config('helm_ls', {
--   settings = {
--     ['helm-ls'] = {
--       yamlls = {
--         path = "yaml-language-server",
--       }
--     }
--   },
--   filetypes = { "yaml.helm" },
--   cmd = { "helm_ls", "serve" },
--   root_dir = function(fname)
--     return require('lspconfig.util').root_pattern("Chart.yaml")(fname)
--   end,
-- })
