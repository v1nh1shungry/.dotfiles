local stylua_args = {
  "-",
  "--stdin-filepath",
  "${file}",
  "--collapse-simple-statement=FunctionOnly",
  "--indent-width=2",
  "--indent-type=Spaces",
  "--syntax=LuaJit",
}

return { ---@type vim.lsp.Config
  settings = {
    Lua = {
      completion = {
        autoRequire = false,
      },
      format = {
        externalTool = {
          program = "stylua",
          args = stylua_args,
        },
        externalToolRangeFormat = {
          program = "stylua",
          args = vim.list_extend(vim.deepcopy(stylua_args), {
            "--range-start=${start_offset}",
            "--range-end=${end_offset}",
          }),
        },
      },
    },
  },
}
