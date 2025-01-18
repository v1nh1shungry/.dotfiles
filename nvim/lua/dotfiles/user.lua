local M = {
  extra = {},
  ui = {
    background = "dark",
    blend = 10,
    colorscheme = "tokyonight",
  },
  task = {
    save = true,
    compile = {},
    execute = {},
  },
  nightly = false,
}

local NVIMRC = vim.fs.joinpath(os.getenv("HOME"), ".nvimrc")
if vim.fn.filereadable(NVIMRC) == 1 then
  M = vim.tbl_deep_extend("force", M, dofile(NVIMRC))
end

return M
