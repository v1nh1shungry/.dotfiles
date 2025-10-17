-- https://www.lazyvim.org/plugins/coding#miniai {{{
return {
  {
    "nvim-mini/mini.ai",
    event = "VeryLazy", -- NOTE: Required for nofile buffers
    opts = function()
      local ai = require("mini.ai")

      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
          d = { "%f[%d]%d+" },
          g = function(ai_type)
            local start_line, end_line = 1, vim.fn.line("$")
            if ai_type == "i" then
              local first_nonblank, last_nonblank = vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
              if first_nonblank == 0 or last_nonblank == 0 then
                return { from = { line = start_line, col = 1 } }
              end
              start_line, end_line = first_nonblank, last_nonblank
            end
            local to_col = math.max(vim.fn.getline(end_line):len(), 1)
            return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
          end,
          u = ai.gen_spec.function_call(),
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
          w = {
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
        },
      }
    end,
  },
  {
    "folke/which-key.nvim",
    opts = function()
      local objects = {
        { " ", desc = "whitespace" },
        { '"', desc = 'balanced "' },
        { "'", desc = "balanced '" },
        { "(", desc = "balanced (" },
        { ")", desc = "balanced ) including white-space" },
        { "<", desc = "balanced <" },
        { ">", desc = "balanced > including white-space" },
        { "?", desc = "user prompt" },
        { "U", desc = "use/call without dot in name" },
        { "[", desc = "balanced [" },
        { "]", desc = "balanced ] including white-space" },
        { "_", desc = "underscore" },
        { "`", desc = "balanced `" },
        { "a", desc = "argument" },
        { "b", desc = "balanced )]}" },
        { "c", desc = "class" },
        { "d", desc = "digit(s)" },
        { "f", desc = "function" },
        { "g", desc = "entire file" },
        { "i", desc = "indent" },
        { "o", desc = "block, conditional, loop" },
        { "q", desc = "quote `\"'" },
        { "t", desc = "tag" },
        { "u", desc = "use/call function & method" },
        { "{", desc = "balanced {" },
        { "}", desc = "balanced } including white-space" },
      }

      local spec = { mode = { "o", "x" } }
      for prefix, name in pairs({
        i = "inside",
        a = "around",
        il = "last",
        ["in"] = "next",
        al = "last",
        an = "next",
      }) do
        spec[#spec + 1] = { prefix, group = name }
        for _, obj in ipairs(objects) do
          spec[#spec + 1] = { prefix .. obj[1], desc = obj.desc }
        end
      end

      return { spec = { spec } }
    end,
  },
}
-- }}}
