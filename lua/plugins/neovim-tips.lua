return {
  "saxon1964/neovim-tips",
  version = "*", -- Only update on tagged releases
  lazy = false, -- Load only when keybinds are triggered
  dependencies = {
    "MunifTanjim/nui.nvim",
    "MeanderingProgrammer/render-markdown.nvim", -- Clean rendering
  },
  opts = {
    -- OPTIONAL: Daily tip mode (default: 1)
    -- Note: Set to 0 when using lazy = true, or use Option 2 below
    daily_tip = 1, -- 0 = off, 1 = once per day, 2 = every startup
    bookmark_symbol = "🌟 ",
    show_daily_tip_footer = false,
  },
  keys = {
    { "<leader><a-t>", "", desc = "󰌵 Neovim Tips" },
    { "<leader><a-t>o", ":NeovimTips<CR>", desc = "Neovim tips" },
    { "<leader><a-t>r", ":NeovimTipsRandom<CR>", desc = "Show random tip" },
    { "<leader><a-t>e", ":NeovimTipsEdit<CR>", desc = "Edit your tips" },
    { "<leader><a-t>a", ":NeovimTipsAdd<CR>", desc = "Add your tip" },
    { "<leader><a-t>p", ":NeovimTipsPdf<CR>", desc = "Open tips PDF" },
  },
}
