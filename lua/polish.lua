-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- TODO: update which terminal is used in <leader-t-f/h/v...>

-- have buffers auto-refresh when underlying file changes (noticed at certain events)
-- TODO: implement a toggle for this, if it becomes to slow or messaging becomes annoying or I need actual tailing behaviour
vim.opt.autoread = true
vim.opt.updatetime = 2000

vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "FocusGained" }, {
  command = "checktime",
  desc = "Auto‑reload files changed on disk",
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
  pattern = "*",
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.WARN, { title = "AutoReload" })
  end,
})
