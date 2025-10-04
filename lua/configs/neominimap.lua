return {
  "Isrothy/neominimap.nvim",
  version = "v3.*.*",
  enabled = true,
  lazy = false, -- NOTE: NO NEED to Lazy load
  -- Optional
  keys = {
    -- Global Minimap Controls
    { "<leader>mm",  "<cmd>Neominimap Toggle<cr>",      desc = "Toggle global minimap" },
    { "<leader>mo",  "<cmd>Neominimap Enable<cr>",          desc = "Enable global minimap" },
    { "<leader>mc",  "<cmd>Neominimap Disable<cr>",         desc = "Disable global minimap" },
    { "<leader>mr",  "<cmd>Neominimap Refresh<cr>",     desc = "Refresh global minimap" },

    -- Window-Specific Minimap Controls
    { "<leader>mwt", "<cmd>Neominimap WinToggle<cr>",   desc = "Toggle minimap for current window" },
    { "<leader>mwr", "<cmd>Neominimap WinRefresh<cr>",  desc = "Refresh minimap for current window" },
    { "<leader>mwo", "<cmd>Neominimap WinEnable<cr>",       desc = "Enable minimap for current window" },
    { "<leader>mwc", "<cmd>Neominimap WinDisable<cr>",      desc = "Disable minimap for current window" },

    -- Tab-Specific Minimap Controls
    { "<leader>mtt", "<cmd>Neominimap TabToggle<cr>",   desc = "Toggle minimap for current tab" },
    { "<leader>mtr", "<cmd>Neominimap TabRefresh<cr>",  desc = "Refresh minimap for current tab" },
    { "<leader>mto", "<cmd>Neominimap TabEnable<cr>",       desc = "Enable minimap for current tab" },
    { "<leader>mtc", "<cmd>Neominimap TabDisable<cr>",      desc = "Disable minimap for current tab" },

    -- Buffer-Specific Minimap Controls
    { "<leader>mbt", "<cmd>Neominimap BufToggle<cr>",   desc = "Toggle minimap for current buffer" },
    { "<leader>mbr", "<cmd>Neominimap BufRefresh<cr>",  desc = "Refresh minimap for current buffer" },
    { "<leader>mbo", "<cmd>Neominimap BufEnable<cr>",       desc = "Enable minimap for current buffer" },
    { "<leader>mbc", "<cmd>Neominimap BufDisable<cr>",      desc = "Disable minimap for current buffer" },

    ---Focus Controls
    { "<leader>mf",  "<cmd>Neominimap Focus<cr>",       desc = "Focus on minimap" },
    { "<leader>mu",  "<cmd>Neominimap Unfocus<cr>",     desc = "Unfocus minimap" },
    { "<leader>ms",  "<cmd>Neominimap ToggleFocus<cr>", desc = "Switch focus on minimap" },
  },
  init = function()
    -- The following options are recommended when layout == "float"
    vim.opt.wrap = true
    vim.opt.sidescrolloff = 16 -- Set a large value

    --- Put your configuration here
    ---@type Neominimap.UserConfig
    vim.g.neominimap = {
      auto_enable = false,
      layout = "split",
      split = {
        minimap_width = 15, ---@type integer
        fix_width = false, ---@type boolean
        direction = "right", ---@type Neominimap.Config.SplitDirection
        close_if_last_window = false, ---@type boolean
      },
      click = {
        enabled = true, ---@type boolean
        auto_switch_focus = false, ---@type boolean
      },
      fold = {
        enabled = true, ---@type boolean
      },
    }
  end,
}
