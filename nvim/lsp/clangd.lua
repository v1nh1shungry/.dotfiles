Dotfiles.lsp.on_attach(function(client, bufnr)
  Dotfiles.map({
    "<Leader>cs",
    function()
      local params = vim.lsp.util.make_text_document_params(bufnr)
      client:request("textDocument/switchSourceHeader", params, function(err, result)
        if err then error(tostring(err)) end
        if not result then
          vim.notify("No corresponding file")
          return
        end
        vim.cmd.edit(vim.uri_to_fname(result))
      end, bufnr)
    end,
    buffer = bufnr,
    desc = "Switch Header/Source",
  })
end, "clangd")

return { ---@type vim.lsp.Config
  capabilities = {
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
    },
    offsetEncoding = { "utf-8", "utf-16" },
  },
  cmd = {
    "clangd",
    "--fallback-style=llvm",
    "--header-insertion=never",
    "-j=" .. vim.uv.available_parallelism(),
  },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
  root_markers = {
    ".clangd",
    ".clang-tidy",
    ".clang-format",
    "compile_commands.json",
    "compile_flags.txt",
    "configure.ac",
    ".git",
  },
}
