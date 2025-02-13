-- Modified from https://github.com/nvimdev/lspsaga.nvim {{{
local peek_stack = {}

-- FIXME: restore buffer
local function peek_definition()
  local params = vim.lsp.util.make_position_params(0, "utf-8")
  vim.lsp.buf_request(0, "textDocument/definition", params, function(_, result, _)
    if vim.islist(result) then
      result = result[1]
    end

    local buf = vim.uri_to_bufnr(result.targetUri or result.uri)
    local win_opts = {
      buf = buf,
      border = "rounded",
      height = math.floor(vim.o.lines * 0.5),
      position = "float",
      title = vim.api.nvim_buf_get_name(buf),
      title_pos = "center",
      width = math.floor(vim.o.columns * 0.6),
      zindex = 20,
    }

    if #peek_stack > 0 then
      local prev_conf = vim.api.nvim_win_get_config(peek_stack[#peek_stack])
      win_opts.col = prev_conf.col + 1
      win_opts.height = prev_conf.height - 1
      win_opts.row = prev_conf.row + 1
      win_opts.width = prev_conf.width - 2
    end

    local winid = Snacks.win(win_opts).win
    local range = result.targetSelectionRange or result.range
    vim.api.nvim_win_set_cursor(winid, {
      range.start.line + 1,
      vim.lsp.util._get_line_byte_from_position(buf, range.start, "utf-8"),
    })

    vim.api.nvim_create_autocmd("WinClosed", {
      callback = function()
        table.remove(peek_stack)
      end,
      pattern = tostring(winid),
    })

    peek_stack[#peek_stack + 1] = winid
  end)
end
-- }}}

-- https://github.com/kosayoda/nvim-lightbulb {{{
local LIGHTBULB_AUGROUP = Dotfiles.augroup("lightbulb")

local function attach_lightbulb(client, bufnr)
  if client.supports_method("textDocument/codeAction") then
    vim.api.nvim_create_autocmd("CursorHold", {
      buffer = bufnr,
      callback = function()
        if vim.bo[bufnr].buftype ~= "" then
          return
        end

        if vim.b[bufnr].lightbulb_cancel then
          pcall(vim.b[bufnr].lightbulb_cancel)
          vim.b[bufnr].lightbulb_cancel = nil
        end

        local params = vim.lsp.util.make_range_params(0, "utf-8")
        params.context = {
          diagnostics = vim.lsp.diagnostic.from(
            vim.diagnostic.get(bufnr, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
          ),
        }

        vim.b[bufnr].lightbulb_cancel = vim.F.npcall(
          vim.lsp.buf_request_all,
          bufnr,
          "textDocument/codeAction",
          params,
          function(res)
            local NS = Dotfiles.ns("lightbulb")

            vim.api.nvim_buf_clear_namespace(bufnr, NS, 0, -1)

            local has_action = false
            for _, r in pairs(res) do
              if r.result and not vim.tbl_isempty(r.result) then
                has_action = true
                break
              end
            end

            if not has_action then
              return
            end

            vim.api.nvim_buf_set_extmark(bufnr, NS, params.range.start.line, params.range.start.character + 1, {
              strict = false,
              virt_text = { { "💡" } },
              virt_text_pos = "eol",
            })
          end
        )
      end,
      group = LIGHTBULB_AUGROUP,
    })
  end
end
-- }}}

-- https://github.com/p00f/clangd_extensions.nvim/blob/main/lua/clangd_extensions/ast.lua {{{
local AST_NS = Dotfiles.ns("clangd_ast")
local ast_node_pos = {}
local ast_detail_pos = {}

