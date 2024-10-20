local events = require("dotfiles.utils.events")
local map = require("dotfiles.utils.keymap")

-- FIXME: this should be removed after switching to blink.cmp completely
--        or deciding to abandon blink.cmp
local use_blink = vim.tbl_contains(require("dotfiles.user").extra, "blink")

return {
  {
    "neovim/nvim-lspconfig",
    config = function(_, opts)
      local on_attach = function(client, bufnr)
        local map_local = function(key)
          key.buffer = bufnr
          map(key)
        end

        local mappings = {
          ["textDocument/rename"] = {
            { "<Leader>cr", vim.lsp.buf.rename, desc = "Rename" },
          },
          ["textDocument/codeAction"] = {
            { "<Leader>ca", vim.lsp.buf.code_action, desc = "Code action" },
          },
          ["textDocument/documentSymbol"] = {
            { "<Leader>ss", "<Cmd>Telescope lsp_document_symbols<CR>", desc = "LSP symbols (Document)" },
            { "<Leader>us", "<Cmd>Outline<CR>", desc = "Symbol outline" },
          },
          ["workspace/symbol"] = {
            { "<Leader>sS", "<Cmd>Telescope lsp_workspace_symbols<CR>", desc = "LSP symbols (Workspace)" },
          },
          ["textDocument/references"] = {
            { "gR", vim.lsp.buf.references, desc = "Go to references" },
            { "<Leader>sR", "<Cmd>Telescope lsp_references<CR>", desc = "LSP references" },
          },
          ["textDocument/definition"] = {
            { "gd", vim.lsp.buf.definition, desc = "Go to definition" },
            { "<Leader>sd", "<Cmd>Telescope lsp_definitions<CR>", desc = "LSP definitions" },
          },
          ["textDocument/typeDefinition*"] = {
            { "gy", vim.lsp.buf.type_definition, desc = "Go to type definition" },
            { "<Leader>sy", "<Cmd>Telescope lsp_type_definitions<CR>", desc = "LSP type definitions" },
          },
          ["textDocument/implementation*"] = {
            { "gI", vim.lsp.buf.implementation, desc = "Go to implementation" },
            { "<Leader>sI", "<Cmd>Telescope lsp_implementations<CR>", desc = "LSP implementations" },
          },
          ["callHierarchy/incomingCalls"] = {
            { "<Leader>ci", vim.lsp.buf.incoming_calls, desc = "Incoming calls" },
            { "<Leader>si", "<Cmd>Telescope lsp_incoming_calls<CR>", desc = "LSP incoming calls" },
          },
          ["callHierarchy/outgoingCalls"] = {
            { "<Leader>co", vim.lsp.buf.outgoing_calls, desc = "Outgoing calls" },
            { "<Leader>so", "<Cmd>Telescope lsp_outgoing_calls<CR>", desc = "LSP outgoing calls" },
          },
          ["textDocument/inlayHint"] = {
            { "<Leader>uh", require("dotfiles.utils.toggle").inlay_hint, desc = "Toggle inlay hint" },
          },
          ["textDocument/signatureHelp"] = {
            { "<C-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help" },
          },
          ["typeHierarchy/subtypes"] = {
            { "<Leader>cs", function() vim.lsp.buf.typehierarchy("subtypes") end, desc = "LSP subtypes" },
          },
          ["typeHierarchy/supertypes"] = {
            { "<Leader>cS", function() vim.lsp.buf.typehierarchy("supertypes") end, desc = "LSP supertypes" },
          },
        }

        for method, keys in pairs(mappings) do
          if client.supports_method(method) then
            for _, key in ipairs(keys) do
              map_local(key)
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
          })
        end
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client then
            on_attach(client, args.buf)
          end
        end,
      })

      -- https://www.lazyvim.org/plugins/lsp {{{
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        use_blink and {} or require("cmp_nvim_lsp").default_capabilities()
      )

      local function setup(server)
        if opts.servers[server] == nil then
          vim.notify("Unused LSP server: " .. server, vim.log.levels.WARN)
          return
        end
        local setup_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
          single_file_support = true,
        }, opts.servers[server])
        if opts.setup then
          if opts.setup[server] then
            if opts.setup[server](server, setup_opts) then
              return
            end
          elseif opts.setup["*"] then
            if opts.setup["*"](server, setup_opts) then
              return
            end
          end
        end
        require("lspconfig")[server].setup(setup_opts)
      end

      local all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      local ensure_installed = {}
      for server, server_opts in pairs(opts.servers) do
        if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
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
      (not use_blink) and "hrsh7th/cmp-nvim-lsp" or nil,
    },
    event = events.enter_buffer,
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
            "--background-index",
            "--clang-tidy",
            "--completion-style=detailed",
            "--fallback-style=llvm",
            "--function-arg-placeholders",
            "--header-insertion=never",
          },
          keys = {
            {
              "<Leader>;",
              "<Cmd>ClangdSwitchSourceHeader<CR>",
              desc = "Switch between header and source",
            },
          },
          on_new_config = function(new_config, _)
            if package.loaded["cmake-tools"] then
              require("cmake-tools").clangd_on_new_config(new_config)
            end
          end,
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
    dependencies = {
      "iguanacucumber/magazine.nvim",
      opts = function(_, opts) table.insert(opts.sources or {}, { name = "lazydev", group_index = 0 }) end,
    },
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        { path = "wezterm-types", mods = { "wezterm" } },
        { path = "xmake-luals-addon/library", files = { "xmake.lua" } },
      },
    },
  },
  {
    "Bilal2453/luvit-meta",
    lazy = true,
  },
  {
    "justinsgithub/wezterm-types",
    lazy = true,
  },
  {
    "LelouchHe/xmake-luals-addon",
    lazy = true,
  },
  -- https://www.lazyvim.org/plugins/lsp#masonnvim-1 {{{
  {
    "williamboman/mason.nvim",
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
            p:install()
          end
        end
      end)
    end,
    keys = { { "<Leader>pm", "<Cmd>Mason<CR>", desc = "Mason" } },
    opts = { ensure_installed = { "cspell", "shfmt", "stylua" } },
  },
  -- }}}
  {
    "iguanacucumber/magazine.nvim",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "lukas-reineke/cmp-rg",
    },
    enabled = not use_blink,
    event = events.enter_insert,
    name = "nvim-cmp",
    opts = function()
      local cmp = require("cmp")

      return {
        snippet = { expand = function(item) vim.snippet.expand(item.body) end },
        completion = { completeopt = "menu,menuone,noinsert" },
        -- https://github.com/tranzystorekk/cmp-minikind.nvim/blob/main/lua/cmp-minikind/init.lua {{{
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(_, item)
            local mini_icons = require("mini.icons")
            item.kind, item.kind_hlgroup = mini_icons.get("lsp", item.kind)

            local widths = { abbr = 40, menu = 30 }
            for k, w in pairs(widths) do
              if item[k] then
                item[k] = vim.trim(item[k])
                if vim.fn.strdisplaywidth(item[k]) > w then
                  item[k] = vim.fn.strcharpart(item[k], 0, w - 1) .. "…"
                end
              end
            end

            return item
          end,
          expandable_indicator = true,
        },
        -- }}}
        mapping = {
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              if not cmp.get_selected_entry() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
              else
                cmp.confirm()
              end
            elseif vim.snippet.active({ direction = 1 }) then
              vim.snippet.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif vim.snippet.active({ direction = -1 }) then
              vim.snippet.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "snippets" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }, {
          { name = "rg", keyword_length = 5, option = { debounce = 500 } },
        }),
        sorting = require("cmp.config.default")().sorting,
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
    dependencies = "williamboman/mason.nvim",
    keys = {
      {
        "<Leader>cf",
        function() require("conform").format({ timeout_ms = 3000, async = false, quiet = false, lsp_fallback = true }) end,
        desc = "Format document",
        mode = { "n", "v" },
      },
    },
    opts = {
      formatters_by_ft = {
        fish = { "fish_indent" },
        lua = { "stylua" },
        markdown = { "injected" },
        query = { "format-queries" },
        sh = { "shfmt" },
      },
      formatters = { injected = { options = { ignore_errors = true } } },
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
        local ctx = { filename = vim.api.nvim_buf_get_name(0) }
        ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
        names = vim.tbl_filter(function(name)
          local linter = lint.linters[name]
          if not linter then
            vim.notify("Linter not found: " .. name, vim.log.levels.WARN, { title = "nvim-lint" })
          end
          return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
        end, names)
        if #names > 0 then
          lint.try_lint(names)
        end
      end

      vim.api.nvim_create_autocmd(opts.events, {
        group = vim.api.nvim_create_augroup("nvim-lint", {}),
        callback = M.debounce(100, M.lint),
      })
    end,
    dependencies = "williamboman/mason.nvim",
    event = events.enter_buffer,
    opts = {
      events = { "BufWritePost", "BufReadPost" },
      linters_by_ft = {
        fish = { "fish" },
        ["*"] = { "cspell" },
      },
      linters = {
        cspell = {
          condition = function(ctx)
            return vim.bo.buftype == ""
              and vim.tbl_contains({ "cpp" }, vim.bo.filetype)
              and vim.fs.find({ ".cspell-words.txt" }, { path = ctx.filename, upward = true })[1]
          end,
        },
      },
    },
  },
  -- }}}
  {
    "Civitasv/cmake-tools.nvim",
    ft = "cmake",
    -- https://www.lazyvim.org/extras/lang/cmake#cmake-toolsnvim {{{
    init = function()
      local loaded = false
      local function check()
        if vim.fn.filereadable(vim.fs.joinpath(vim.uv.cwd(), "CMakeLists.txt")) == 1 then
          require("lazy").load({ plugins = { "cmake-tools.nvim" } })
          loaded = true
        end
      end
      check()
      vim.api.nvim_create_autocmd("DirChanged", {
        callback = function()
          if not loaded then
            check()
          end
        end,
      })
    end,
    -- }}}
    keys = {
      { "<Leader>mg", "<Cmd>CMakeGenerate<CR>", desc = "Configure" },
      { "<Leader>mb", "<Cmd>CMakeBuild<CR>", desc = "Build" },
      { "<Leader>mx", "<Cmd>CMakeRun<CR>", desc = "Run executable" },
      { "<Leader>md", "<Cmd>CMakeDebug<CR>", desc = "Debug" },
      { "<Leader>ma", ":CMakeLaunchArgs ", desc = "Set launch arguments" },
      { "<Leader>ms", "<Cmd>CMakeTargetSettings<CR>", desc = "Summary" },
      { "<Leader>mc", "<Cmd>CMakeClean<CR>", desc = "Clean" },
      {
        "<Leader>mp",
        function()
          if vim.fn.mkdir("cmake", "p") == 0 then
            vim.notify("CPM.cmake: can't create 'cmake' directory", vim.log.levels.ERROR)
            return
          end
          vim.notify("Downloading CPM.cmake...")
          vim.system({
            "wget",
            "-O",
            "cmake/CPM.cmake",
            "https://github.com/cpm-cmake/CPM.cmake/releases/latest/download/get_cpm.cmake",
          }, {}, function(out)
            if out.code == 0 then
              vim.notify("CPM.cmake: downloaded cmake/CPM.cmake successfully")
            else
              vim.notify("CPM.cmake: failed to download CPM.cmake", vim.log.levels.ERROR)
            end
          end)
        end,
        desc = "Get CPM.cmake",
      },
    },
    opts = {
      cmake_regenerate_on_save = false,
      cmake_generate_options = {
        "-G",
        "Ninja",
        "-DCMAKE_EXPORT_COMPILE_COMMANDS=On",
        "-DCMAKE_CXX_COMPILER_LAUNCHER=ccache",
      },
      cmake_build_directory = "build/${variant:buildType}",
      cmake_soft_link_compile_commands = false,
      cmake_compile_commands_from_lsp = true,
      cmake_runner = { name = "toggleterm", opts = { direction = "horizontal" } },
      cmake_dap_configuration = {
        name = "cpp",
        type = "gdb",
        request = "launch",
        stopAtBeginningOfMainSubprogram = false,
      },
      cmake_virtual_text_support = false,
    },
  },
}
