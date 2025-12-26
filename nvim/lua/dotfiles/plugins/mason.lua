-- https://www.lazyvim.org/plugins/lsp#masonnvim-1 {{{
return {
  {
    "mason-org/mason.nvim",
    config = function(_, opts)
      require("mason").setup(opts)

      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(
          function()
            require("lazy.core.handler.event").trigger({
              event = "FileType",
              buf = vim.api.nvim_get_current_buf(),
            })
          end,
          100
        )
      end)
      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            Snacks.notify("Installing package " .. p.name)
            p:install()
          end
        end
      end)
    end,
    event = "VeryLazy",
    keys = { { "<Leader>pm", "<Cmd>Mason<CR>", desc = "Mason" } },
    opts = {
      ensure_installed = {
        "rust-analyzer",
      },
    },
    opts_extend = { "ensure_installed" },
  },
}
-- }}}
