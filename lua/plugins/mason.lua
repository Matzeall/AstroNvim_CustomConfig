-- Customize Mason plugins

---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = {
      -- Make sure to use the names found in `:Mason`
      ensure_installed = {
        -- install language servers
        "lua-language-server",

        -- install formatters
        "stylua",

        -- install debuggers
        -- "debugpy", -- excuse me?? why was there a python debugger enabled by default? Even the python lsp is disabled by default

        -- install any other package
        "tree-sitter-cli",
      },
    },
  },
}
-- ---@type LazySpec
-- return {
--   -- use mason-lspconfig to configure LSP installations
--   {
--     "williamboman/mason-lspconfig.nvim",
--     -- overrides `require("mason-lspconfig").setup(...)`
--     opts = {
--       ensure_installed = {
--         "lua_ls",
--         -- add more arguments for adding more language servers
--       },
--     },
--   },
--   -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
--   {
--     "jay-babu/mason-null-ls.nvim",
--     -- overrides `require("mason-null-ls").setup(...)`
--     opts = {
--       ensure_installed = {
--         "stylua",
--         -- add more arguments for adding more null-ls sources
--       },
--     },
--   },
--   {
--     "jay-babu/mason-nvim-dap.nvim",
--     -- overrides `require("mason-nvim-dap").setup(...)`
--     opts = {
--       ensure_installed = {
--         -- "python",
--         -- add more arguments for adding more debuggers
--       },
--     },
--   },
-- }
