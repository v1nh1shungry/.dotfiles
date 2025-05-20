return {
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "snacks.nvim", words = { "Snacks" } },
      },
    },
    specs = {
      {
        "saghen/blink.cmp",
        opts = {
          sources = {
            per_filetype = { lua = { "lazydev" } },
            providers = {
              lazydev = {
                name = "LazyDev",
                module = "lazydev.integrations.blink",
                score_offset = 100,
              },
            },
          },
        },
      },
    },
  },
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
            Dotfiles.notify.info("Installing package " .. p.name)
            p:install()
          end
        end
      end)

      local installed = mr.get_installed_packages()
      for _, p in ipairs(installed) do
        if not vim.list_contains(opts.ensure_installed, p.name) then
          Dotfiles.notify.info("Uninstall unused package " .. p.name)
          p:uninstall()
        end
      end
    end,
    event = "VeryLazy",
    -- NOTE: manually setup $PATH to speed up startup
    init = function() vim.env.PATH = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin") .. ":" .. vim.env.PATH end,
    keys = { { "<Leader>pm", "<Cmd>Mason<CR>", desc = "Mason" } },
    opts = {
      PATH = "skip",
      ensure_installed = {
        "clangd",
        "json-lsp",
        "lua-language-server",
        "neocmakelsp",
      },
    },
    opts_extend = { "ensure_installed" },
  },
  -- }}}
  {
    "saghen/blink.cmp",
    build = "cargo build --release",
    config = function(_, opts)
      for _, source in ipairs(opts.sources.compat) do
        opts.sources.providers[source] = vim.tbl_deep_extend("force", {
          name = source,
          module = "blink.compat.source",
        }, opts.sources.providers[source] or {})
      end

      opts.sources.compat = nil

      for _, sources in pairs(opts.sources.per_filetype or {}) do
        vim.list_extend(sources, opts.sources.default)
      end

      require("blink.cmp").setup(opts)
    end,
    event = "VeryLazy",
    opts = {
      cmdline = { enabled = false },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = { winblend = Dotfiles.user.ui.blend },
        },
        list = {
          selection = {
            preselect = function() return not require("blink.cmp").snippet_active({ direction = 1 }) end,
          },
        },
        menu = {
          draw = {
            align_to = "none",
            treesitter = { "lsp" },
          },
          winblend = Dotfiles.user.ui.blend,
        },
      },
      fuzzy = { prebuilt_binaries = { download = false } },
      keymap = { preset = "super-tab" },
      signature = { enabled = true },
      sources = {
        compat = {},
        default = { "lsp", "snippets", "path", "buffer" },
        providers = {
          snippets = {
            opts = {
              search_paths = { vim.fs.joinpath(vim.fn.stdpath("config"), "snippets") },
            },
          },
        },
      },
    },
    opts_extend = { "sources.compat", "sources.default" },
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
        lua = { "stylua" },
        markdown = { "autocorrect", "injected" },
        query = { "format-queries" },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
        stylua = { condition = function(_, ctx) return vim.fs.root(ctx.filename, "stylua.toml") ~= nil end },
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

      local function debounce(ms, fn)
        local timer = assert(vim.uv.new_timer())
        return function(...)
          local argv = { ... }
          timer:start(ms, 0, function()
            timer:stop()
            vim.schedule_wrap(fn)(unpack(argv))
          end)
        end
      end

      ---@class dotfiles.plugins.ide.lint.Linter: lint.Linter
      ---@field condition fun(): boolean

      local function run()
        local names = lint._resolve_linter_by_ft(vim.bo.filetype)
        names = vim.list_extend({}, names)
        if #names == 0 then
          vim.list_extend(names, lint.linters_by_ft["_"] or {})
        end
        vim.list_extend(names, lint.linters_by_ft["*"] or {})
        names = vim.tbl_filter(function(name)
          local linter = lint.linters[name] ---@cast linter dotfiles.plugins.ide.lint.Linter
          if not linter then
            vim.notify("Linter not found: " .. name, vim.log.levels.WARN, { title = "nvim-lint" })
          end
          return linter and not (type(linter) == "table" and linter.condition and not linter.condition())
        end, names)
        if #names > 0 then
          lint.try_lint(names)
        end
      end

      vim.api.nvim_create_autocmd(opts.events, {
        callback = debounce(100, run),
        group = Dotfiles.augroup("lint"),
      })
    end,
    event = "LazyFile",
    opts = {
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
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
      preview_window = { border = "rounded", winblend = Dotfiles.user.ui.blend },
      keymaps = {
        peek_location = {},
        goto_and_close = { "o" },
        up_and_jump = "<C-p>",
        down_and_jump = "<C-n>",
      },
      symbols = { icon_fetcher = function(kind, _) return require("mini.icons").get("lsp", kind) end },
    },
  },
}
