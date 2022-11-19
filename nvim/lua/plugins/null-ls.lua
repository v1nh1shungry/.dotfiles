return function()
  local actions = require('null-ls').builtins.code_actions
  local diagnostics = require('null-ls').builtins.diagnostics
  local formatting = require('null-ls').builtins.formatting

  require('null-ls').setup {
    sources = {
      actions.gitsigns,
      actions.shellcheck,
      diagnostics.cmake_lint,
      diagnostics.fish,
      diagnostics.pylint,
      formatting.autopep8,
      formatting.cmake_format,
      formatting.shfmt,
    },
    on_attach = function(client, bufnr)
      if client.supports_method('textDocument/formatting') then
        vim.api.nvim_create_autocmd('BufWritePre', {
          buffer = bufnr,
          callback = function() vim.lsp.buf.format({ bufnr = bufnr }) end,
        })
      end
    end,
  }
end
