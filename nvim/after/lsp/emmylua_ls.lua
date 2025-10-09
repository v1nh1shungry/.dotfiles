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
      runtime = {
        version = "LuaJIT",
      },
      workspace = {
        library = get_library(),
      },
    },
  },
}
