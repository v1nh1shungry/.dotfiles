local function update()
  local File = require("dotfiles.utils.file")
  local filename = vim.fs.joinpath(vim.env.HOME, ".dotfiles", "README.md")
  local marker = "<!-- Neovim plugins -->"
  local contents = File.read(filename)
  if not contents then
    return
  end
  local plugins_section = {}
  for _, spec in ipairs(require("lazy").plugins()) do
    table.insert(plugins_section, ("* [%s](%s)"):format(spec[1], spec.url))
  end
  table.sort(plugins_section)
  table.insert(plugins_section, 1, "## Neovim plugins")
  table.insert(plugins_section, 1, marker)
  table.insert(plugins_section, marker)
  local start_row, end_row
  for i, line in ipairs(contents) do
    if line == marker then
      if not start_row then
        start_row = i
      elseif not end_row then
        end_row = i
        break
      end
    end
  end
  if not (start_row and end_row) then
    File.write(plugins_section, filename, "a")
  else
    local new_contents = vim.list_slice(contents, 1, start_row - 1)
    vim.list_extend(new_contents, plugins_section)
    vim.list_extend(new_contents, contents, end_row + 1)
    File.write(new_contents, filename)
  end
end

vim.api.nvim_create_autocmd("User", {
  callback = update,
  group = vim.api.nvim_create_augroup("dotfiles_auto_update_readme_autocmds", {}),
  pattern = "LazyReload",
})
