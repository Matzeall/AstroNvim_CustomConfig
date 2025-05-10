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
  { import = "astrocommunity.motion.mini-move" },
  { import = "astrocommunity.recipes.picker-lsp-mappings" }, -- snacks.picker for lsp requests (references ...)
  { import = "astrocommunity.recipes.diagnostic-virtual-lines-current-line" },
  -- import/override with your plugins folder
}
