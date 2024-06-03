local M = {}

function M.read(filename)
  if vim.fn.filereadable(filename) == 0 then
    return nil
  end
  return vim.fn.readfile(filename)
end

function M.write(content, filename, flag)
  filename = vim.uv.fs_realpath(filename) or filename
  local dirname = vim.fs.dirname(filename)
  if vim.fn.isdirectory(dirname) == 0 then
    vim.fn.mkdir(vim.fs.dirname(filename), "p")
  end
  vim.fn.writefile(unpack({ content, filename, flag }))
end

return M
