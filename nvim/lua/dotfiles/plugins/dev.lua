return {
  -- https://www.lazyvim.org/plugins/lsp#masonnvim-1 {{{
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
            Dotfiles.notify("Installing package " .. p.name)
            p:install()
          end
        end
      end)
    end,
    event = "VeryLazy",
    -- HACK: Setup $PATH manually to speed up startup.
    init = function()
      vim.env.PATH = vim.fs.joinpath(vim.fn.stdpath("data") --[[@as string]], "mason", "bin")
        .. ":"
        .. vim.env.PATH
    end,
    keys = { { "<Leader>pm", "<Cmd>Mason<CR>", desc = "Mason" } },
    opts = {
      PATH = "skip",
      ensure_installed = {
        "clangd",
        "emmylua_ls",
        "json-lsp",
        "neocmakelsp",
      },
    },
    opts_extend = { "ensure_installed" },
  },
  -- }}}
  {
    "saghen/blink.cmp",
    build = "cargo build --release",
    event = "VeryLazy",
    opts = {
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        list = {
          selection = {
            preselect = function() return not require("blink.cmp").snippet_active({ direction = 1 }) end,
          },
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
          },
        },
      },
      fuzzy = {
        prebuilt_binaries = {
          download = false,
        },
      },
      keymap = { preset = "super-tab" },
      signature = { enabled = true },
      sources = {
        default = { "lsp", "snippets", "path", "buffer" },
      },
    },
    opts_extend = { "sources.default" },
  },
  {
    "stevearc/conform.nvim",
    init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
    dependencies = {
      "williamboman/mason.nvim",
      opts = { ensure_installed = vim.version.cmp(Dotfiles.C.glibc_version(), "2.31") > 0 and { "stylua" } or {} },
    },
    keys = {
      { "<Leader>cf", function() require("conform").format() end, desc = "Format Document", mode = { "n", "x" } },
    },
    opts = {
      default_format_opts = { lsp_format = "fallback" },
      formatters_by_ft = {
        fish = { "fish_indent" },
        just = { "just" },
        markdown = { "injected" },
        query = { "format-queries" },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
      },
    },
  },
  -- https://www.lazyvim.org/plugins/linting {{{
  {
    "mfussenegger/nvim-lint",
    config = function(_, opts)
      local lint = require("lint")

      for name, linter in pairs(opts.linters or {}) do
        if type(linter) == "table" and type(lint.linters[name]) == "table" then
          lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name] --[[@as lint.Linter]], linter)
        else
          lint.linters[name] = linter
        end
      end

      lint.linters_by_ft = opts.linters_by_ft

      ---@class dotfiles.plugins.dev.lint.Linter: lint.Linter
      ---@field condition fun(): boolean

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          local names = vim
            .iter(lint._resolve_linter_by_ft(vim.bo.filetype))
            :filter(function(name)
              local linter = lint.linters[name] ---@as dotfiles.plugins.dev.lint.Linter
              if not linter then
                Dotfiles.notify.warn("Linter not found: " .. name)
                return false
              end
              return not (type(linter) == "table" and linter.condition and not linter.condition())
            end)
            :totable()

          if #names > 0 then
            lint.try_lint(names)
          end
        end,
        desc = "Run linter automatically",
        group = Dotfiles.augroup("lint"),
      })
    end,
    event = "LazyFile",
    opts = {
      linters_by_ft = {
        bash = { "bash" },
        fish = { "fish" },
        sh = { "bash" },
      },
    },
  },
  -- }}}
  {
    "hedyhli/outline.nvim",
    cmd = "Outline",
    opts = {
      outline_window = { hide_cursor = true },
      preview_window = { border = "rounded" },
      keymaps = {
        peek_location = {},
        goto_and_close = { "o" },
        up_and_jump = "<C-p>",
        down_and_jump = "<C-n>",
      },
      symbols = { icon_fetcher = function(kind, _) return require("mini.icons").get("lsp", kind) end },
    },
  },
  "neovim/nvim-lspconfig",
}
