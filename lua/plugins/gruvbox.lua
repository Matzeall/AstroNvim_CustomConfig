return {
  "ellisonleao/gruvbox.nvim",
  lazy = false, -- immediately load and execute config

  config = function()
    local bg_black = require("gruvbox").palette.dark0_hard
    local bg_dark0 = require("gruvbox").palette.dark0
    local bg_dark1 = require("gruvbox").palette.dark1
    local bg_dark2 = require("gruvbox").palette.dark2
    local fg_yellow = require("gruvbox").palette.neutral_yellow

    require("gruvbox").setup {
      terminal_colors = true, -- add neovim terminal colors
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = true,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      inverse = true, -- invert background for search, diffs, statuslines and errors
      contrast = "", -- can be "hard", "soft" or empty string
      palette_overrides = {},
      overrides = {
        Normal = { bg = bg_dark0 },
        GruvboxBg0 = { fg = bg_dark0 },
        FoldColumn = { bg = bg_dark0 },
        CursorLineFold = { fg = fg_yellow },
        SignColumn = { bg = bg_dark0 },
        CursorLineSign = { bg = bg_dark1 },
        GruvboxRedSign = { bg = bg_dark0 },
        GruvboxYellowSign = { bg = bg_dark0 },
        GruvboxGreenSign = { bg = bg_dark0 },
        GruvboxAquaSign = { bg = bg_dark0 },
        GruvboxOrangeSign = { bg = bg_dark0 },
        GruvboxPurpleSign = { bg = bg_dark0 },
        GruvboxBlueSign = { bg = bg_dark0 },
        StatusLine = { bg = bg_black },
        WinBarNC = { bg = bg_dark0 },
        Visual = { bg = bg_dark2 },
      },
      dim_inactive = false,
      transparent_mode = false,
    }

    vim.cmd "colorscheme gruvbox"
  end,
}
