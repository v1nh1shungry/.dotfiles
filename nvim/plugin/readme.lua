local File = require("dotfiles.utils.file")
local filename = vim.fs.joinpath(vim.env.HOME, ".dotfiles", "README.md")
local contents = File.read(filename)
if not contents then
  return
end

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
  local plugins_section = {}
  for _, spec in ipairs(require("lazy").plugins()) do
    table.insert(plugins_section, ("* [%s](%s)"):format(spec[1], spec.url))
  end
  table.sort(plugins_section)
  table.insert(plugins_section, 1, "## Neovim plugins")
  table.insert(plugins_section, 1, marker)
  table.insert(plugins_section, marker)
  insert_section(plugins_section, marker)
end

local function update_vscode_extensions()
  local extensions = File.read(vim.fs.joinpath(vim.env.HOME, ".vscode", "extensions", "extensions.json"))
  if not extensions then
    return
  end
  local marker = "<!-- vscode extensions -->"
  local extensions_section = {}
  for _, spec in ipairs(vim.json.decode(table.concat(extensions, "\n"))) do
    local id = spec.identifier.id
    table.insert(extensions_section, ("* [%s](https://marketplace.visualstudio.com/items?itemName=%s)"):format(id, id))
  end
  table.sort(extensions_section)
  table.insert(extensions_section, 1, "## vscode extensions")
  table.insert(extensions_section, 1, marker)
  table.insert(extensions_section, marker)
  insert_section(extensions_section, marker)
end

local function update()
  update_nvim_plugins()
  update_vscode_extensions()
  File.write(contents, filename)
end

vim.api.nvim_create_autocmd("User", {
  callback = update,
  group = vim.api.nvim_create_augroup("dotfiles_auto_update_readme_autocmds", {}),
  pattern = "LazyReload",
})
