return {
  {
    "neovim/nvim-lspconfig",
    config = function(_, opts)
      -- shrink lsp log size
      local log_path = vim.lsp.log.get_filename()
      if vim.fn.getfsize(log_path) > 1.5 * 1024 * 1024 then
        vim.fn.writefile({}, log_path)
      end

      -- https://github.com/nvimdev/lspsaga.nvim {{{
      local peek_list = {}
      local PEEK_GROUP = Dotfiles.augroup("peek_definition")
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
          }
          if #peek_list > 0 then
            local prev_conf = vim.api.nvim_win_get_config(peek_list[#peek_list])
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
              table.remove(peek_list)
            end,
            group = PEEK_GROUP,
            pattern = tostring(winid),
          })
          peek_list[#peek_list + 1] = winid
        end)
      end
      -- }}}

      local on_attach = function(client, bufnr)
        local map_local = function(key)
          key.buffer = bufnr
          Dotfiles.map(key)
        end

        local mappings = {
          ["textDocument/rename"] = { "<Leader>cr", vim.lsp.buf.rename, desc = "Rename" },
          ["textDocument/codeAction"] = { "<Leader>ca", vim.lsp.buf.code_action, desc = "Code action" },
          ["textDocument/documentSymbol"] = {
            { "<Leader>ss", "<Cmd>Telescope lsp_document_symbols<CR>", desc = "LSP symbols (Document)" },
            { "gO", "<Cmd>Outline<CR>", desc = "Symbol outline" },
          },
          ["workspace/symbol"] = {
            "<Leader>sS",
            "<Cmd>Telescope lsp_workspace_symbols<CR>",
            desc = "LSP symbols (Workspace)",
          },
          ["textDocument/references"] = {
            { "gR", vim.lsp.buf.references, desc = "Go to references" },
            { "<Leader>sR", "<Cmd>Telescope lsp_references<CR>", desc = "LSP references" },
          },
          ["textDocument/definition"] = {
            { "gd", vim.lsp.buf.definition, desc = "Go to definition" },
            { "<Leader>sd", "<Cmd>Telescope lsp_definitions<CR>", desc = "LSP definitions" },
            { "<Leader>cp", peek_definition, desc = "Peek definition" },
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
          ["textDocument/inlayHint"] = function()
            Snacks.toggle.inlay_hints():map("<leader>uh", { buffer = bufnr })
          end,
          ["textDocument/signatureHelp"] = { "<C-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help" },
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
            group = Dotfiles.augroup("codelens"),
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
        group = Dotfiles.augroup("lsp_on_attach"),
      })

      -- https://www.lazyvim.org/plugins/lsp {{{
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        }
      )

      local all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      local ensure_installed = {}

      local function setup(server)
        if not opts.servers[server] then
          return
        end
        local setup_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
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

      -- https://github.com/kosayoda/nvim-lightbulb {{{
      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function(args)
          if vim.bo[args.buf].buftype ~= "" then
            return
          end

          local available = false
          for _, client in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
            if client.supports_method("textDocument/codeAction") then
              available = true
              break
            end
          end

          if not available then
            return
          end

          if vim.b[args.buf].lightbulb_cancel then
            pcall(vim.b[args.buf].lightbulb_cancel)
            vim.b[args.buf].lightbulb_cancel = nil
          end

          local params = vim.lsp.util.make_range_params(0, "utf-8")
          params.context = {
            diagnostics = vim.lsp.diagnostic.from(
              vim.diagnostic.get(args.buf, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
            ),
          }
          vim.b[args.buf].lightbulb_cancel = vim.F.npcall(
            vim.lsp.buf_request_all,
            args.buf,
            "textDocument/codeAction",
            params,
            function(res)
              local NS = Dotfiles.ns("lightbulb")

              vim.api.nvim_buf_clear_namespace(args.buf, NS, 0, -1)

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

              vim.api.nvim_buf_set_extmark(args.buf, NS, params.range.start.line, params.range.start.character + 1, {
                strict = false,
                virt_text = { { "💡", "DiagnosticVirtualTextInfo" } },
                virt_text_pos = "eol",
              })
            end
          )
        end,
        group = Dotfiles.augroup("lightbulb"),
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
          capabilities = {
            offsetEncoding = { "utf-8", "utf-16" },
            textDocument = {
              completion = {
                editsNearCursor = true,
              },
            },
          },
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
              "<Leader>;",
              "<Cmd>ClangdSwitchSourceHeader<CR>",
              desc = "Switch between header and source",
            },
            {
              "<Leader>uI",
              -- https://github.com/p00f/clangd_extensions.nvim/blob/main/lua/clangd_extensions/ast.lua {{{
              function()
                local node_pos = {}
                local detail_pos = {}
                local NS = Dotfiles.ns("clangd_ast")

                local function clear_highlight(source_buf)
                  vim.api.nvim_buf_clear_namespace(source_buf, NS, 0, -1)
                end

                local function update_highlight(source_buf, ast_buf)
                  clear_highlight(source_buf)
                  if vim.api.nvim_get_current_buf() ~= ast_buf then
                    return
                  end
                  local curline = vim.fn.getcurpos()[2]
                  local curline_ranges = node_pos[source_buf][ast_buf][curline]
                  if curline_ranges then
                    vim.highlight.range(source_buf, NS, "Search", curline_ranges.start, curline_ranges["end"], {
                      regtype = "v",
                      inclusive = false,
                      priority = 110,
                    })
                  end
                end

                local function setup_hl_autocmd(source_buf, ast_buf)
                  local AUGROUP = Dotfiles.augroup("clangd_ast_autocmds")
                  vim.api.nvim_create_autocmd("CursorMoved", {
                    group = AUGROUP,
                    buffer = ast_buf,
                    callback = function()
                      update_highlight(source_buf, ast_buf)
                    end,
                  })
                  vim.api.nvim_create_autocmd("BufLeave", {
                    group = AUGROUP,
                    buffer = ast_buf,
                    callback = function()
                      clear_highlight(source_buf)
                    end,
                  })
                end

                local function icon_prefix(role, kind)
                  local conf = Dotfiles.ui.icons.ast
                  if conf.kind_icons[kind] then
                    return conf.kind_icons[kind] .. "  "
                  elseif conf.role_icons[role] then
                    return conf.role_icons[role] .. "  "
                  else
                    return "   "
                  end
                end

                local function describe(role, kind, detail)
                  local str = ""
                  local icon = icon_prefix(role, kind)
                  local detailpos = nil
                  str = str .. kind
                  if
                    not (
                      role == "expression"
                      or role == "statement"
                      or role == "declaration"
                      or role == "template name"
                    )
                  then
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
                    detail_pos[hl_bufs.ast_buf][#result] = {
                      start = string.len(padding) + detpos.start,
                      ["end"] = string.len(padding) + detpos["end"],
                    }
                  end

                  if node.range then
                    node_pos[hl_bufs.source_buf][hl_bufs.ast_buf][#result] = {
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
                  for linenum, range in pairs(detail_pos[ast_buf]) do
                    vim.highlight.range(
                      ast_buf,
                      NS,
                      "Comment",
                      { linenum - 1, range.start },
                      { linenum - 1, range["end"] },
                      {
                        regtype = "v",
                        inclusive = false,
                        priority = 110,
                      }
                    )
                  end
                end

                local function handler(err, node)
                  if err or not node then
                    return
                  else
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

                    if not node_pos[source_buf] then
                      node_pos[source_buf] = {}
                    end
                    node_pos[source_buf][b.clangd_ast_buf] = {}
                    detail_pos[b.clangd_ast_buf] = {}

                    local lines = walk_tree(node, {}, {}, "", { source_buf = source_buf, ast_buf = b.clangd_ast_buf })
                    vim.bo.modifiable = true
                    vim.api.nvim_buf_set_lines(b.clangd_ast_buf, 0, -1, true, lines)
                    vim.bo.modifiable = false
                    setup_hl_autocmd(source_buf, b.clangd_ast_buf)
                    highlight_detail(b.clangd_ast_buf)
                  end
                end

                vim.lsp.buf_request(0, "textDocument/ast", {
                  textDocument = { uri = vim.uri_from_bufnr(0) },
                  range = {
                    start = { line = 0, character = 0 },
                    ["end"] = { line = vim.api.nvim_buf_line_count(0), character = 0 },
                  },
                }, handler)
              end,
              -- }}}
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
    dependencies = {
      {
        "hrsh7th/nvim-cmp",
        optional = true,
        opts = function(_, opts)
          table.insert(opts.sources or {}, { name = "lazydev", group_index = 0 })
        end,
      },
    },
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
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
    "hrsh7th/nvim-cmp",
    -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/cmp.lua {{{
    config = function(_, opts)
      for _, source in ipairs(opts.sources) do
        source.group_index = source.group_index or 1
      end

      ---@alias Placeholder {n:number, text:string}
      ---
      ---@param snippet string
      ---@param fn fun(placeholder:Placeholder):string
      ---@return string
      local function snippet_replace(snippet, fn)
        return snippet:gsub("%$%b{}", function(m)
          local n, name = m:match("^%${(%d+):(.+)}$")
          return n and fn({ n = n, text = name }) or m
        end) or snippet
      end

      -- This function resolves nested placeholders in a snippet.
      ---@param snippet string
      ---@return string
      local function snippet_preview(snippet)
        local ok, parsed = pcall(function()
          return vim.lsp._snippet_grammar.parse(snippet)
        end)
        return ok and tostring(parsed)
          or snippet_replace(snippet, function(placeholder)
            return snippet_preview(placeholder.text)
          end):gsub("%$0", "")
      end

      -- This function replaces nested placeholders in a snippet with LSP placeholders.
      local function snippet_fix(snippet)
        local texts = {} ---@type table<number, string>
        return snippet_replace(snippet, function(placeholder)
          texts[placeholder.n] = texts[placeholder.n] or snippet_preview(placeholder.text)
          return "${" .. placeholder.n .. ":" .. texts[placeholder.n] .. "}"
        end)
      end

      -- This function adds missing documentation to snippets.
      -- The documentation is a preview of the snippet.
      ---@param window cmp.CustomEntriesView|cmp.NativeEntriesView
      local function add_missing_snippet_docs(window)
        local cmp = require("cmp")
        local Kind = cmp.lsp.CompletionItemKind
        local entries = window:get_entries()
        for _, entry in ipairs(entries) do
          if entry:get_kind() == Kind.Snippet then
            local item = entry:get_completion_item()
            if not item.documentation and item.insertText then
              item.documentation = {
                kind = cmp.lsp.MarkupKind.Markdown,
                value = string.format("```%s\n%s\n```", vim.bo.filetype, snippet_preview(item.insertText)),
              }
            end
          end
        end
      end

      local parse = require("cmp.utils.snippet").parse
      require("cmp.utils.snippet").parse = function(input)
        local ok, ret = pcall(parse, input)
        if ok then
          return ret
        end
        return snippet_preview(input)
      end

      opts.snippet = {
        expand = function(item)
          -- Native sessions don't support nested snippet sessions.
          -- Always use the top-level session.
          -- Otherwise, when on the first placeholder and selecting a new completion,
          -- the nested session will be used instead of the top-level session.
          -- See: https://github.com/LazyVim/LazyVim/issues/3199
          local session = vim.snippet.active() and vim.snippet._session or nil

          local ok, err = pcall(vim.snippet.expand, item.body)
          if not ok then
            local fixed = snippet_fix(item.body)
            ok = pcall(vim.snippet.expand, fixed)

            local msg = ok and "Failed to parse snippet,\nbut was able to fix it automatically."
              or ("Failed to parse snippet.\n" .. err)

            Snacks.notify[ok and "warn" or "error"](
              ([[%s
```%s
%s
```]]):format(msg, vim.bo.filetype, item.body),
              { title = "vim.snippet" }
            )
          end

          -- Restore top-level session when needed
          if session then
            vim.snippet._session = session
          end
        end,
      }

      local cmp = require("cmp")
      cmp.setup(opts)
      cmp.event:on("menu_opened", function(event)
        add_missing_snippet_docs(event.window)
      end)
    end,
    -- }}}
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "lukas-reineke/cmp-rg",
    },
    event = Dotfiles.events.enter_insert,
    opts = function()
      local cmp = require("cmp")

      return {
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
            if cmp.core.view:visible() or vim.fn.pumvisible() == 1 then
              if not cmp.get_selected_entry() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
              else
                if vim.api.nvim_get_mode().mode == "i" then
                  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-G>u", true, true, true), "n", false)
                end
                cmp.confirm({
                  select = true,
                  behavior = cmp.ConfirmBehavior.Insert,
                })
              end
            elseif vim.snippet.active({ direction = 1 }) then
              vim.schedule(function()
                vim.snippet.jump(1)
              end)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.core.view:visible() or vim.fn.pumvisible() == 1 then
              cmp.select_prev_item()
            elseif vim.snippet.active({ direction = -1 }) then
              vim.schedule(function()
                vim.snippet.jump(-1)
              end)
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
