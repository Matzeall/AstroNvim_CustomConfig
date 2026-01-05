return {
  "kawre/leetcode.nvim",
  build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
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

    -- RUST specific setup
    injector = {
      ["rust"] = {
        before = { "#![allow(dead_code)]", "struct Solution;" }, -- , "fn main(){}"
      }, ---@type table<lc.lang, lc.inject>
    },
    hooks = {
      ---@type fun(question: lc.ui.Question)[]
      ["question_enter"] = {
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
      },
    },
    -- RUST specific end
  },
}
