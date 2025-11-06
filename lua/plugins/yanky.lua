local function map_for_modes(modes, tbl)
  local out = {}
  for _, m in ipairs(modes) do
    out[m] = vim.deepcopy(tbl)
  end
  return out
end

local yanky_picker_opts = {
  on_show = function()
    vim.schedule(function()
      -- start in normal mode instead of insert
      local key = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
      vim.api.nvim_feedkeys(key, "n", false)
    end)
  end,
  actions = {
    promote = function(picker)
      require "yanky.picker"
      local utils = require "yanky.utils"
      local history = require "yanky.history"

      picker:close()
      local reg = utils.get_default_register()
      local current = picker:current()
      local cur_index = current["key"]

      require("yanky.picker").actions.set_register(reg)(current)

      local item = history.storage.get(cur_index)
      history.delete(cur_index)
      history.push(item)
    end,
    clear_yank_history = function(picker)
      vim.cmd ":YankyClearHistory"
      vim.notify "Cleared Yank History"
      picker:find()
    end,
    put_before = function(picker)
      picker:close()
      require("yanky.picker").actions.put("P", false)(picker:current())
    end,
  },
  win = {
    input = {
      keys = {
        ["<c-x>"] = false,
        ["<c-y>"] = {
          "promote",
          mode = { "n", "i" },
          desc = "Move to front of history + yank",
        },
        ["<c-d>"] = { "delete", mode = { "n", "i" }, desc = "Delete selected" },
        ["<c-p>"] = {
          "put_before",
          mode = { "n", "i" },
          desc = "Select & put before",
        },
        ["<a-d>"] = {
          "clear_yank_history",
          mode = { "n", "i" },
          desc = "Clear Yank History",
        },
      },
    },
  },
}

-- local is_windows = jit.os:find "Windows"

-- actual plugin
return {
  "gbprod/yanky.nvim",
  dependencies = {
    -- { "kkharji/sqlite.lua", enabled = not is_windows },
    { "folke/snacks.nvim" },
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            ["<Leader>fy"] = { "<Cmd>YankyRingHistory<CR>", desc = "Find yanks" },
            ["y"] = { "<Plug>(YankyYank)", desc = "Yank text" },
            ["p"] = { "<Plug>(YankyPutAfter)", desc = "Put yanked text after cursor" },
            ["P"] = { "<Plug>(YankyPutBefore)", desc = "Put yanked text before cursor" },
            ["gp"] = { "<Plug>(YankyGPutAfter)", desc = "Put yanked text after selection" },
            ["gP"] = { "<Plug>(YankyGPutBefore)", desc = "Put yanked text before selection" },
            ["<c-p>"] = { "<Plug>(YankyCycleForward)", desc = "Cycle forward through yank history" },
            ["<c-n>"] = { "<Plug>(YankyCycleBackward)", desc = "Cycle backward through yank history" },
          },
          x = {
            ["y"] = { "<Plug>(YankyYank)", desc = "Yank text" },
            -- Put After doesn't make sense here, because of the "_d prefix, the cursor is at a different location afterwards than before
            -- and since it replaces the visual selection anyway completely, there is no difference anyway, right 0.o?
            -- I will map both to the same option, so I can still use the mappings with p or P
            -- ["p"] = { '"_d<Plug>(YankyPutAfter)', desc = "Put yanked text after cursor" },
            ["p"] = { '"_d<Plug>(YankyPutBefore)', desc = "Put yanked text after cursor" },
            ["P"] = { '"_d<Plug>(YankyPutBefore)', desc = "Put yanked text before cursor" },
            -- ["gp"] = { '"_d<Plug>(YankyGPutAfter)', desc = "Put yanked text after selection" },
            ["gp"] = { '"_d<Plug>(YankyGPutBefore)', desc = "Put yanked text after selection" },
            ["gP"] = { '"_d<Plug>(YankyGPutBefore)', desc = "Put yanked text before selection" },
          },
        },
      },
    },
  },
  opts = function(_, opts)
    local astrocore = require "astrocore"
    opts = astrocore.extend_tbl(opts, {
      ring = {
        history_length = 100,
        storage = "shada",
        -- storage_path = vim.fn.stdpath "data" .. "/databases/yanky.db", -- Only for sqlite storage
        sync_with_numbered_registers = true,
        cancel_event = "update",
        ignore_registers = { "_", "s", "d", "c" }, -- important to synergyze with cutlass.nvim
        update_register_on_cycle = false,
        permanent_wrapper = nil,
      },
      picker = {
        select = {
          action = nil, -- nil to use default put action
        },
      },
      system_clipboard = {
        sync_with_ring = true,
        clipboard_register = nil,
      },
      highlight = {
        on_put = true,
        on_yank = true,
        timer = 180,
      },
      preserve_cursor_position = {
        enabled = true,
      },
      textobj = {
        enabled = false,
      },
    })
    return opts
  end,
  specs = {
    {
      "folke/snacks.nvim",
      optional = true,
      specs = {
        {
          "AstroNvim/astrocore",
          opts = {
            mappings = map_for_modes({ "n", "x" }, {
              ["<Leader>fy"] = {
                function() require("snacks").picker.yanky(yanky_picker_opts) end,
                desc = "Find yanks",
              },
            }),
          },
        },
      },
    },
  },
}
