return {
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    config = function(_, opts)
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
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
                  ---@diagnostic disable-next-line: unnecessary-if
                  if vim.wo.diff and key:find("[%]%[][cC]") then
                    vim.cmd("normal! " .. key)
                  else
                    require("nvim-treesitter-textobjects.move")[direction](textobject, "textobjects")
                  end
                end,
                buffer = args.buf,
                desc = desc_prefix .. textobject,
                mode = { "n", "x", "o" },
              })
            end
          end
        end,
        desc = "Setup nvim-treesitter-textobjects key mappings",
        group = Dotfiles.augroup("nvim-treesitter-textobjects"),
      })
    end,
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "LazyFile",
    opts = {
      move = {
        goto_next_start = { ["]a"] = "@parameter.inner", ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
        goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
        goto_previous_start = { ["[a"] = "@parameter.inner", ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
        goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
      },
    },
  },
}
