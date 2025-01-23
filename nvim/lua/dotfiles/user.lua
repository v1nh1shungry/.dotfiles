local M = {
  ---@type (string | LazyPluginSpec)[]
  extra = {},
  ui = {
    ---@type "dark" | "light"
    background = "dark",
    ---@type integer
    blend = 10,
    ---@type string
    colorscheme = "tokyonight",
  },
  task = {
    ---@type boolean
    save = true,
    ---@type table<string, string[]>
    compile = {},
    ---@type table<string, string[]>
    execute = {},
  },
  ---@type boolean | integer
  nightly = false,
}

local NVIMRC = vim.fs.joinpath(os.getenv("HOME"), ".nvimrc")
if vim.fn.filereadable(NVIMRC) == 1 then
  M = vim.tbl_deep_extend("force", M, dofile(NVIMRC))
end

return M
