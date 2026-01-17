return {
  "kawre/leetcode.nvim",
  build = ":TSUpdate html",
  dependencies = {
    "folke/snacks.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  cmd = "Leet",
  opts = {
    lang = "csharp",
    ---@type table<string, boolean>
    plugins = {
      non_standalone = true,
    },

    injector = {
      ["rust"] = {
        before = { "#![allow(dead_code)]", "struct Solution;" }, -- , "fn main(){}"
      }, ---@type table<lc.lang, lc.inject>
      ["csharp"] = {
        before = "namespace Leetcode;",
      },
    },
    hooks = {
      ---@type fun(question: lc.ui.Question)[]
      ["question_enter"] = {
        -- RUST specific root setup
        function(question)
          if question.lang ~= "rust" then return end

          local config = require "leetcode.config"
          local problem_dir = config.user.storage.home .. "/Cargo.toml"
          local content = [[
              [package]
              name = "leetcode"
              edition = "2024"
                                                                                                     
              [lib]
              name = "%s"
              path = "%s"
                                                                                                     
              [dependencies]
              rand = "0.8"
              regex = "1"
              itertools = "0.14.0"
            ]]
          local file = io.open(problem_dir, "w")
          if file then
            local formatted = (content:gsub(" +", "")):format(question.q.frontend_id, question:path())
            file:write(formatted)
            file:close()
          else
            print("Failed to open file: " .. problem_dir)
          end
        end,
        -- C# specific project root setup
        function(question)
          local lang = question.lang and question.lang:lower() or ""
          if not (lang == "csharp" or lang == "cs" or lang == "c#") then return end

          local config = require "leetcode.config"
          local problem_dir = config.user.storage.home .. "/leetcode.csproj"

          -- TODO: dynamically recognize which dotnet version is the latest installed one and inject that
          local csproj_template = [[
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <TargetFramework>net10.0</TargetFramework>
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>
    <OutputType>Library</OutputType>
  </PropertyGroup>
  <ItemGroup>
    <!-- only include the current problem file -->
    <Compile Remove="*.cs" />
    <Compile Include="%s" />
  </ItemGroup>
</Project>
          ]]
          local csproj_content = csproj_template:format(question:path())
          local f, err = io.open(problem_dir, "w")
          if not f then
            print("Failed to create csproj at " .. problem_dir .. " : " .. tostring(err))
            return
          end
          f:write(csproj_content)
          f:close()
        end,
      },
    },
  },
}
