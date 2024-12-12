local readme = vim.fs.joinpath(vim.env.HOME, ".dotfiles", "README.md")
if vim.fn.filereadable(readme) == 0 then
  return
end
local contents = vim.fn.readfile(readme)

local function insert_section(section, marker)
  local function find_marker()
    local start_row
    for i, line in ipairs(contents) do
      if line == marker then
        if not start_row then
          start_row = i
        else
          return start_row, i
        end
      end
    end
  end

  local start_row, end_row = find_marker()
  if not (start_row and end_row) then
    vim.list_extend(contents, section)
  else
    local new_contents = vim.list_slice(contents, 1, start_row - 1)
    vim.list_extend(new_contents, section)
    vim.list_extend(new_contents, contents, end_row + 1)
    contents = new_contents
  end
end

local function update_nvim_plugins()
  local marker = "<!-- Neovim plugins -->"
  local section = {}
  for _, spec in ipairs(require("lazy").plugins()) do
    table.insert(section, ("* [%s](%s)"):format(spec[1], spec.url))
  end
  table.sort(section)
  table.insert(section, 1, "## Neovim plugins")
  table.insert(section, 1, marker)
  table.insert(section, marker)
  insert_section(section, marker)
end

local function update_vscode_extensions()
  local settings = vim.fs.joinpath(vim.env.HOME, ".vscode", "extensions", "extensions.json")
  if vim.fn.filereadable(settings) == 0 then
    return
  end
  local extensions = vim.fn.readfile(settings)
  local marker = "<!-- vscode extensions -->"
  local section = {}
  for _, spec in ipairs(vim.json.decode(table.concat(extensions, "\n"))) do
    local id = spec.identifier.id
    table.insert(section, ("* [%s](https://marketplace.visualstudio.com/items?itemName=%s)"):format(id, id))
  end
  table.sort(section)
  table.insert(section, 1, "## vscode extensions")
  table.insert(section, 1, marker)
  table.insert(section, marker)
  insert_section(section, marker)
end

vim.api.nvim_create_autocmd("User", {
  callback = function()
    update_nvim_plugins()
    update_vscode_extensions()
    vim.fn.writefile(contents, readme)
  end,
  group = vim.api.nvim_create_augroup("dotfiles_auto_update_readme_autocmds", {}),
  pattern = "LazyReload",
})
