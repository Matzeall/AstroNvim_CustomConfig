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

-- if those mappings get in the way of other terminals at some point
-- use term://*toggleterm#* instead
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
