-- INFO: have buffers auto-refresh when underlying file changes (noticed at certain events)
-- TODO: implement a toggle for this, if it becomes to slow or messaging becomes annoying or I need actual tailing behaviour
vim.opt.autoread = true
vim.opt.updatetime = 2000

vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "FocusGained" }, {
  command = "checktime", -- here are often checks like: only if not in cmd mode, but I don't see why that's necessary with my current implementation
  desc = "Auto‑reload files changed on disk",
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
  pattern = "*",
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.WARN, { title = "AutoReload" })
  end,
})
