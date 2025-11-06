-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

--- INFO: Seperated things in this file out into a full "polish/" directory

--- require all files in "polish/"
local polish_root = vim.fn.stdpath "config" .. "/lua/polish"
for file_name, type in vim.fs.dir(polish_root, { depth = 1 }) do
  if type == "file" then
    local mod_name = file_name:gsub("%.lua$", "")
    require("polish." .. mod_name)
  end
end

--- require all files in "color_scheme/"
local scheme_root = vim.fn.stdpath "config" .. "/lua/color_scheme"
for file_name, type in vim.fs.dir(scheme_root, { depth = 1 }) do
  if type == "file" then
    local mod_name = file_name:gsub("%.lua$", "")
    require("color_scheme." .. mod_name)
  end
end
