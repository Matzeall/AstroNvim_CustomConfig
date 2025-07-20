-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here
-- INFO: change toggleterm default mappings
--
-- <C-'> -> <M-#>
for _, m in ipairs { "n", "t", "i" } do
  pcall(vim.keymap.del, m, [[<C-'>]])
end
-- as opposed to ctrl-based bindings, alt work in any terminal (ctrl is sometimes consumed with non-letter keys)
vim.keymap.set("n", "<M-#>", '<Cmd>execute v:count . "ToggleTerm"<CR>', { desc = "Toggle terminal", silent = true })
vim.keymap.set("t", "<M-#>", "<Cmd>ToggleTerm<CR>", { desc = "Toggle terminal", silent = true })
vim.keymap.set("i", "<M-#>", "<Esc><Cmd>ToggleTerm<CR>", { desc = "Toggle terminal", silent = true })

-- in-terminal motions
function _G.set_terminal_keymaps()
  vim.notify "setup terminal mappings"
  local opts = { buffer = 0 }
  vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
  -- vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
  vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end

function _G.setup_aliases(ev)
  local chan = vim.b[ev.buf].terminal_job_id
  if not chan then return end

  -- send all aliases
  local aliases = {
    "alias ll='ls -alFh'",
  }

  for _, cmd in ipairs(aliases) do
    -- add the \n so the shell executes it immediately
    vim.fn.chansend(chan, cmd .. "\n")
  end
end

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = _G.setup_aliases,
})
vim.cmd "autocmd! TermOpen term://* lua set_terminal_keymaps()"

-- INFO: on windows control which terminal is used by toggleterm
if vim.fn.has "win32" == 1 or vim.fn.has "win64" == 1 then
  local shell = "bash" -- bash directly from PATH
  local shell_candidate_cmdflags = "--login -i -c" -- flags for bash only

  if vim.fn.executable(shell) == 0 then
    -- hunt through file system for git bash binary
    local function search_fs_for_bash()
      local shell_candidate = "C:/DevTools/Git/bin/bash.exe" -- initial guess based on my machine
      if vim.fn.executable(shell_candidate) == 1 then return shell_candidate end

      -- next look for git in PATH and check in it's bin dir
      local git_path = vim.fn.exepath "git"
      if git_path ~= "" then
        local git_root = vim.fn.fnamemodify(git_path, ":h:h") -- strip away /cmd/git.exe and look in /bin and /usr/bin directories
        if vim.fn.executable(git_root .. "\\bin\\bash.exe") then return git_root .. "\\bin\\bash.exe" end
        if vim.fn.executable(git_root .. "\\usr\\bin\\bash.exe") then return git_root .. "\\usr\\bin\\bash.exe" end
      end
      return "" -- nothing found
    end

    shell = search_fs_for_bash():gsub("\\", "/") -- search fs for bash.exe + convert to unix path
    -- vim.notify(shell)
  end

  -- when bash is not installed or could not be resolved, fallback to pwsh or powershell
  if vim.fn.executable(shell) == 0 then
    shell = (vim.fn.executable "pwsh" == 1) and "pwsh" or "powershell"
    shell_candidate_cmdflags =
      "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
  end

  local bash_options = {
    shell = shell,
    shellcmdflag = shell_candidate_cmdflags,
    shellredir = "",
    shellpipe = "2>&1",
    shellquote = "",
    shellxquote = "",
  }
  for option, value in pairs(bash_options) do
    vim.o[option] = value
  end
  -- vim.o.shell = "bash"
  -- vim.o.shellcmdflag = "-s"
end

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

-- INFO: Screenkey plugin
vim.keymap.set("n", "<Leader>uK", "<Cmd>Screenkey toggle<CR>", { desc = "Toggle Screenkey display", silent = true })
require("screenkey").setup {
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
}
require("screenkey").toggle() -- on by default
