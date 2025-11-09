local M = {}

M.pywal = {
  -- start replace from rice
  hl_override = {
    St_NormalMode = { bg = "#5E678F" },
    St_NormalModeSep = { fg = "#5E678F", bg = "#0d0d1f" },
    St_InsertMode = { bg = "#8891B8" },
    St_InsertModeSep = { fg = "#8891B8", bg = "#0d0d1f" },
    St_VisualMode = { bg = "#535870" },
    St_VisualModeSep = { fg = "#535870", bg = "#0d0d1f" },
    St_CommandMode = { bg = "#5B648C" },
    St_CommandModeSep = { fg = "#5B648C", bg = "#0d0d1f" },
    St_TerminalMode = { bg = "#666F97" },
    St_TerminalModeSep = { fg = "#666F97", bg = "#0d0d1f" },
    St_NTerminalMode = { bg = "#666F97" },
    St_NTerminalModeSep = { fg = "#666F97", bg = "#0d0d1f" },
    St_EmptySpace = { fg = "#5E678F", bg = "#0d0d1f" },
    St_file = { fg = "#0d0d1f", bg = "#5c5c71" },
    St_file_sep = { fg = "#5c5c71" },
    St_pos_icon = { fg = "#0d0d1f", bg = "#5E678F" },
    St_pos_sep = { fg = "#5E678F", bg = "none" },
    St_pos_text = { fg = "#0d0d1f", bg = "#5c5c71" },
    St_Lsp = { fg = "#5E678F" },
    St_LspMsg = { fg = "#5E678F" },
    TbTabOn = { fg = "#5E678F", bg = "#5c5c71" },
    TbTabOff = { fg = "#0d0d1f", bg = "#5c5c71" },
  },
  hl_add = {
    St_Lint = { fg = "#5B648C", bg = "none" },
    NotifyINFOIcon = { fg = "green" },
    NotifyINFOTitle = { fg = "green" },
    NotifyINFOBorder = { fg = "grey_fg" },
    NotifyERRORIcon = { fg = "red" },
    NotifyERRORTitle = { fg = "red" },
    NotifyERRORBorder = { fg = "grey_fg" },
    NotifyWARNIcon = { fg = "yellow" },
    NotifyWARNTitle = { fg = "yellow" },
    NotifyWARNBorder = { fg = "grey_fg" },
    TodoError = { fg = "red" },
    TodoWarn = { fg = "red" },
    TodoInfo = { fg = "yellow" },
    TodoHint = { fg = "green" },
    TodoTest = { fg = "cyan" },
    TodoDefault = { fg = "grey_fg" },
  },
  -- end replace from rice
}

return M
