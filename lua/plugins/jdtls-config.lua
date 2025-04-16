-- This plugin is deprecated! This is now done in the JAVA astro-community pack's init.lua file!

local function get_jdk_version(java_exec)
  -- Normalize path (especially for Windows)
  if vim.fn.has "win32" == 1 then
    java_exec = '"' .. java_exec .. '"' -- Wrap path in quotes for Windows
  end

  -- print(java_exec)

  -- Run command differently for Windows
  local version_output
  if vim.fn.has "win32" == 1 then
    version_output = vim.fn.system { "cmd.exe", "/c", java_exec, "-version" }
  else
    version_output = vim.fn.system(java_exec .. " -version 2>&1")
  end

  --local version_output = vim.fn.system(java_exec .. " -version 2>&1")
  -- print(version_output)
  -- Extract version number from output
  local version = version_output:match 'version%s+"(%d+%.?%d*)'
  if not version then
    vim.notify("⚠️ Failed to detect JDK version!", vim.log.levels.WARN)
    return nil
  end

  -- Convert major version (8, 11, 17, etc.)
  local major_version = version:match "^(%d+)"
  if tonumber(major_version) and tonumber(major_version) >= 9 then
    return "JavaSE-" .. major_version
  elseif version:find "1%.8" then
    return "JavaSE-1.8" -- Special case for Java 8
  end

  return nil
end

-- plugin override
---@type LazySpec
return {
  "mfussenegger/nvim-jdtls",
  ft = { "java" },
  opts = function()
    if true then return end
    print "JDTLS override active!! (this is deprecated, so thats a bad thing)"
    local jdtls = require "jdtls"
    vim.notify("starting jdtls with custom configuration from plugins/jdtls-config.lua", vim.log.levels.INFO)

    -- detect project root
    local root_markers = { ".git", "gradlew", "mvnw", "pom.xml", "build.gradle" }
    local root_dir = require("jdtls.setup").find_root(root_markers)

    if root_dir == nil then
      vim.notify(
        "root dir of java project not found, looking for " .. root_markers .. " ! Exiting setup...",
        vim.log.levels.ERROR
      )
      return
    end
    -- print("RootDir: " .. root_dir)

    local jdtls_files = vim.fn.expand "$MASON/share/jdtls"
    -- print("jdtls files: " .. jdtls_files)

    -- local workspace_folder = root_dir .. "/.neovim/jdtls-workspace" --does this really not work??

    local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
    local workspace_folder = vim.fn.stdpath "data" .. "/site/java/workspace-root/" .. project_name
    vim.fn.mkdir(workspace_folder, "p")
    -- print("WorkspaceFolder: " .. workspace_folder)

    local foundLauncherJar = vim.fn.glob(jdtls_files .. "/plugins/org.eclipse.equinox.launcher_*.jar")
    --print("Launcher Jar: " .. foundLauncherJar)

    --#region .neovim/jdtls_config.json
    -- Look for custom settings in project: .neovim/jdtls_config.json relative to root_dir
    local config_file = root_dir .. "/.neovim/jdtls_config.json"
    local settings = {}
    local flattened_key_detected = false
    if vim.fn.filereadable(config_file) == 1 then
      local content = vim.fn.readfile(config_file)
      if content then
        settings = vim.fn.json_decode(table.concat(content, "\n"))
        for key, _ in pairs(settings) do
          if key:find "%." then
            flattened_key_detected = true
            break
          end
        end
        if flattened_key_detected then
          vim.notify(
            "⚠️ Flattened keys detected in jdtls_config.json (not supported). Please use properly nested JSON.",
            vim.log.levels.WARN
          )
        else
          vim.notify("[jdtls] Loaded custom config from " .. config_file, vim.log.levels.INFO)
        end
      end
    else
      vim.notify("[jdtls] Custom config not found: " .. config_file, vim.log.levels.INFO)
    end
    -- print(vim.fn.json_encode(settings))
    if settings.java and settings.java.imports then
      vim.notify(
        "Using dynamic imports from config file: " .. vim.fn.json_encode(settings.java.imports),
        vim.log.levels.DEBUG
      )
    else
      vim.notify("No imports config found in jdtls_config.json; using default or empty imports.", vim.log.levels.INFO)
    end
    --#endregion .neovim/jdtls_config.json

    -- find and force usage of the correct java sdk (Java_Home needs to point to it)
    local java_home = vim.fn.expand "$JAVA_HOME"
    if java_home == "" then
      vim.notify(
        "⚠️ JAVA_HOME is not set! jdtls-config.lua tries to setup jdtls using JAVA_HOME -> LSP will not work!",
        vim.log.levels.WARN
      )
    end

    local java_exec = java_home .. "/bin/java"

    local java_name = get_jdk_version(java_exec)

    if not java_name then return end

    local extendedClientCapabilities = jdtls.extendedClientCapabilities
    extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

    -- TODO: convert big json like table format into variable format (e.g. config.init_options = ... instead of config = {init_options={ ...}, ....)
    local config = {
      cmd = {
        java_exec,
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-javaagent:" .. jdtls_files .. "/lombok.jar", --what in the hell is a lombok.jar? works either way afaik so i leave it in
        "-Xms1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
        "-jar",
        foundLauncherJar,
        "-configuration",
        jdtls_files .. "/config", -- nothing platform specific? does mason abstract that away already? Nice
        "-data",
        workspace_folder,
      },
      root_dir = root_dir,

      -- Here you can configure eclipse.jdt.ls specific settings
      -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
      -- for a list of options
      settings = {
        java = {
          signatureHelp = { enabled = true },
          configuration = {
            runtimes = {
              {
                name = java_name,
                path = java_home,
                default = true,
              },
            },
          },
        },
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
        extendedClientCapabilities = extendedClientCapabilities,
        settings = {
          java = {
            implementationsCodeLens = { enabled = true },
            imports = (settings.java and settings.java.imports) or {},
          },
        },
      },
    }

    config.on_attach = function(client, bufnr)
      print("JDTLS - On Attach (client: " .. client.name .. ")")
      -- require("me.lsp.conf").on_attach(client, bufnr, {
      --   server_side_fuzzy_completion = true,
      -- })
      if true then return end

      -- jdtls.setup_dap { hotcodereplace = "auto" }
      vim.keymap.set(
        "n",
        "<A-o>",
        jdtls.organize_imports,
        { silent = true, buffer = bufnr, desc = "organize imports (remove unused also)" }
      )

      vim.keymap.set("n", "<leader>df", jdtls.test_class, { silent = true, buffer = bufnr, desc = "test class" })

      vim.keymap.set(
        "n",
        "<leader>dn",
        jdtls.test_nearest_method,
        { silent = true, buffer = bufnr, desc = "test nearest method" }
      )

      vim.keymap.set("n", "crv", jdtls.extract_variable, { silent = true, buffer = bufnr, desc = "extract variable" })
      vim.keymap.set(
        "v",
        "crm",
        [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
        { silent = true, buffer = bufnr, desc = "extract method" }
      )
      vim.keymap.set("n", "crc", jdtls.extract_constant, { silent = true, buffer = bufnr, desc = "extract constant" })

      -- local create_command = vim.api.nvim_buf_create_user_command
      -- create_command(bufnr, "W", require("me.lsp.ext").remove_unused_imports, {
      --   nargs = 0,
      -- })
    end

    -- vim.notify(
    --   "Final dynamic imports config: " .. vim.fn.json_encode(config.init_options.settings.java.imports),
    --   vim.log.levels.DEBUG
    -- )

    -- Start or attach
    jdtls.start_or_attach(config)
  end,
}
