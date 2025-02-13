return {
  {
    "neovim/nvim-lspconfig",
    config = function(_, opts)
      local CODENLENS_AUGROUP = Dotfiles.augroup("codelens")

      local on_attach = function(client, bufnr)
        local map_local = function(key)
          key.buffer = bufnr
          Dotfiles.map(key)
        end

        local mappings = {
          ["textDocument/rename"] = { "<Leader>cr", vim.lsp.buf.rename, desc = "Rename" },
          ["textDocument/codeAction"] = { "<Leader>ca", vim.lsp.buf.code_action, desc = "Code action" },
          ["textDocument/documentSymbol"] = {
            {
              "<Leader>ss",
              function()
                Snacks.picker.lsp_symbols({ tree = false })
              end,
              desc = "LSP symbols (Document)",
            },
            { "gO", "<Cmd>Outline<CR>", desc = "Symbol outline" },
          },
          ["workspace/symbol"] = {
            "<Leader>sS",
            function()
              Snacks.picker.lsp_workspace_symbols({ tree = false })
            end,
            desc = "LSP symbols (Workspace)",
          },
          ["textDocument/references"] = {
            { "gR", vim.lsp.buf.references, desc = "Go to references" },
            {
              "<Leader>sR",
              function()
                Snacks.picker.lsp_references()
              end,
              desc = "LSP references",
            },
          },
          ["textDocument/definition"] = {
            { "gd", vim.lsp.buf.definition, desc = "Go to definition" },
            {
              "<Leader>sd",
              function()
                Snacks.picker.lsp_definitions()
              end,
              desc = "LSP definitions",
            },
            { "<Leader>cp", Dotfiles.lsp.peek_definition, desc = "Peek definition" },
          },
          ["textDocument/declaration"] = {
            { "gD", vim.lsp.buf.declaration, desc = "Go to declaration" },
            {
              "<Leader>sD",
              function()
                Snacks.picker.lsp_declarations()
              end,
              desc = "LSP declarations",
            },
          },
          ["textDocument/typeDefinition*"] = {
            { "gy", vim.lsp.buf.type_definition, desc = "Go to type definition" },
            {
              "<Leader>sy",
              function()
                Snacks.picker.lsp_type_definitions()
              end,
              desc = "LSP type definitions",
            },
          },
          ["textDocument/implementation*"] = {
            { "gI", vim.lsp.buf.implementation, desc = "Go to implementation" },
            {
              "<Leader>sI",
              function()
                Snacks.picker.lsp_implementations()
              end,
              desc = "LSP implementations",
            },
          },
          ["callHierarchy/incomingCalls"] = { "<Leader>ci", vim.lsp.buf.incoming_calls, desc = "Incoming calls" },
          ["callHierarchy/outgoingCalls"] = { "<Leader>co", vim.lsp.buf.outgoing_calls, desc = "Outgoing calls" },
          ["textDocument/inlayHint"] = function()
            Snacks.toggle.inlay_hints():map("<leader>uh", { buffer = bufnr })
          end,
          ["typeHierarchy/subtypes"] = {
            "<Leader>cs",
            function()
              vim.lsp.buf.typehierarchy("subtypes")
            end,
            desc = "LSP subtypes",
          },
          ["typeHierarchy/supertypes"] = {
            "<Leader>cS",
            function()
              vim.lsp.buf.typehierarchy("supertypes")
            end,
            desc = "LSP supertypes",
          },
          ["textDocument/documentHighlight"] = {
            {
              "]]",
              function()
                Snacks.words.jump(vim.v.count1)
              end,
              desc = "Next reference",
            },
            {
              "[[",
              function()
                Snacks.words.jump(-vim.v.count1)
              end,
              desc = "Previous reference",
            },
          },
        }

        for method, keys in pairs(mappings) do
          if client.supports_method(method) then
            if type(keys) == "function" then
              keys()
            elseif type(keys[1]) == "string" then
              map_local(keys)
            else
              for _, k in ipairs(keys) do
                map_local(k)
              end
            end
          end
        end

        for _, key in ipairs(opts.servers[client.name] and opts.servers[client.name].keys or {}) do
          map_local(key)
        end

        if
          client.supports_method("textDocument/inlayHint")
          and vim.api.nvim_buf_is_valid(bufnr)
          and vim.bo[bufnr].buftype == ""
        then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end

        if client.supports_method("textDocument/codeLens") then
          vim.lsp.codelens.refresh()
          vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = bufnr,
            callback = vim.lsp.codelens.refresh,
            group = CODENLENS_AUGROUP,
          })
        end

        Dotfiles.lsp.attach_lightbulb(client, bufnr)
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client then
            on_attach(client, args.buf)
          end
        end,
        group = Dotfiles.augroup("lsp_on_attach"),
      })

      -- https://www.lazyvim.org/plugins/lsp {{{
      local all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      local ensure_installed = {}

      local function setup(server)
        if not opts.servers[server] then
          return
        end

        if opts.setup then
          if opts.setup[server] then
            if opts.setup[server](server, opts.servers[server]) then
              return
            end
          elseif opts.setup["*"] then
            if opts.setup["*"](server, opts.servers[server]) then
              return
            end
          end
        end

        require("lspconfig")[server].setup(opts.servers[server])
      end

      for server, server_opts in pairs(opts.servers) do
        if server_opts.mason == false or not vim.list_contains(all_mslp_servers, server) then
          setup(server)
        else
          ensure_installed[#ensure_installed + 1] = server
        end
      end

      require("mason-lspconfig").setup({
        ensure_installed = ensure_installed,
        handlers = { setup },
      })
      -- }}}
    end,
    dependencies = {
      {
        "williamboman/mason-lspconfig.nvim",
        dependencies = "williamboman/mason.nvim",
      },
    },
    event = Dotfiles.events.enter_buffer,
    opts = {
      servers = {
        jsonls = {
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
          end,
          settings = {
            json = {
              format = { enable = true },
              validate = { enable = true },
            },
          },
        },
        neocmake = {},
        clangd = {
          cmd = {
            "clangd",
            "--all-scopes-completion",
            "--background-index",
            "--clang-tidy",
            "--completion-style=detailed",
            "--experimental-modules-support",
            "--fallback-style=llvm",
            "--header-insertion=never",
          },
          keys = {
            {
              "<Leader>cs",
              "<Cmd>ClangdSwitchSourceHeader<CR>",
              desc = "Switch between header and source",
            },
            {
              "<Leader>cA",
              Dotfiles.lsp.clangd_ast,
              desc = "Clangd AST",
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = "Replace", autoRequire = false },
              telemetry = { enable = false },
              workspace = { checkThirdParty = false },
              doc = { privateName = { "^_" } },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
            },
          },
        },
        bashls = {},
        yamlls = {
          on_new_config = function(new_config)
            new_config.settings.yaml.schemas = vim.tbl_deep_extend(
              "force",
              new_config.settings.yaml.schemas or {},
              require("schemastore").yaml.schemas()
            )
          end,
          settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = {
              keyOrdering = false,
              format = { enable = true },
              validate = true,
              schemaStore = { enable = false, url = "" },
            },
          },
        },
      },
    },
  },
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = { library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } } },
    opts_extend = { "library" },
    specs = {
      {
        "saghen/blink.cmp",
        optional = true,
        opts = {
          sources = {
            default = { "lazydev" },
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
    "williamboman/mason.nvim",
    config = function(_, opts)
      require("mason").setup(opts)

      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)
      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            Snacks.notify.info("Installing package " .. p.name)
            p:install()
          end
        end
      end)

      Snacks.util.on_module("mason-lspconfig", function()
        local installed = mr.get_installed_packages()
        local ensure_installed = vim.list_extend(
          vim
            .iter(require("mason-lspconfig.settings").current.ensure_installed)
            :map(function(p)
              return require("mason-lspconfig.mappings.server").lspconfig_to_package[p]
            end)
            :totable(),
          opts.ensure_installed
        )

        for _, p in ipairs(installed) do
          if not vim.list_contains(ensure_installed, p.name) then
            Snacks.notify.info("Uninstall unused package " .. p.name)
            p:uninstall()
          end
        end
      end)
    end,
    keys = { { "<Leader>pm", "<Cmd>Mason<CR>", desc = "Mason" } },
    opts = { ensure_installed = {} },
    opts_extend = { "ensure_installed" },
  },
  -- }}}
  {
    "saghen/blink.cmp",
    build = "cargo build --release",
    dependencies = "xzbdmw/colorful-menu.nvim",
    event = "InsertEnter",
    opts = {
      appearance = { use_nvim_cmp_as_default = false, nerd_font_variant = "mono" },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        menu = {
          draw = {
            align_to = "none",
            treesitter = { "lsp" },
            columns = { { "kind_icon" }, { "label", gap = 1 }, { "source_name" } },
            components = {
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                  return kind_icon
                end,
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
              label = {
                text = function(ctx)
                  return require("colorful-menu").blink_components_text(ctx)
                end,
                highlight = function(ctx)
                  return require("colorful-menu").blink_components_highlight(ctx)
                end,
              },
            },
          },
        },
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        trigger = { show_in_snippet = false },
      },
      sources = {
        default = { "lsp", "snippets", "path", "buffer", "rg" },
        cmdline = {},
        providers = {
          rg = {
            module = "blink.rg",
            name = "Ripgrep",
            score_offset = -100,
          },
        },
      },
      keymap = { preset = "super-tab" },
      fuzzy = { prebuilt_binaries = { download = false } },
    },
    opts_extend = { "sources.default" },
  },
  {
    "stevearc/conform.nvim",
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    dependencies = {
      "williamboman/mason.nvim",
      opts = { ensure_installed = { "shfmt", "stylua" } },
    },
    keys = {
      {
        "<Leader>cf",
        function()
          require("conform").format({ timeout_ms = 3000, async = false, quiet = false, lsp_fallback = true })
        end,
        desc = "Format document",
        mode = { "n", "v" },
      },
    },
    opts = {
      formatters_by_ft = {
        fish = { "fish_indent" },
        just = { "just" },
        lua = { "stylua" },
        markdown = { "injected" },
        query = { "format-queries" },
        sh = { "shfmt" },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
        stylua = {
          condition = function(_, ctx)
            return vim.fs.root(ctx.filename, "stylua.toml")
          end,
        },
      },
    },
  },
  -- https://www.lazyvim.org/plugins/linting {{{
  {
    "mfussenegger/nvim-lint",
    config = function(_, opts)
      local M = {}

      local lint = require("lint")
      for name, linter in pairs(opts.linters) do
        if type(linter) == "table" and type(lint.linters[name]) == "table" then
          lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
          if type(linter.prepend_args) == "table" then
            vim.list_extend(lint.linters[name].args, linter.prepend_args)
          end
        else
          lint.linters[name] = linter
        end
      end
      lint.linters_by_ft = opts.linters_by_ft

      function M.debounce(ms, fn)
        local timer = vim.uv.new_timer()
        return function(...)
          local argv = { ... }
          timer:start(ms, 0, function()
            timer:stop()
            vim.schedule_wrap(fn)(unpack(argv))
          end)
        end
      end

      function M.lint()
        local names = lint._resolve_linter_by_ft(vim.bo.filetype)
        names = vim.list_extend({}, names)
        if #names == 0 then
          vim.list_extend(names, lint.linters_by_ft["_"] or {})
        end
        vim.list_extend(names, lint.linters_by_ft["*"] or {})
        names = vim.tbl_filter(function(name)
          local linter = lint.linters[name]
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
        callback = M.debounce(100, M.lint),
        group = Dotfiles.augroup("nvim_lint"),
      })
    end,
    dependencies = {
      "williamboman/mason.nvim",
      opts = { ensure_installed = { "cspell" } },
    },
    event = Dotfiles.events.enter_buffer,
    opts = {
      events = { "BufWritePost", "BufReadPost" },
      linters_by_ft = {
        bash = { "bash" },
        cpp = { "cspell" },
        fish = { "fish" },
        sh = { "bash" },
      },
      linters = {
        cspell = {
          condition = function()
            return vim.bo.buftype == "" and vim.fs.root(vim.uv.cwd() or 0, ".cspell-words.txt")
          end,
        },
      },
    },
  },
  -- }}}
  {
    "hedyhli/outline.nvim",
    cmd = "Outline",
    opts = {
      outline_window = { auto_close = true, hide_cursor = true },
      preview_window = { border = "rounded", winblend = vim.opt.winblend },
      keymaps = {
        goto_location = { "o", "<CR>" },
        peek_location = {},
        goto_and_close = {},
        up_and_jump = "<C-p>",
        down_and_jump = "<C-n>",
      },
      symbols = {
        icon_fetcher = function(kind, _)
          return require("mini.icons").get("lsp", kind)
        end,
      },
    },
  },
}
