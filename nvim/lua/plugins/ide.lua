local events = require("utils.events")
local map = require("utils.keymap")

return {
  {
    "neovim/nvim-lspconfig",
    config = function(_, lsp_opts)
      local on_attach = function(client, bufnr)
        local map_local = function(opts)
          opts.buffer = bufnr
          map(opts)
        end

        local mappings = {
          ["textDocument/rename"] = {
            { "<Leader>cr", vim.lsp.buf.rename, desc = "Rename" },
          },
          ["textDocument/codeAction"] = {
            { "<Leader>ca", vim.lsp.buf.code_action, desc = "Code action" },
          },
          ["textDocument/documentSymbol"] = {
            { "<Leader>ss", "<Cmd>Telescope lsp_document_symbols<CR>", desc = "Browse LSP symbols (Document)" },
            { "<Leader>sS", "<Cmd>Telescope lsp_workspace_symbols<CR>", desc = "Browse LSP symbols (Workspace)" },
          },
          ["textDocument/references"] = {
            { "gR", vim.lsp.buf.references, desc = "Go to references" },
            { "<Leader>sR", "<Cmd>Telescope lsp_references<CR>", desc = "Browse LSP references" },
          },
          ["textDocument/definition"] = {
            { "gd", vim.lsp.buf.definition, desc = "Go to definition" },
            { "<Leader>sd", "<Cmd>Telescope lsp_definitions<CR>", desc = "Browse LSP definitions" },
          },
          ["textDocument/typeDefinition*"] = {
            { "gy", vim.lsp.buf.type_definition, desc = "Go to type definition" },
            { "<Leader>sy", "<Cmd>Telescope lsp_type_definitions<CR>", desc = "Browse LSP type definitions" },
          },
          ["textDocument/implementation*"] = {
            { "gI", vim.lsp.buf.implementation, desc = "Go to implementation" },
            { "<Leader>sI", "<Cmd>Telescope lsp_implementations<CR>", desc = "Browse LSP implementations" },
          },
          ["callHierarchy/incomingCalls"] = {
            { "<Leader>ci", vim.lsp.buf.incoming_calls, desc = "Incoming calls" },
            { "<Leader>si", "<Cmd>Telescope lsp_incoming_calls<CR>", desc = "Browse LSP incoming calls" },
          },
          ["callHierarchy/outgoingCalls"] = {
            { "<Leader>co", vim.lsp.buf.outgoing_calls, desc = "Outgoing calls" },
            { "<Leader>so", "<Cmd>Telescope lsp_outgoing_calls<CR>", desc = "Browse LSP outgoing calls" },
          },
          ["textDocument/inlayHint"] = {
            { "<Leader>uh", require("utils.toggle").inlay_hint, desc = "Toggle inlay hint" },
          },
          ["textDocument/signatureHelp"] = {
            { "<C-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help" },
          },
        }

        for method, keys in pairs(mappings) do
          if client.supports_method(method) then
            for _, key in ipairs(keys) do
              map_local(key)
            end
          end
        end

        if client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(true)
        end
      end

      require("mason-lspconfig").setup({ automatic_installation = true })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args) on_attach(vim.lsp.get_client_by_id(args.data.client_id), args.buf) end,
      })

      local register_capability = vim.lsp.handlers["client/registerCapability"]

      vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
        local ret = register_capability(err, res, ctx)
        local client_id = ctx.client_id
        local client = vim.lsp.get_client_by_id(client_id)
        local buffer = vim.api.nvim_get_current_buf()
        on_attach(client, buffer)
        return ret
      end

      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
      )
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      for server, opts in pairs(lsp_opts.servers) do
        opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
          single_file_support = true,
        }, opts)
        require("lspconfig")[server].setup(opts)
      end
    end,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      {
        "folke/neodev.nvim",
        opts = {},
      },
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      {
        "folke/neoconf.nvim",
        opts = {},
      },
    },
    opts = {
      servers = {
        jsonls = {},
        neocmake = {},
        clangd = {
          cmd = {
            "clangd",
            "--header-insertion=never",
            "--include-cleaner-stdlib",
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
        basedpyright = {},
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      {
        "williamboman/mason.nvim",
        keys = { { "<Leader>cm", "<Cmd>Mason<CR>", desc = "Mason" } },
        opts = {},
      },
      "williamboman/mason-lspconfig.nvim",
    },
    opts = { ensure_installed = { "stylua", "black", "codelldb" } },
  },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        snippet = {
          expand = function(item) vim.snippet.expand(item.body) end,
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(_, item)
            item.abbr = vim.trim(item.abbr)
            if #item.abbr > 50 then
              item.abbr = item.abbr:sub(1, 50) .. "…"
            end
            item.menu = item.kind
            item.kind = require("utils.ui").icons.lspkind[item.kind]
            return item
          end,
          expandable_indicator = true,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
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
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "snippets" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })

      local cmdline_mapping = cmp.mapping.preset.cmdline({
        ["<C-n>"] = cmp.config.disable,
        ["<C-p>"] = cmp.config.disable,
      })

      cmp.setup.cmdline(":", {
        mapping = cmdline_mapping,
        sources = cmp.config.sources({
          { name = "cmdline" },
          { name = "path" },
        }),
      })

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmdline_mapping,
        sources = cmp.config.sources({ { name = "buffer" } }),
      })
    end,
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-path",
    },
    event = events.enter_insert,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = events.enter_buffer,
    opts = {
      on_attach = function(buffer)
        local map_local = function(opts)
          opts.buffer = buffer
          map(opts)
        end
        map_local({ "<Leader>gp", "<Cmd>Gitsigns preview_hunk<CR>", desc = "Preview hunk" })
        map_local({ "<Leader>gr", "<Cmd>Gitsigns reset_hunk<CR>", desc = "Reset hunk" })
        map_local({ "<Leader>gR", "<Cmd>Gitsigns reset_buffer<CR>", desc = "Reset current buffer" })
        map_local({ "<Leader>gb", "<Cmd>Gitsigns blame_line<CR>", desc = "Blame this line" })
        map_local({ "<Leader>gd", "<Cmd>Gitsigns diffthis<CR>", desc = "Diffthis" })
        map_local({ "<Leader>ub", "<Cmd>Gitsigns toggle_current_line_blame<CR>", desc = "Toggle git blame" })
        map_local({
          "]h",
          function() require("gitsigns").nav_hunk("next", { navigation_message = false }) end,
          desc = "Next git hunk",
        })
        map_local({
          "[h",
          function() require("gitsigns").nav_hunk("prev", { navigation_message = false }) end,
          desc = "Previous git hunk",
        })
        map_local({
          "]H",
          function() require("gitsigns").nav_hunk("last", { navigation_message = false }) end,
          desc = "Last git hunk",
        })
        map_local({
          "[H",
          function() require("gitsigns").nav_hunk("first", { navigation_message = false }) end,
          desc = "First git hunk",
        })
        map_local({ "ih", ":<C-U>Gitsigns select_hunk<CR>", mode = { "o", "x" }, desc = "Git hunk" })
        map_local({ "ah", ":<C-U>Gitsigns select_hunk<CR>", mode = { "o", "x" }, desc = "Git hunk" })
      end,
    },
  },
  {
    "akinsho/toggleterm.nvim",
    cmd = "TermExec",
    keys = { { "<M-=>", desc = "Toggle terminal" } },
    opts = {
      open_mapping = "<M-=>",
      size = 10,
      float_opts = { title_pos = "center", border = "curved" },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized.dapui_config = dapui.open
      dap.listeners.before.event_terminated.dapui_config = dapui.close
      dap.listeners.before.event_exited.dapui_config = dapui.close
    end,
    dependencies = {
      "nvim-neotest/nvim-nio",
      {
        "mfussenegger/nvim-dap",
        config = function()
          local dap = require("dap")
          dap.adapters.codelldb = {
            type = "server",
            port = "${port}",
            executable = {
              command = vim.fn.exepath("codelldb"),
              args = { "--port", "${port}" },
            },
          }
        end,
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
    },
    keys = {
      { "<Leader>db", "<Cmd>DapToggleBreakpoint<CR>", desc = "Toggle breakpoint" },
      { "<Leader>dc", "<Cmd>DapContinue<CR>", desc = "Continue" },
      { "<Leader>d,", function() require("dap").run_last() end, desc = "Run last" },
      { "<Leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to cursor" },
      { "<Leader>dn", "<Cmd>DapStepOver<CR>", desc = "Step over" },
      { "<Leader>ds", "<Cmd>DapStepInto<CR>", desc = "Step into" },
      { "<Leader>do", "<Cmd>DapStepOut<CR>", desc = "Step out" },
      { "<Leader>dj", function() require("dap").down() end, desc = "Go down in current stacktrace" },
      { "<Leader>dk", function() require("dap").up() end, desc = "Go up in current stacktrace" },
      { "<Leader>dt", "<Cmd>DapTerminate<CR>", desc = "Terminate" },
      { "<Leader>dK", function() require("dapui").eval() end, desc = "Eval" },
      { "<Leader>du", function() require("dapui").toggle() end, desc = "Toggle UI" },
    },
  },
  {
    "stevearc/conform.nvim",
    init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
    dependencies = "WhoIsSethDaniel/mason-tool-installer.nvim",
    keys = {
      {
        "<Leader>cf",
        function() require("conform").format({ lsp_fallback = true }) end,
        desc = "Format document",
        mode = { "n", "v" },
      },
    },
    opts = {
      formatters_by_ft = {
        fish = { "fish_indent" },
        lua = { "stylua" },
        python = { "black" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    dependencies = "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = events.enter_buffer,
    opts = {
      events = { "BufWritePost", "BufReadPost" },
      linters_by_ft = { fish = { "fish" } },
      linters = {},
    },
    config = function(_, opts)
      local M = {}

      local lint = require("lint")
      for name, linter in pairs(opts.linters) do
        if type(linter) == "table" and type(lint.linters[name]) == "table" then
          lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
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
        group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
        callback = M.debounce(100, M.lint),
      })
    end,
  },
}
