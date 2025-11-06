return {
  "NStefan002/screenkey.nvim",
  lazy = false,
  version = "*",
  opts = {
    win_opts = {
      relative = "editor",
      width = 37,
      height = 1,
      border = "single",
      title = "Pressed Keys",
      style = "minimal",
    },
    compress_after = 3, -- same characters, not seconds
    clear_after = 3, -- seconds
    disable = {
      filetypes = {},
      buftypes = { "terminal" },
    },
    group_mappings = true,
  },
  config = function(_, opts)
    require("screenkey").setup(opts) -- apply non-default options
    require("screenkey").toggle() -- on by default
    vim.keymap.set("n", "<Leader>uK", "<Cmd>Screenkey toggle<CR>", { desc = "Toggle Screenkey display", silent = true })
  end,
}
