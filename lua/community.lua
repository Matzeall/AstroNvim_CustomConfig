-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.java" },
  { import = "astrocommunity.pack.ps1" },
  { import = "astrocommunity.pack.bash" }, -- requires npm
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.cpp" },
  { import = "astrocommunity.pack.cmake" },
  { import = "astrocommunity.pack.markdown" }, -- requires npm
  { import = "astrocommunity.pack.typescript-all-in-one" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.motion.mini-move" }, -- alt +j,k line moves
  { import = "astrocommunity.recipes.picker-lsp-mappings" }, -- snacks.picker for lsp requests (references ...)
  -- { import = "astrocommunity.recipes.heirline-tabline-buffer-number" }, -- doesn't work but would be cool if
  { import = "astrocommunity.recipes.picker-nvchad-theme" },
  { import = "astrocommunity.recipes.neo-tree-dark" },
  { import = "astrocommunity.editing-support.nvim-regexplainer" },
  { import = "astrocommunity.code-runner.overseer-nvim" },
  { import = "astrocommunity.indent.snacks-indent-hlchunk" }, -- shows indentation scope
  { import = "astrocommunity.search.nvim-hlslens" }, -- shows additional /search information
  { import = "astrocommunity.git.neogit" },
  { import = "astrocommunity.git.diffview-nvim" },
  { import = "astrocommunity.git.gitgraph-nvim" },
  { import = "astrocommunity.debugging.nvim-dap-virtual-text" },
  { import = "astrocommunity.debugging.persistent-breakpoints-nvim" },
}
