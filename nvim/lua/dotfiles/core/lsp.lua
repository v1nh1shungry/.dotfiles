Dotfiles.lsp.on_attach(function(client, bufnr)
  local map = Dotfiles.map_with({ buffer = bufnr })

  -- TODO: separate plugin-driven mappings
  local mappings = { ---@type table<string, dotfiles.utils.map.Opts|dotfiles.utils.map.Opts[]>
    ["textDocument/rename"] = { "<Leader>cr", vim.lsp.buf.rename, desc = "Rename" },
    ["textDocument/codeAction"] = { "<Leader>ca", vim.lsp.buf.code_action, desc = "Code Action" },
    ["textDocument/documentSymbol"] = {
      {
        "<Leader>ss",
        function() Snacks.picker.lsp_symbols({ tree = false }) end,
        desc = "LSP Symbols (Document)",
      },
      { "gO", "<Cmd>Outline<CR>", desc = "Symbol Outline" },
    },
    ["workspace/symbol"] = {
      "<Leader>sS",
      function() Snacks.picker.lsp_workspace_symbols({ tree = false }) end,
      desc = "LSP Symbols (Workspace)",
    },
    ["textDocument/references"] = {
      { "gR", vim.lsp.buf.references, desc = "Goto References" },
      { "<Leader>sR", function() Snacks.picker.lsp_references() end, desc = "LSP References" },
    },
    ["textDocument/definition"] = {
      { "gd", vim.lsp.buf.definition, desc = "Goto Definition" },
      { "<Leader>sd", function() Snacks.picker.lsp_definitions() end, desc = "LSP Definitions" },
    },
    ["textDocument/declaration"] = {
      { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
      { "<Leader>sD", function() Snacks.picker.lsp_declarations() end, desc = "LSP Declarations" },
    },
    ["textDocument/typeDefinition*"] = {
      { "gy", vim.lsp.buf.type_definition, desc = "Goto Type Definition" },
      { "<Leader>sy", function() Snacks.picker.lsp_type_definitions() end, desc = "LSP Type Definitions" },
    },
    ["textDocument/implementation*"] = {
      { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
      { "<Leader>sI", function() Snacks.picker.lsp_implementations() end, desc = "LSP Implementations" },
    },
    ["callHierarchy/incomingCalls"] = { "<Leader>ci", vim.lsp.buf.incoming_calls, desc = "Incoming Calls" },
    ["callHierarchy/outgoingCalls"] = { "<Leader>co", vim.lsp.buf.outgoing_calls, desc = "Outgoing Calls" },
    ["typeHierarchy/subtypes"] = {
      "<Leader>cs",
      function() vim.lsp.buf.typehierarchy("subtypes") end,
      desc = "LSP Subtypes",
    },
    ["typeHierarchy/supertypes"] = {
      "<Leader>cS",
      function() vim.lsp.buf.typehierarchy("supertypes") end,
      desc = "LSP Supertypes",
    },
    ["textDocument/documentHighlight"] = {
      { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference" },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Previous Reference" },
    },
  }

  for method, keys in pairs(mappings) do
    if client:supports_method(method) then
      if type(keys[1]) == "string" then
        map(keys)
      else
        for _, k in
          ipairs(keys --[=[@as dotfiles.utils.map.Opts[]]=])
        do
          map(k)
        end
      end
    end
  end

  if
    client:supports_method("textDocument/inlayHint")
    and vim.api.nvim_buf_is_valid(bufnr)
    and vim.bo[bufnr].buftype == ""
  then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    Snacks.toggle.inlay_hints():map("<leader>uh", { buffer = bufnr })
  end

  if client:supports_method("textDocument/codeLens") then
    vim.lsp.codelens.refresh()
    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
      buffer = bufnr,
      callback = vim.lsp.codelens.refresh,
    })
  end

  if client:supports_method("textDocument/foldingRange") then
    vim.wo[vim.api.nvim_get_current_win()][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
  end
end)

vim.lsp.enable({
  "clangd",
  "jsonls",
  "lua_ls",
  "neocmake",
})
