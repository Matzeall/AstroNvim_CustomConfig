-- INFO: fix for "load last session" not focusing any buffer sometimes
-- INFO: also toggles astrocore-rooter to prevent unessessary switching during session loading
local resession = require "resession"

-- INFO: session loading
local rooter_config = require("astrocore").config.rooter
local rooter_was_enabled = rooter_config and rooter_config.autochdir or false

resession.add_hook("pre_load", function()
  -- disable astrocore-rooter during load
  rooter_was_enabled = rooter_config and rooter_config.autochdir or false
  if rooter_was_enabled then require("astrocore.toggles").autochdir(true) end -- turn rooter off
end)

resession.add_hook("post_load", function()
  local cur_buf = vim.api.nvim_get_current_buf()
  local cur_buf_name = vim.api.nvim_buf_get_name(cur_buf)
  local cur_session_info = resession.get_current_session_info()

  -- no buf_name? -> something mustv went wrong, load last buffer manually and call :buffer {name} if last session info is available
  if cur_buf_name == "" and cur_session_info then
    local util = require "resession.util"
    local filename = util.get_session_file(cur_session_info.name, cur_session_info.dir)
    local data = require("resession.files").load_json_file(filename)
    if data and data.astrocore and data.astrocore.bufnrs then
      local new_buf_name = ""
      if data.astrocore.last_buf then
        for path, buf_nr in pairs(data.astrocore.bufnrs) do
          -- if buf_nr == data.astrocore.current_buf then new_buf_name = vim.fn.fnamemodify(path, ":t") end
          if buf_nr == data.astrocore.last_buf then new_buf_name = path end
        end
      end

      if new_buf_name == "" then
        vim.notify("last_buf not found in session file", vim.log.levels.ERROR)
      else
        vim.notify("fixed session bug -> last_buf set to " .. new_buf_name, vim.log.levels.DEBUG)
      end

      local buffer_command = "buffer " .. new_buf_name
      vim.defer_fn(function() vim.cmd(buffer_command) end, 300)
    end
  end

  vim.defer_fn(function()
    if rooter_config and (rooter_was_enabled and not rooter_config.autochdir) then
      require("astrocore.toggles").autochdir(true) -- turn rooter back on, if it was on
      -- require("astrocore.rooter").root(vim.api.nvim_get_current_buf())
    end
  end, 500)
end)

-- INFO: Session saving

vim.keymap.set(
  "n",
  "<leader>SL",
  function() resession.load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true }) end,
  { noremap = true, desc = "Load last dirsession" }
)