-- TODO: refactor
local function clangd_ast()
  local function clear_highlight(source_buf)
    vim.api.nvim_buf_clear_namespace(source_buf, AST_NS, 0, -1)
  end

  local function update_highlight(source_buf, ast_buf)
    clear_highlight(source_buf)

    if vim.api.nvim_get_current_buf() ~= ast_buf then
      return
    end

    local curline = vim.fn.getcurpos()[2]
    local curline_ranges = ast_node_pos[source_buf][ast_buf][curline]
    if curline_ranges then
      vim.hl.range(source_buf, AST_NS, "Search", curline_ranges.start, curline_ranges["end"], {
        regtype = "v",
        inclusive = false,
        priority = 110,
      })
    end
  end

  local function setup_hl_autocmd(source_buf, ast_buf)
    vim.api.nvim_create_autocmd("CursorMoved", {
      buffer = ast_buf,
      callback = function()
        update_highlight(source_buf, ast_buf)
      end,
    })

    vim.api.nvim_create_autocmd("BufLeave", {
      buffer = ast_buf,
      callback = function()
        clear_highlight(source_buf)
      end,
    })
  end

  local function icon_prefix(role, kind)
    local icons = {
      role = {
        type = "",
        declaration = "",
        expression = "",
        specifier = "",
        statement = "",
        ["template argument"] = "",
      },
      kind = {
        Compound = "",
        Recovery = "",
        TranslationUnit = "",
        PackExpansion = "",
        TemplateTypeParm = "",
        TemplateTemplateParm = "",
        TemplateParamObject = "",
      },
    }

    if icons.kind[kind] then
      return icons.kind[kind] .. "  "
    elseif icons.role[role] then
      return icons.role[role] .. "  "
    else
      return "   "
    end
  end

  local function describe(role, kind, detail)
    local icon = icon_prefix(role, kind)
    local detailpos
    local str = kind

    if not (role == "expression" or role == "statement" or role == "declaration" or role == "template name") then
      str = str .. " " .. role
    end

    if detail then
      detailpos = {
        start = string.len(str) + vim.fn.strlen(icon) + 1,
        ["end"] = string.len(str) + vim.fn.strlen(icon) + string.len(detail) + 1,
      }
      str = str .. " " .. detail
    end

    return (icon .. str), detailpos
  end

  local function walk_tree(node, visited, result, padding, hl_bufs)
    visited[node] = true
    local str, detpos = describe(node.role, node.kind, node.detail)
    table.insert(result, padding .. str)

    if node.detail and detpos then
      ast_detail_pos[hl_bufs.ast_buf][#result] = {
        start = string.len(padding) + detpos.start,
        ["end"] = string.len(padding) + detpos["end"],
      }
    end

    if node.range then
      ast_node_pos[hl_bufs.source_buf][hl_bufs.ast_buf][#result] = {
        start = { node.range.start.line, node.range.start.character },
        ["end"] = { node.range["end"].line, node.range["end"].character },
      }
    end

    if node.children then
      for _, child in pairs(node.children) do
        if not visited[child] then
          walk_tree(child, visited, result, padding .. "  ", hl_bufs)
        end
      end
    end

    return result
  end

  local function highlight_detail(ast_buf)
    for linenum, range in pairs(ast_detail_pos[ast_buf]) do
      vim.hl.range(ast_buf, AST_NS, "Comment", { linenum - 1, range.start }, { linenum - 1, range["end"] }, {
        regtype = "v",
        inclusive = false,
        priority = 110,
      })
    end
  end

  local function handler(err, node)
    if err or not node then
      return
    end

    local source_buf = vim.api.nvim_get_current_buf()
    local b = vim.b[source_buf]

    if not b.clangd_ast_buf or not vim.api.nvim_buf_is_valid(b.clangd_ast_buf) then
      b.clangd_ast_buf = vim.api.nvim_create_buf(false, true)
      vim.bo[b.clangd_ast_buf].filetype = "ClangdAST"
      vim.bo[b.clangd_ast_buf].shiftwidth = 2
    end

    if not b.clangd_ast_win or not vim.api.nvim_win_is_valid(b.clangd_ast_win) then
      b.clangd_ast_win = vim.api.nvim_open_win(b.clangd_ast_buf, true, { split = "right" })
    else
      vim.cmd(vim.api.nvim_win_get_number(b.clangd_ast_win) .. " wincmd w")
    end

    if not ast_node_pos[source_buf] then
      ast_node_pos[source_buf] = {}
    end

    ast_node_pos[source_buf][b.clangd_ast_buf] = {}
    ast_detail_pos[b.clangd_ast_buf] = {}

    local lines = walk_tree(node, {}, {}, "", { source_buf = source_buf, ast_buf = b.clangd_ast_buf })
    vim.bo.modifiable = true
    vim.api.nvim_buf_set_lines(b.clangd_ast_buf, 0, -1, true, lines)
    vim.bo.modifiable = false
    setup_hl_autocmd(source_buf, b.clangd_ast_buf)
    highlight_detail(b.clangd_ast_buf)
  end

  vim.lsp.buf_request(0, "textDocument/ast", {
    textDocument = { uri = vim.uri_from_bufnr(0) },
    range = {
      start = { line = 0, character = 0 },
      ["end"] = { line = vim.api.nvim_buf_line_count(0), character = 0 },
    },
  }, handler)
