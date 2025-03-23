-- lua/plugins/jdtls-config.lua
---@type function
local M = {}

function M.start_jdtls()
  local jdtls = require "jdtls"

  print "start jdtls with custom configuration from plugins/jdtls-config.lua"

  -- Optionally detect project root
  local root_markers = { ".git", "gradlew", "mvnw", "pom.xml", "build.gradle" }
  local root_dir = require("jdtls.setup").find_root(root_markers)
  if root_dir == nil then
    print "root dir of java project not found! Exiting setup..."
    return
  end

  local jdtls_files = vim.fn.expand "$MASON/share/jdtls"
  print("jdtls files: " .. jdtls_files)

  -- Load workspace settings file if you have one
  --local workspace_folder = root_dir .. "/.neovim/jdtls-workspace" --does this really not work??

  local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
  local workspace_folder = vim.fn.stdpath "data" .. "/site/java/workspace-root/" .. project_name
  vim.fn.mkdir(workspace_folder, "p")
  --print("WorkspaceFolder: " .. workspace_folder)

  local foundLauncherJar = vim.fn.glob(jdtls_files .. "/plugins/org.eclipse.equinox.launcher_*.jar")
  --print("Launcher Jar: " .. foundLauncherJar)

  -- Look for custom settings in project: .neovim/jdtls_config.json relative to root_dir
  local config_file = root_dir .. "/.neovim/jdtls_config.json"
  local settings = {}
  if vim.fn.filereadable(config_file) == 1 then
    local content = vim.fn.readfile(config_file)
    if content then
      settings = vim.fn.json_decode(table.concat(content, "\n"))
      vim.notify("[jdtls] Loaded custom config from " .. config_file, vim.log.levels.INFO)
    end
  else
    vim.notify("[jdtls] Custom config not found: " .. config_file, vim.log.levels.INFO)
  end
  
  if settings.java and settings.java.imports then
    print("Using dynamic imports from config file: " .. vim.fn.json_encode(settings.java.imports))
  else
    print("No imports config found in jdtls_config.json; using default or empty imports.")
  end

  local config = {
    cmd = {
      "java",
      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=true",
      "-Dlog.level=ALL",
      --"-javaagent:" .. jdtls_files .. "/lombok.jar",
      "-Xms1g",
      "--add-modules=ALL-SYSTEM",
      "--add-opens",
      "java.base/java.util=ALL-UNNAMED",
      "--add-opens",
      "java.base/java.lang=ALL-UNNAMED",
      "-jar",
      foundLauncherJar,
      "-configuration",
      jdtls_files .. "/config", -- for Windows
      "-data",
      workspace_folder,
    },
    root_dir = root_dir,

    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a list of options
    settings = {
      java = {},
    },
    -- Language server `initializationOptions`
    -- You need to extend the `bundles` with paths to jar files
    -- if you want to use additional eclipse.jdt.ls plugins.
    --
    -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
    --
    -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
      init_options = {
      bundles = {},
      settings = {
        java = {
          implementationsCodeLens = { enabled = true },
          imports = (settings.java and settings.java.imports) or {},
        },
      },
    },
  }

  print("Final dynamic imports config:")
  print(vim.fn.json_encode(config.init_options.settings.java.imports))
  -- Start or attach
  jdtls.start_or_attach(config)
end

return M

--https://github.com/exosyphon/nvim/blob/0aa48126c7f35f2009c5a695860a53c8a450485f/ftplugin/java.lua

-- gradle = {
--             enabled = true,
--              wrapper = {
--                enabled = true,
--                checksums = {
--                  {
--                    sha256 = "81a82aaea5abcc8ff68b3dfcb58b3c3c429378efd98e7433460610fecd7ae45f",
--                    allowed = true,
--                  },
--                },
 --             },
  --          },