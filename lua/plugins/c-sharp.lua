-- requires dotnet (must be the APT version)
return {
  "GustavEikaas/easy-dotnet.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "folke/snacks.nvim" },
  config = function()
    local dotnet = require "easy-dotnet"
    dotnet.setup {
      lsp = {
        enabled = true, -- Enable builtin roslyn lsp
        roslynator_enabled = true, -- Automatically enable roslynator analyzer
        analyzer_assemblies = {}, -- Any additional roslyn analyzers you might use like SonarAnalyzer.CSharp
        config = {},
      },
      picker = "snacks",
    }

    -- INFO: KEYMAPS
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go To Definition" })
    vim.keymap.set("n", "gD", vim.lsp.buf.type_definition, { desc = "Go To Type Definition" })
    vim.keymap.set("n", "grr", require("snacks.picker").lsp_references, { desc = "LSP References" })
    vim.keymap.set("n", "gri", require("snacks.picker").lsp_implementations, { desc = "LSP Implementations" })
    vim.keymap.set("n", "gO", require("snacks.picker").lsp_symbols, { desc = "LSP Symbols (Buffer)" })
    vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "code actions" })
    vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "rename symbol" })

    -- INFO: auto-format on save (doesn't work with AstroLSP somehow)
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = { "*.cs" },
      callback = function(args)
        vim.lsp.buf.format {
          bufnr = args.buf,
          async = false,
        }
      end,
    })
  end,
}
