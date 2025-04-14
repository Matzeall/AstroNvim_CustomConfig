return {
  "karb94/neoscroll.nvim",
  event = "WinScrolled",
  config = function()
    require("neoscroll").setup {
      easing = "cubic",
    }
    vim.o.scrolloff = 8 -- When you move your cursor to the top or bottom of the window, it keeps 8 lines of margin, instead of letting the cursor "stick" to the window edges.
  end,
}
