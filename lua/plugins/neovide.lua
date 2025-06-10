return {
  { import = "astrocommunity.recipes.neovide" },

  {
    "AstroNvim/astrocore",
    opts = function(plugin, opts)
      local utils = require "astrocore"

      if vim.g.neovide then
        return utils.extend_tbl(opts, {
          options = {
            opt = { -- configure vim.opt options
              -- configure font
              guifont = "IosevkaTermSlabNFM Nerd Font:h14", -- TODO: package font with repo
              -- line spacing
              linespace = 0,
            },
            g = {
              neovide_remember_window_size = true,
              neovide_refresh_rate_idle = 5,
              neovide_padding_top = 20,
              -- neovide_cursor_vfx_mode = "railgun",
            },
          },
          mappings = {
            n = {
              ["<C-+>"] = {
                function() vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1 end, -- TODO: improve with functionality from astrocommunity.recipes.neovide init.lua
                desc = "Zoom In",
              },
              ["<C-->"] = {
                function() vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1 end,
                desc = "Zoom Out",
              }, -- TODO: add binding for pasting in insert mode, command mode and whatever I need to paste into fuzzy finders or neoexplorer->newfile
            },
          },
        })
      end

      return opts
    end,
  },
}
