-- INFO: add ctrl+backspace/delete bindings

-- Insert mode: Delete word backward (Ctrl + Backspace)
vim.keymap.set("i", "<C-BS>", "<C-w>", { desc = "Delete word backward" })

-- Insert mode: Delete word forward (Ctrl + Delete)
vim.keymap.set("i", "<C-Delete>", "<C-o>de", { desc = "Delete word forward" })

-----------------------------------------------------------------------------------------------------------
-- INFO: add the usual ctrl+shift+direction selection & ctrl+direction movement bindings

-- INSERT MODE: Leave insert & start selecting
-- Horizontal
vim.keymap.set("i", "<C-S-Right>", "<Esc>lve", { desc = "Start visual selection right" })
vim.keymap.set("i", "<C-S-Left>", "<Esc>vb", { desc = "Start visual selection left" })
vim.keymap.set("i", "<C-S-l>", "<Esc>lve", { desc = "Start visual selection right" })
vim.keymap.set("i", "<C-S-h>", "<Esc>vb", { desc = "Start visual selection left" })
-- Vertical
vim.keymap.set("i", "<C-S-Down>", "<Esc>lvj", { desc = "Start visual selection down" })
vim.keymap.set("i", "<C-S-Up>", "<Esc>vk", { desc = "Start visual selection up" })
vim.keymap.set("i", "<C-S-j>", "<Esc>lvj", { desc = "Start visual selection down" })
vim.keymap.set("i", "<C-S-k>", "<Esc>vk", { desc = "Start visual selection up" })

-- VISUAL MODE: Continue selecting
-- Horizontal
vim.keymap.set("x", "<C-S-Right>", "e", { desc = "Extend visual selection right" })
vim.keymap.set("x", "<C-S-Left>", "b", { desc = "Extend visual selection left" })
vim.keymap.set("x", "<C-S-l>", "e", { desc = "Extend visual selection right" })
vim.keymap.set("x", "<C-S-h>", "b", { desc = "Extend visual selection left" })
-- Vertical
vim.keymap.set("x", "<C-S-Down>", "j", { desc = "Extend visual selection down" })
vim.keymap.set("x", "<C-S-Up>", "k", { desc = "Extend visual selection up" })
vim.keymap.set("x", "<C-S-j>", "j", { desc = "Extend visual selection down" })
vim.keymap.set("x", "<C-S-k>", "k", { desc = "Extend visual selection up" })

-- Insert mode: Word navigation with 'e' (right) and 'b' (left) behavior
vim.keymap.set("i", "<C-Right>", "<Esc>ea", { desc = "Move right to word end" })
vim.keymap.set("i", "<C-Left>", "<Esc>bi", { desc = "Move left to word start" })
vim.keymap.set("i", "<C-l>", "<Esc>ea", { desc = "Move right to word end" })
vim.keymap.set("i", "<C-h>", "<Esc>bi", { desc = "Move left to word start" })
-- Helper to safely move vertically in insert mode without leaving it at buffer edges
local function move_insert(direction)
  local line = vim.fn.line "."
  if (direction == "j" and line < vim.fn.line "$") or (direction == "k" and line > 1) then
    return "<Esc>" .. direction .. "a"
  end
  return ""
end
-- up and down mappings
vim.keymap.set("i", "<C-j>", function() return move_insert "j" end, { expr = true, desc = "Move down" })
vim.keymap.set("i", "<C-k>", function() return move_insert "k" end, { expr = true, desc = "Move up" })
vim.keymap.set("i", "<C-Down>", function() return move_insert "j" end, { expr = true, desc = "Move down" })
vim.keymap.set("i", "<C-Up>", function() return move_insert "k" end, { expr = true, desc = "Move up" }) -----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- INFO: duplicate line or selection up or down bindings
local function duplicate_range(direction)
  local mode = vim.fn.mode()
  local s_row, e_row

  -- check if we are in any visual mode (v, V, or ctrl+v)
  if mode:match "[vV\22]" then
    s_row = vim.fn.line "v"
    e_row = vim.fn.line "."
    if s_row > e_row then
      s_row, e_row = e_row, s_row
    end
    -- exit visual mode
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", true)
  else
    s_row = vim.fn.line "."
    e_row = s_row
  end

  -- extract lines without touching registers
  local lines = vim.api.nvim_buf_get_lines(0, s_row - 1, e_row, false)

  if direction == "down" then
    vim.api.nvim_buf_set_lines(0, e_row, e_row, false, lines)
    vim.api.nvim_win_set_cursor(0, { e_row + 1, 0 })
  elseif direction == "up" then
    vim.api.nvim_buf_set_lines(0, s_row - 1, s_row - 1, false, lines)
    vim.api.nvim_win_set_cursor(0, { s_row, 0 })
  end
end

-- map for both normal and visual modes
vim.keymap.set({ "n", "x" }, "<C-M-j>", function() duplicate_range "down" end, { desc = "Duplicate range down" })
vim.keymap.set({ "n", "x" }, "<C-M-k>", function() duplicate_range "up" end, { desc = "Duplicate range up" })

-----------------------------------------------------------------------------------------------------------
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

-----------------------------------------------------------------------------------------------------------
-- INFO: remap Marks from m to M | implement gM (go Mark) as alternative to `m | implement m for matching bracket jump as alternative to %
vim.keymap.set("n", "M", "m", { noremap = true, desc = "Create Mark" })

vim.keymap.set("n", "gM", function()
  -- schedule is important, because Which-Key won't show UI list when ` is pressed as part of a keymap
  -- which makes sense, but here I want it actually, therefore let the current binding run out -> then feed ` into input
  vim.schedule(function() vim.api.nvim_feedkeys("`", "t", false) end)
end, { noremap = true, desc = "Go to Mark" })

-- mode "o" is operator-pending -> so that m also works with delete/cut operations as d% or x% would
vim.keymap.set({ "n", "x", "o" }, "m", "%", { noremap = true, desc = "matching brackets jump" })

-----------------------------------------------------------------------------------------------------------
-- INFO: allow "gd" to jump to tags in neovim help files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "help" },
  callback = function(opts) vim.keymap.set("n", "gd", "<C-]>", { silent = true, buffer = opts.buf }) end,
})

-----------------------------------------------------------------------------------------------------------
-- INFO: disable the continuation of comments through newline-commands o/O
vim.opt.formatoptions = vim.opt.formatoptions - { "o" }
vim.api.nvim_create_autocmd(
  "BufEnter",
  { callback = function() vim.opt.formatoptions = vim.opt.formatoptions - { "o" } end }
)

-----------------------------------------------------------------------------------------------------------
-- INFO: keymaps to toggle rooter behavior
vim.keymap.set(
  "n",
  "<leader>ur",
  function() require("astrocore.toggles").autochdir() end,
  { noremap = true, desc = "Toggle Auto-Rooter (during BufEnter etc.)" }
)
