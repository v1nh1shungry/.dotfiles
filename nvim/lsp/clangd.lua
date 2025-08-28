return { ---@type vim.lsp.Config
  cmd = {
    "clangd",
    "--fallback-style=llvm",
    "--header-insertion=never",
    "-j=" .. vim.uv.available_parallelism(),
  },
  on_attach = function(client, bufnr)
    Dotfiles.map({
      "<Leader>ch",
      function()
        local params = vim.lsp.util.make_text_document_params(bufnr)
        ---@diagnostic disable-next-line: param-type-mismatch
        client:request("textDocument/switchSourceHeader", params, function(err, result)
          if err then
            error(tostring(err))
          end

          if not result then
            Dotfiles.notify("No corresponding file")
            return
          end

          vim.cmd.edit(vim.uri_to_fname(result))
        end, bufnr)
      end,
      buffer = bufnr,
      desc = "Switch Header/Source",
    })
  end,
}
