-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      -- diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      diagnostics = { virtual_text = true, virtual_lines = false },
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    rooter = {
      -- list of detectors in order of prevalence, elements can be:
      --   "lsp" : lsp detection
      --   string[] : a list of directory patterns to look for
      --   fun(bufnr: integer): string|string[] : a function that takes a buffer number and outputs detected roots
      detector = {
        -- "lsp", -- needs to be disabled! Doesn't make any sense either, when looking at how it's implemented
        { ".git", "_darcs", ".hg", ".bzr", ".svn" }, -- check for a version controlled parent directory
        { "lua", "MakeFile", "package.json", "Cargo.toml" }, -- lastly check for known project root files
      },
      -- ignore things from root detection
      ignore = {
        servers = {}, -- list of language server names to ignore (Ex. { "efm" })
        dirs = { vim.fn.stdpath "data" .. "/scratch/*" }, -- list of directory patterns (Ex. { "~/.cargo/*" })
      },
      -- automatically update working directory (update manually with `:AstroRoot`)
      autochdir = true,
      -- scope of working directory to change ("global"|"tab"|"win")
      scope = "global",
      -- show notification on every working directory change
      notify = true,
    },
    --- TODO: the float should also show line locations, like virtual lines do
    diagnostics = {
      underline = true,
      virtual_text = {
        source = false,
        prefix = "● ",
      },
      update_in_insert = true,
      severity_sort = true,
      float = {
        focusable = true,
        border = "none", -- "bold" "double" "none" "rounded" "solid"
        source = false,
        header = "󰒡 Diagnostics 󰒡",
        prefix = function(d, _) return string.format(" ● (%2d-%2d) ", d.col, d.end_col), "NormalFloat" end,
        format = function(d)
          local s = d.message
          s = (s:gsub("%s*$", ""))
          s = (s:gsub("%.$", ""))
          s = (s:gsub("%s*$", ""))
          return s
        end,
        suffix = function(d)
          local s = d.source
          if not s then return "", "NormalFloat" end
          s = (s:gsub("%s*$", ""))
          s = (s:gsub("%.$", ""))
          s = (s:gsub("%s*$", ""))
          return string.format(" (%s) ", s), "NormalFloat"
        end,
      },
    },

    sessions = {
      autosave = {
        last = true, -- auto save last session
        cwd = true, -- auto save session for each working directory
      },
      -- Patterns to ignore when saving sessions
      ignore = {
        dirs = {}, -- working directories to ignore sessions in
        filetypes = { "gitcommit", "gitrebase" }, -- filetypes to ignore sessions
        buftypes = { "directory", "nofile" }, -- buffer types to ignore sessions
      },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
        autoindent = true,
        smartindent = true,
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      n = {

        -- navigate buffer tabs
        -- ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        -- ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
        [">B"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["<B"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        ["<Leader>e"] = { ":Neotree toggle left<CR>", desc = "Toggle Explorer (left)" },
        ["<Leader>o"] = { ":Neotree toggle float<CR>", desc = "Toggle Explorer (float)" },

        ["<Leader>fb"] = {
          function()
            require("snacks").picker.buffers {
              win = {
                input = {
                  keys = {
                    ["<c-x>"] = false,
                    ["<c-d>"] = { "bufdelete", mode = { "n", "i" } },
                  },
                },
              },
            }
          end,
          desc = "Find buffers (custom)",
        },

        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- INFO: pure Menu Names
        ["<Leader>ud"] = { desc = "󰒡 Diagnostics" },
        ["<Leader>T"] = { desc = "✔ TODO" },
        ["<Leader>z"] = { desc = " Under Cursor Ops" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
        ["<Leader>S."] = false, -- remapped to <Leader>SL
      },
    },
  },
}
