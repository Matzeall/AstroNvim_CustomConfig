-- INFO: Mapping to toggle jumps with w, e, b etc. over/stopping at '_'
local function toggle_underscore_iskeyword_global()
  local ik = vim.o.iskeyword or ""
  local has = false
  for token in string.gmatch(ik, "([^,]+)") do
    if token == "_" then
      has = true
      break
    end
  end

  if has then
    vim.opt.iskeyword:remove "_"
    vim.notify("enabled _ jumps", vim.log.levels.INFO)
  else
    vim.opt.iskeyword:append "_"
    vim.notify("disabled _ jumps", vim.log.levels.INFO)
  end
end

vim.keymap.set("n", "<Leader>u_", toggle_underscore_iskeyword_global, { desc = "Toggle _ jumps", silent = true })

-- INFO: remap Marks from m to M | implement gM (go Mark) as alternative to `m | implement m for matching bracket jump as alternative to %
vim.keymap.set("n", "M", "m", { noremap = true, desc = "Create Mark" })

vim.keymap.set("n", "gM", function()
  -- schedule is important, because Which-Key won't show UI list when ` is pressed as part of a keymap
  -- which makes sense, but here I want it actually, therefore let the current binding run out -> then feed ` into input
  vim.schedule(function() vim.api.nvim_feedkeys("`", "t", false) end)
end, { noremap = true, desc = "Go to Mark" })

-- mode "o" is operator-pending -> so that m also works with delete/cut operations as d% or x% would
vim.keymap.set({ "n", "x", "o" }, "m", "%", { noremap = true, desc = "matching brackets jump" })

-- INFO: allow "gd" to jump to tags in neovim help files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "help" },
  callback = function(opts) vim.keymap.set("n", "gd", "<C-]>", { silent = true, buffer = opts.buf }) end,
})

-- INFO: disable the continuation of comments through newline-commands o/O
vim.api.nvim_create_autocmd(
  "BufEnter",
  { callback = function() vim.opt.formatoptions = vim.opt.formatoptions - { "o" } end }
)

-- INFO: keymaps to toggle rooter behavior
vim.keymap.set(
  "n",
  "<leader>ur",
  function() require("astrocore.toggles").autochdir() end,
  { noremap = true, desc = "Toggle Auto-Rooter (during BufEnter etc.)" }
)
