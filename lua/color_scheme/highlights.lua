-- TODO: Customize highlights further
--  - search highlights
local M = {}

-- color palette to be re-used for multiple highlight groups
local palette = {
  bg = "#0f1117",
  fg = "#d8dee9",
  yellow = "#FFD700",
  orange = "#ffae57",
  cyan = "#7dcfe0",
  none = "NONE",
  black = "#000000",
}
-- table of highlight definitions
-- : keys = highlight group name
-- : value = table with any of { fg, bg, bold, underline, italic, nocombine, blend, ctermfg, ctermbg }
--            or link = "OtherGroup" to create a link
local highlights = {
  -- visual selection tweak
  Visual = { bg = "#383f4d", fg = palette.none },

  -- example using links
  -- CurSearch = { link = "Search" },
}

-- apply a single highlight spec
local function apply_hl(name, spec)
  if type(spec) ~= "table" then return end

  if spec.link then
    -- highlight links must be created with a command
    vim.cmd(("highlight! link %s %s"):format(name, spec.link))
    return
  end

  -- build opts table for nvim_set_hl
  local opts = {}

  if spec.fg then opts.fg = spec.fg end
  if spec.bg then opts.bg = spec.bg end
  if spec.bold then opts.bold = true end
  if spec.italic then opts.italic = true end
  if spec.underline then opts.underline = true end
  if spec.undercurl then opts.undercurl = true end
  if spec.strikethrough then opts.strikethrough = true end
  if spec.reverse then opts.reverse = true end
  if spec.nocombine ~= nil then opts.nocombine = spec.nocombine end
  if spec.blend ~= nil then opts.blend = spec.blend end
  if spec.ctermfg then opts.ctermfg = spec.ctermfg end
  if spec.ctermbg then opts.ctermbg = spec.ctermbg end
  if spec.default then opts.default = true end

  -- apply highlight (namespace 0 = global)
  pcall(vim.api.nvim_set_hl, 0, name, opts)
end

function M.apply_all(tbl)
  tbl = tbl or highlights
  for name, spec in pairs(tbl) do
    apply_hl(name, spec)
  end
end

-- apply initially
M.apply_all()

-- re-apply after colorscheme changes
vim.api.nvim_create_augroup("CustomHighlightOverrides", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  group = "CustomHighlightOverrides",
  callback = function() M.apply_all() end,
})

return M
