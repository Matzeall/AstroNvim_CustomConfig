---@type LazySpec
return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  keys = {
    {
      "<leader>.",
      function()
        local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        local data = vim.fn.stdpath "data"
        local scratch_root = data .. "/scratch/" .. project_name
        vim.fn.mkdir(scratch_root, "p")

        local extension = "md"
        if vim.bo.buftype == "" and vim.bo.filetype ~= "" then extension = vim.bo.filetype end
        if extension == "markdown" then extension = "md" end

        local filename = "Scratch." .. extension
        local file_path = scratch_root .. "/" .. filename

        ---@diagnostic disable-next-line: missing-fields
        Snacks.scratch.open {
          name = filename,
          ft = extension,
          file = file_path,
        }
      end,
      desc = "Toggle Scratch Buffer",
    },
    {
      "<leader>T.",
      function()
        local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        local data = vim.fn.stdpath "data"
        local scratch_root = data .. "/scratch/" .. project_name
        vim.fn.mkdir(scratch_root, "p")
        local filename = "TODO.md"
        local file = scratch_root .. "/" .. filename

        ---@diagnostic disable-next-line: missing-fields
        Snacks.scratch.open {
          name = filename,
          ft = "markdown",
          file = file,
        }
      end,
      desc = "Toggle Scratch TODO.md",
    },
    { "<leader>s", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    { "<leader>N", function() Snacks.picker.notifications() end, desc = "Notification History" },
    {
      "<leader>fk",
      function()
        require("snacks").picker.keymaps {
          actions = {
            confirm = function(picker, item)
              picker:close()

              -- try several common field names for the file/line
              local file = item.file or item.filename or item.path
              local line = item.line
                or item.lnum
                or (item.pos and item.pos[1])
                or (item.range and (item.range.start and item.range.start.line and item.range.start.line + 1))

              if file then
                line = tonumber(line) or 1
                -- open in current window at exact line
                vim.cmd(string.format("edit +%d %s", line, vim.fn.fnameescape(file)))
              else
                vim.notify("Snacks: no file info for this keymap", vim.log.levels.WARN)
              end
            end,
          },
        }
      end,
      desc = "Find keymaps + source files",
    },
  },

  opts = {
    dashboard = {
      -- customize dashboard options
      preset = {
        keys = {
          { key = "n", action = "<Leader>n", icon = "", desc = "New File  " },
          { key = "f", action = "<Leader>ff", icon = "", desc = "Find File  " },
          { key = "w", action = "<Leader>fw", icon = "", desc = "Find Word  " },
          { key = "'", action = "<Leader>f'", icon = "󰈙", desc = "Bookmarks  " },
          { key = "s", action = "<Leader>Sl", icon = "󰑐", desc = "Last Session  " },
          { key = "S", action = "<Leader>SL", icon = "󰑐", desc = "Last Directory Session  " },
          { key = "L", action = ":Leet", icon = "󰙏", desc = "Start LeetCode" },
        },

        header = table.concat({
          " █████  ███████ ████████ ██████   ██████ ",
          "██   ██ ██         ██    ██   ██ ██    ██",
          "███████ ███████    ██    ██████  ██    ██",
          "██   ██      ██    ██    ██   ██ ██    ██",
          "██   ██ ███████    ██    ██   ██  ██████ ",
          "",
          "███    ██ ██    ██ ██ ███    ███",
          "████   ██ ██    ██ ██ ████  ████",
          "██ ██  ██ ██    ██ ██ ██ ████ ██",
          "██  ██ ██  ██  ██  ██ ██  ██  ██",
          "██   ████   ████   ██ ██      ██",
          "                     Config by Matthias Allner",
        }, "\n"),
      },
    },

    scratch = {
      autowrite = true,
      ft = function()
        if vim.bo.buftype == "" and vim.bo.filetype ~= "" then return vim.bo.filetype end
        return "markdown"
      end,
      win = {
        border = "solid",
        width = 100,
        height = 32,
        -- this is important because it influences wheather many plugins work/notice this buffer
        bo = { buftype = "", buflisted = true, bufhidden = "hide", swapfile = false },
        minimal = false,
        noautocmd = false,
        zindex = 20,
        wo = { winhighlight = "NormalFloat:Normal" },
        enter = true,
        footer_keys = true,
        -- this is important, because otherwise checkmate and potentially others might not notice the scratch buffer
        on_win = function(win)
          if win.buf then
            vim.notify("Filetype: " .. vim.bo[win.buf].filetype)
            vim.cmd(string.format("doautocmd FileType %s", vim.bo[win.buf].filetype))
          end
        end,
        on_close = function(win)
          vim.notify("Saving scratch-buffer (" .. win.buf .. ")")
          vim.api.nvim_buf_call(win.buf, function()
            vim.cmd "silent! write"
            vim.bo[win.buf].buflisted = false
          end)
        end,
      },
    },

    picker = {},
  },
}
