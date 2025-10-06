local lint = require("lint")

vim.api.nvim_create_autocmd({
  "BufEnter",
  "BufWritePost",
  "InsertLeave",
}, {
  callback = function()
    lint.try_lint()
  end,
})

lint.linters_by_ft = {
  lua = { "luacheck" },
  shell = { "shellcheck" },
  nix = { "nix" },
  -- python = { "flake8" },
  python = { "ruff" },
  -- golang = { "golangci-lint" },
  -- WebDev --
  -- javascript = { "eslint_d" },
  -- typescript = { "eslint_d" },
  -- DevOps --
  terraform = { "tflint" },
  dockerfile = { "hadolint" },
  ["yaml.docker-compose"] = { "dclint" }, -- custom
  helm = { "helmlint" }, -- custom
  yaml = { "kubelint" }, -- custom
}

lint.linters.luacheck.args = {
  "--globals",
  "love",
  "vim",
}

-- Function to find the Helm chart root directory
local function find_helm_chart_root(bufnr)
  local fname = vim.api.nvim_buf_get_name(bufnr)              -- Get the current buffer's file name
  local dir = vim.fn.fnamemodify(fname, ":h")                 -- Get the directory of the current file
  local root = vim.fn.finddir('Chart.yaml', dir .. ';')       -- Find the nearest Chart.yaml in parent directories
  return root ~= '' and vim.fn.fnamemodify(root, ":h") or nil -- Return the directory if found, nil otherwise
end
-- Define the parser for `helm lint`
local helm_parser = require('lint.parser').from_pattern(
  '^%[([A-Z]+)%]%s+(.-):%s+(.+)$',
  { 'severity', 'file', 'message' },
  {
    information = vim.diagnostic.severity.INFO,
    error = vim.diagnostic.severity.ERROR,
    warning = vim.diagnostic.severity.WARN,
  }
)
lint.linters.helmlint = {
  cmd = 'helm',
  stdin = false,
  append_fname = true,                           -- Automatically append the filename to args
  args_fn = function()
    local bufnr = vim.api.nvim_get_current_buf() -- Get the current buffer number
    local root = find_helm_chart_root(bufnr)     -- Find the Helm chart root directory
    if root then
      return { 'lint', root }                    -- Use the Helm chart root directory as the argument
    else
      return {}                                  -- Return an empty argument list if no Chart.yaml is found
    end
  end,
  stream = "stdout",
  ignore_exitcode = true,
  parser = helm_parser,
}

lint.linters.kubelint = {
  cmd = 'kube-linter',
  stdin = false,       -- or false if it doesn't support content input via stdin. In that case the filename is automatically added to the arguments.
  append_fname = true, -- Automatically append the file name to `args` if `stdin = false` (default: true)
  args = {
    "lint",
    "--add-all-built-in",
    -- "--output", "json",
  },                      -- list of arguments. Can contain functions with zero arguments that will be evaluated once the linter is used.
  stream = 'stdout',      -- ('stdout' | 'stderr' | 'both') configure the stream to which the linter outputs the linting result.
  ignore_exitcode = true, -- set this to true if the linter exits with a code != 0 and that's considered normal.
  parser = require('lint.parser').from_pattern(
    '([^:]+): %((.-)%) (.+) %(check: ([^,]+), remediation: (.+)%)',
    { "file", "code", "message", "check", "remediation" },
    {
      source = "kube-linter",
    }
  )
}