end
-- }}}

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
          ["textDocument/codeAction"] = { "<Leader>ca", vim.lsp.buf.code_action, desc = "Code Action" },
          ["textDocument/documentSymbol"] = {
            {
              "<Leader>ss",
              function()
                Snacks.picker.lsp_symbols({ tree = false })
              end,
              desc = "LSP Symbols (Document)",
            },
            { "gO", "<Cmd>Outline<CR>", desc = "Symbol Outline" },
          },
          ["workspace/symbol"] = {
            "<Leader>sS",
            function()
              Snacks.picker.lsp_workspace_symbols({ tree = false })
            end,
            desc = "LSP Symbols (Workspace)",
          },
          ["textDocument/references"] = {
            { "gR", vim.lsp.buf.references, desc = "Goto References" },
            {
              "<Leader>sR",
              function()
                Snacks.picker.lsp_references()
              end,
              desc = "LSP References",
            },
          },
          ["textDocument/definition"] = {
            { "gd", vim.lsp.buf.definition, desc = "Goto Definition" },
            {
              "<Leader>sd",
              function()
                Snacks.picker.lsp_definitions()
              end,
              desc = "LSP Definitions",
            },
            { "<Leader>cp", peek_definition, desc = "Peek Definition" },
          },
          ["textDocument/declaration"] = {
            { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
            {
              "<Leader>sD",
              function()
                Snacks.picker.lsp_declarations()
              end,
              desc = "LSP Declarations",
            },
          },
          ["textDocument/typeDefinition*"] = {
            { "gy", vim.lsp.buf.type_definition, desc = "Goto Type Definition" },
            {
              "<Leader>sy",
              function()
                Snacks.picker.lsp_type_definitions()
              end,
              desc = "LSP Type Definitions",
            },
          },
          ["textDocument/implementation*"] = {
            { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
            {
              "<Leader>sI",
              function()
                Snacks.picker.lsp_implementations()
              end,
              desc = "LSP Implementations",
            },
          },
          ["callHierarchy/incomingCalls"] = { "<Leader>ci", vim.lsp.buf.incoming_calls, desc = "Incoming Calls" },
          ["callHierarchy/outgoingCalls"] = { "<Leader>co", vim.lsp.buf.outgoing_calls, desc = "Outgoing Calls" },
          ["textDocument/inlayHint"] = function()
            Snacks.toggle.inlay_hints():map("<leader>uh", { buffer = bufnr })
          end,
          ["typeHierarchy/subtypes"] = {
            "<Leader>cs",
            function()
              vim.lsp.buf.typehierarchy("subtypes")
            end,
            desc = "LSP Subtypes",
          },
          ["typeHierarchy/supertypes"] = {
            "<Leader>cS",
            function()
              vim.lsp.buf.typehierarchy("supertypes")
            end,
            desc = "LSP Supertypes",
          },
          ["textDocument/documentHighlight"] = {
            {
              "]]",
              function()
                Snacks.words.jump(vim.v.count1)
              end,
              desc = "Next Reference",
            },
            {
              "[[",
              function()
                Snacks.words.jump(-vim.v.count1)
              end,
              desc = "Previous Reference",
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

        attach_lightbulb(client, bufnr)
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
              desc = "Switch Header/Source",
            },
            { "<Leader>cA", clangd_ast, desc = "Clangd AST" },
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
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
      },
    },
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
        desc = "Format Document",
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
