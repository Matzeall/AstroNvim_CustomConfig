return {
  "folke/trouble.nvim",

  ---@type trouble.Config
  opts = {
    focus = true,
    follow = true,
    auto_preview = true,
    pinned = false,
    auto_refresh = true,
    auto_open = false,
    auto_close = true,
    auto_jump = true,
    open_no_results = false,

    ---@type trouble.Window.opts
    preview = {
      type = "main",
    },

    modes = {
      diagnostics = {
        auto_close = false,
        mode = "diagnostics",
        win = { type = "split", position = "bottom", size = 12 },
        preview = { type = "split", position = "right", relative = "win", size = 0.5 },
      },
      lsp = {
        mode = "lsp",
        win = { type = "split", position = "bottom", size = 0.35 },
        preview = { type = "split", position = "right", relative = "win", size = 0.5 },
        pinned = true,
      },
      symbols = {
        mode = "lsp_document_symbols",
        win = { type = "split", relative = "win", position = "right", size = 0.3 },
        preview = { type = "main" },
        focus = true,
      },
    },
    keys = {
      -- jump and close the trouble window on Shift+Enter instead of o
      ["<c-c>"] = "jump_close",
      ["o"] = false,
      --default
      ["<c-s>"] = "jump_split",
      ["<c-v>"] = "jump_vsplit",
      -- toggle preview type
      ["T"] = {
        action = function(view)
          local trouble = require "trouble"
          -- try to get the mode for the current view
          local mode = view and view.opts and view.opts.mode
          if not mode then
            vim.notify("Trouble: couldn't determine current mode for preview-toggle", vim.log.levels.WARN)
            return
          end

          -- current preview type (fall back to "main" for safety)
          local cur_preview_type = (
            view.opts
            and view.opts.modes
            and view.opts.modes[mode].preview
            and view.opts.modes[mode].preview.type
          ) or "main"

          local split_preview = { type = "split", position = "right", relative = "win", size = 0.5 }
          local main_preview = { type = "main" }

          -- Toggle
          local new_preview = (cur_preview_type == "main") and split_preview or main_preview
          if view.opts and view.opts.modes and view.opts.modes[mode].preview then
            view.opts.modes[mode].preview = new_preview
          end
          -- TODO: implement live preview toggle
          vim.notify "NOT IMPLEMENTED YET. TODO!"
          -- vim.notify(
          --   "Toggle Preview Type -> " .. (cur_preview_type == "main" and "split_preview" or "main_win_preview")
          -- )
          -- vim.notify("current:" .. cur_preview_type .. "\n\n" .. vim.inspect(view.opts))

          trouble.open(view.opts)

          trouble.refresh(mode)
        end,
        desc = "Toggle Preview Type (main <-> right split)",
      },
    },
  },
  cmd = "Trouble",
  keys = {
    {
      "god",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "󰒡 Diagnostics (Trouble)",
    },
    {
      "goD",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "󰒡 Buffer Diagnostics (Trouble)",
    },
    {
      "gos",
      "<cmd>Trouble symbols toggle<cr>",
      desc = "󰊕 - Symbols (Trouble)",
    },
    {
      "gor",
      "<cmd>Trouble lsp toggle<cr>",
      desc = " - Definitions / References / Implementations (Trouble)",
    },
    {
      "<leader>xL",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Location List (Trouble)",
    },
    {
      "<leader>xQ",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List (Trouble)",
    },
  },
}
