-- INFO: nice diagnostics

-- most diagnostics settings are in AstroCore opts
-- open diagnostics float + do some other stuff from TODO
pcall(vim.keymap.del, "n", "<Leader>ld")
vim.keymap.set("n", "<Leader>ld", function()
  vim.diagnostic.open_float()

  --  TODO: research if I can just open another floating window above/below the offending line with the column information, like virtual lines do
  --  vim.api.nvim_open_win(0, false,
  -- {relative='win', row=3, col=3, width=12, height=3})
end, { noremap = true, silent = true, desc = "Hover Diagnostics (custom)" })

-- INFO: Show diagnostics under the cursor when holding position
local M = {}
M.show_diagnostics_on_hold = true

vim.api.nvim_create_augroup("lsp.diagnostics.hold", { clear = true })
vim.api.nvim_create_autocmd({ "CursorHold" }, {
  callback = function()
    if not M.show_diagnostics_on_hold then return end
    local bufnr = vim.api.nvim_get_current_buf()
    local existing_float = vim.b[bufnr].lsp_floating_preview
    if not existing_float then vim.diagnostic.open_float() end
  end,
  group = "lsp.diagnostics.hold",
})

-- INFO: setup & remap UX->Diagnostics mappings
pcall(vim.keymap.del, "n", "<leader>ud")
vim.keymap.set("n", "<leader>udc", function()
  require("astrocore.toggles").diagnostics()
  M.show_diagnostics_on_hold = false
end, { desc = "Toggle Diagnostics completely" })

vim.keymap.set("n", "<leader>udh", function()
  M.show_diagnostics_on_hold = not M.show_diagnostics_on_hold
  vim.notify("Diagnostics on hover : " .. (M.show_diagnostics_on_hold and "ON" or "OFF"))
end, { desc = "Toggle Diagnostics on hold" })

require("which-key").add({
  { "ud", group = "Diagnostics", desc = "Diagnostics" },
}, {
  prefix = "<leader>",
})
