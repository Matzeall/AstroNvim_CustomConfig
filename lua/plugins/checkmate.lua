return {
  "bngarren/checkmate.nvim",
  ft = "markdown",
  ---@diagnostic disable: missing-fields
  opts = function()
    require "checkmate"
    local theme = require "checkmate.theme"
    local base = theme.generate_style_defaults()

    local cancelled_marker = vim.deepcopy(base.CheckmateCheckedMarker)
    cancelled_marker.fg = "#fb0165"
    local cancelled_main = vim.deepcopy(base.CheckmateCheckedMainContent)

    local in_progress_marker = vim.deepcopy(cancelled_marker)
    in_progress_marker.fg = "#57c4ff"
    local in_progress_main = vim.deepcopy(base.CheckmateUncheckedMainContent)
    in_progress_main.fg = "#94d9ff"
    in_progress_main.bold = true

    local on_hold_marker = vim.deepcopy(cancelled_marker)
    on_hold_marker.fg = "#c7a58f"
    local on_hold_main = vim.deepcopy(base.CheckmateUncheckedMainContent)
    on_hold_main.fg = "#dbc2b4"

    ---@type checkmate.Config
    return {
      enabled = true,
      notify = true,
      files = { "*.md" }, -- any .md file (instead of defaults)

      show_todo_count = true,
      todo_count_position = "eol",
      todo_count_recursive = false,

      smart_toggle = {
        enabled = true,
        check_down = "direct_children", -- How checking a parent affects children
        uncheck_down = "none", -- How unchecking a parent affects children
        check_up = "direct_children", -- When to auto-check parents
        uncheck_up = "direct_children", -- When to auto-uncheck parents
      },

      style = {
        CheckmateCancelledMarker = cancelled_marker,
        CheckmateCancelledMainContent = cancelled_main,
        CheckmateInProgressMarker = in_progress_marker,
        CheckmateInProgressMainContent = in_progress_main,
        CheckmateOnHoldMarker = on_hold_marker,
        CheckmateOnHoldMainContent = on_hold_main,
      },

      todo_states = {
        -- Built-in states (cannot change markdown or type)
        unchecked = { marker = "□" },
        checked = { marker = "✔" },

        -- Custom states
        in_progress = {
          marker = "◐",
          markdown = ".", -- Saved as `- [.]`
          type = "incomplete", -- Counts as "not done"
          order = 50,
        },
        cancelled = {
          marker = "✗",
          markdown = "c", -- Saved as `- [c]`
          type = "complete", -- Counts as "done"
          order = 2,
        },
        on_hold = {
          marker = "⏸",
          markdown = "/", -- Saved as `- [/]`
          type = "inactive", -- Ignored in counts
          order = 100,
        },
      },

      keys = {
        ["<leader>Tt"] = {
          rhs = "<cmd>Checkmate toggle<CR>",
          desc = "□/✔ Toggle todo item",
          modes = { "n", "v" },
        },
        -- duplicated, so I don't have to worry about case while typing
        ["<leader>TT"] = {
          rhs = "<cmd>Checkmate toggle<CR>",
          desc = "□/✔ Toggle todo item",
          modes = { "n", "v" },
        },
        ["<leader>TC"] = {
          rhs = "<cmd>Checkmate toggle cancelled<CR>",
          desc = "✗ Cancel Todo Item",
          modes = { "n", "v" },
        },
        ["<leader>TH"] = {
          rhs = "<cmd>Checkmate toggle on_hold<CR>",
          desc = "⏸ Set Todo Item to On_Hold",
          modes = { "n", "v" },
        },
        ["<leader>TP"] = {
          rhs = "<cmd>Checkmate toggle in_progress<CR>",
          desc = "◐ Set Todo Item to In_Progress",
          modes = { "n", "v" },
        },
        ["<leader>Tc"] = {
          rhs = "<cmd>Checkmate check<CR>",
          desc = "✔ Set todo item as checked (done)",
          modes = { "n", "v" },
        },
        ["<leader>Tu"] = {
          rhs = "<cmd>Checkmate uncheck<CR>",
          desc = "□ Set todo item as unchecked (not done)",
          modes = { "n", "v" },
        },
        ["<leader>T="] = {
          rhs = "<cmd>Checkmate cycle_next<CR>",
          desc = "Cycle todo item(s) to the next state",
          modes = { "n", "v" },
        },
        ["<leader>T-"] = {
          rhs = "<cmd>Checkmate cycle_previous<CR>",
          desc = "Cycle todo item(s) to the previous state",
          modes = { "n", "v" },
        },
        ["<leader>Tn"] = {
          rhs = "<cmd>Checkmate create<CR>",
          desc = "Create todo item",
          modes = { "n", "v" },
        },
        ["<leader>Tr"] = {
          rhs = "<cmd>Checkmate remove<CR>",
          desc = "Remove todo marker (convert to text)",
          modes = { "n", "v" },
        },
        ["<leader>TR"] = {
          rhs = "<cmd>Checkmate remove_all_metadata<CR>",
          desc = "Remove all metadata from a todo item",
          modes = { "n", "v" },
        },
        ["<leader>Ta"] = {
          rhs = "<cmd>Checkmate archive<CR>",
          desc = "Archive checked/completed todo items (move to bottom section)",
          modes = { "n" },
        },
        ["<leader>Tv"] = {
          rhs = "<cmd>Checkmate metadata select_value<CR>",
          desc = "Update the value of a metadata tag under the cursor",
          modes = { "n" },
        },
        ["<leader>T]"] = {
          rhs = "<cmd>Checkmate metadata jump_next<CR>",
          desc = "Move cursor to next metadata tag",
          modes = { "n" },
        },
        ["<leader>T["] = {
          rhs = "<cmd>Checkmate metadata jump_previous<CR>",
          desc = "Move cursor to previous metadata tag",
          modes = { "n" },
        },
      },
    }
  end,
}
