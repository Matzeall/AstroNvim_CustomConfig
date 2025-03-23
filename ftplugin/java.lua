-- ftplugin/java.lua
print("Java filetype handling started ...")

local status_ok, jdtls_config = pcall(require, "plugins.jdtls-config")
if status_ok then
  jdtls_config.start_jdtls()
end
