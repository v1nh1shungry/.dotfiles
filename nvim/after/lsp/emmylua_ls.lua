local stylua_args = {
  "-",
  "--stdin-filepath",
  "${file}",
  "--collapse-simple-statement=FunctionOnly",
  "--indent-width=2",
  "--indent-type=Spaces",
  "--syntax=LuaJit",
}

---@return string[]
local function get_library()
  local plugins_root = require("lazy.core.config").options.root
  local library = { vim.fs.joinpath("$VIMRUNTIME", "lua") }
  for dir, type in vim.fs.dir(plugins_root) do
    if type == "directory" then
      table.insert(library, vim.fs.joinpath(plugins_root, dir, "lua"))
    end
  end
  return library
end

return {
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
      runtime = {
        version = "LuaJIT",
      },
      workspace = {
        library = get_library(),
      },
    },
  },
}
