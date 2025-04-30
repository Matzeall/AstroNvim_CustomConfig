-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.java" },
  { import = "astrocommunity.pack.ps1" },
  { import = "astrocommunity.motion.mini-move" },
  { import = "astrocommunity.recipes.picker-lsp-mappings" },
  -- import/override with your plugins folder
}
