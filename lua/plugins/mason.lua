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
        "prettierd",

        -- install debuggers
        -- "debugpy", -- excuse me?? why was there a python debugger enabled by default? Even the python lsp is disabled by default

        -- install any other package
        "tree-sitter-cli",
      },
    },
  },
}
