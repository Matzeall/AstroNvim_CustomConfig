-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.java" },
  { import = "astrocommunity.pack.ps1" },
  { import = "astrocommunity.pack.rust" },
  -- { import = "astrocommunity.pack.markdown" }, // prettierd error & not really necessary
  { import = "astrocommunity.markdown-and-latex.markview-nvim" },
  { import = "astrocommunity.motion.mini-move" }, -- alt +j,k line moves
  { import = "astrocommunity.recipes.picker-lsp-mappings" }, -- snacks.picker for lsp requests (references ...)
  { import = "astrocommunity.recipes.diagnostic-virtual-lines-current-line" },
  -- { import = "astrocommunity.recipes.heirline-tabline-buffer-number" }, -- doesn't work but would be cool if
  { import = "astrocommunity.recipes.heirline-nvchad-statusline" },
  { import = "astrocommunity.recipes.picker-nvchad-theme" },
  { import = "astrocommunity.recipes.neo-tree-dark" },
  { import = "astrocommunity.editing-support.cutlass-nvim" }, -- has broken counter: 1
  { import = "astrocommunity.editing-support.nvim-regexplainer" },
  { import = "astrocommunity.indent.snacks-indent-hlchunk" },
}
