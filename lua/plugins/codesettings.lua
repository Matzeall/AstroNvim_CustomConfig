return {
  'mrjones2014/codesettings.nvim',
  -- You don't need to lazy load this plugin since it already
  -- lazy loads its constituent parts via `plugin/*` and `ftplugin/*` files
  lazy = false,
  -- these are the default settings just set `opts = {}` to use defaults
  opts = {
    --- Look for these config files
    config_file_paths = { '.vscode/settings.json', 'codesettings.json', 'lspsettings.json' },
    --- Set filetype to jsonc when opening a file specified by `config_file_paths`,
    --- make sure you have the json tree-sitter parser installed for highlighting
    jsonc_filetype = true,
    --- Integrate with jsonls to provide LSP completion for LSP settings based on schemas
    jsonls_integration = true,
    --- Enable live reloading of settings when config files change
    --- via the `workspace/didChangeConfiguration` notification; after notifying,
    --- an autocmd `User CodesettingsFilesChanged` will be emitted. You
    --- can use this autocmd to handle edge cases like restarting servers
    --- that don't respond to `workspace/didChangeConfiguration` by
    --- restarting it.
    live_reload = false,
    --- List of loader extensions to use when loading settings; `string` values will be `require`d
    loader_extensions = { 'codesettings.extensions.vscode' },
    --- Set up library paths for `lua_ls` automatically to pick up the generated type
    --- annotations provided by codesettings.nvim; to enable for only your nvim config,
    --- you can also do something like:
    --- lua_ls_integration = function()
    ---   return vim.uv.cwd() == ('%s/.config/nvim'):format(vim.env.HOME)
    --- end,
    --- This integration also works for emmylua_ls
    lua_ls_integration = true,
    --- How to merge lists; 'append' (default), 'prepend' or 'replace'
    merge_lists = 'append',
    --- Controls placeholder string substitution in LSP schema descriptions.
    --- - true (default): use bundled English NLS files
    --- - false: disable substitution (raw placeholders visible)
    --- - string: path to a directory of per-LSP NLS JSON files (e.g. "/path/to/dir" containing jsonls.nls.json, lua_ls.nls.json, etc.)
    --- - table: flat `{ ["key"] = "value" }` NLS table applied to all LSPs
    --- - function(lsp_name) -> table: per-LSP resolver
    --- Note that only certain schemas support this, see the bundled *.nls.json files at
    --- ./after/codesettings-nls/*.nls.json
    nls = true,
    --- Provide your own root dir; can be a string or function returning a string.
    --- It should be/return the full absolute path to the root directory.
    --- If not set, defaults to `require('codesettings.util').get_root()`
    root_dir = nil,
  },
}
