local bg0 = require("gruvbox").palette.dark0

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
    GruvboxBg0 = { fg = bg0 },
    SignColumn = { bg = bg0 },
    GruvboxRedSign = { bg = bg0 },
    GruvboxYellowSign = { bg = bg0 },
    GruvboxGreenSign = { bg = bg0 },
    GruvboxAquaSign = { bg = bg0 },
    GruvboxOrangeSign = { bg = bg0 },
    GruvboxPurpleSign = { bg = bg0 },
    GruvboxBlueSign = { bg = bg0 },
    Normal = { bg = bg0 },
  },
  dim_inactive = false,
  transparent_mode = false,
}

vim.cmd "colorscheme gruvbox"
