return {
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    config = function(_, opts)
      Dotfiles.treesitter.on_available(function(buf)
        if not pcall(vim.treesitter.get_parser) then
          return
        end

        for direction, actions in pairs(opts.move) do
          local desc_prefix = direction:gsub("_", " ") .. " "
          desc_prefix = desc_prefix:sub(1, 1):upper() .. desc_prefix:sub(2)
          for key, textobject in pairs(actions) do
            Dotfiles.map({
              key,
              function()
                if vim.wo.diff and key:find("[%]%[][cC]") then
                  vim.cmd("normal! " .. vim.v.count1 .. key)
                else
                  require("nvim-treesitter-textobjects.move")[direction](textobject, "textobjects")
                end
              end,
              buffer = buf,
              desc = desc_prefix .. textobject,
              mode = { "n", "x", "o" },
            })
          end
        end
      end)
    end,
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "LazyFile",
    opts = {
      move = {
        goto_next_start = {
          ["]a"] = "@parameter.inner",
          ["]f"] = "@function.outer",
          ["]c"] = "@class.outer",
        },
        goto_next_end = {
          ["]F"] = "@function.outer",
          ["]C"] = "@class.outer",
        },
        goto_previous_start = {
          ["[a"] = "@parameter.inner",
          ["[f"] = "@function.outer",
          ["[c"] = "@class.outer",
        },
        goto_previous_end = {
          ["[F"] = "@function.outer",
          ["[C"] = "@class.outer",
        },
      },
    },
  },
}
