return {
  "karb94/neoscroll.nvim",
  event = "WinScrolled",
  config = function()
    require("neoscroll").setup {
      easing = "cubic",
    }
    vim.o.scrolloff = 8 -- When moving the cursor to the top or bottom of the window, it keeps 8 lines of margin, instead of letting the cursor "stick" to the window edges.
    vim.o.sidescrolloff = 14
    vim.o.scroll = 8

    local function set_fixed_scroll()
      local scroll_distance = 8

      -- set the global default
      -- silent because this can error annoyingly when buffer is smaller than scroll_distance and I don't want to check
      pcall(vim.cmd(":silent! set scroll=" .. scroll_distance))

      -- existing windows -> set the window-local option
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        pcall(vim.api.nvim_win_set_var, win, "scroll", scroll_distance)
      end
    end

    local cmd_group = vim.api.nvim_create_augroup("FixedScroll", { clear = true })
    vim.api.nvim_create_autocmd({ "VimResized", "WinResized", "VimEnter" }, {
      group = cmd_group,
      desc = "Keep 'scroll' fixed at 8 on resize and at startup",
      callback = function()
        -- schedule to run after other autocmds for the event
        vim.schedule(set_fixed_scroll)
      end,
    })
  end,
}
