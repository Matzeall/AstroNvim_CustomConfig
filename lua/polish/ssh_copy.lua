-- only inside ssh sessions: route yanks through OSC 52 to the local terminal
if os.getenv "SSH_TTY" then
  local function paste_from_unnamed()
    -- OSC 52 reads are unsupported by wezterm; fall back to nvim's own register
    return function() return vim.split(vim.fn.getreg '"', "\n") end
  end

  vim.g.clipboard = {
    name = "osc52-copy-only",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy "+",
      ["*"] = require("vim.ui.clipboard.osc52").copy "*",
    },
    paste = {
      ["+"] = paste_from_unnamed(),
      ["*"] = paste_from_unnamed(),
    },
  }
end
