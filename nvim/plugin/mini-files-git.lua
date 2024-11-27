---@type string?
local git_root = nil

local function is_git_repo()
  git_root = vim.fs.root(0, ".git")
  return git_root
end

---@class MiniFilesGitStatus
---@field index string
---@field workspace string
---
---@type table<string, MiniFilesGitStatus>
local git_status = {}

local priority = {
  [" "] = 0,
  ["?"] = 1,
  ["!"] = 1,
  T = 2,
  D = 3,
  C = 4,
  R = 4,
  A = 5,
  M = 7,
  U = 8,
}

---@param lines string[]
local function parse(lines)
  git_status = {}

  for _, line in ipairs(lines) do
    ---@type MiniFilesGitStatus
    local status = {
      index = line:sub(1, 1),
      workspace = line:sub(2, 2),
    }

    local path
    local _, rename_mark = line:find("->")
    if rename_mark then
      path = line:sub(rename_mark + 2)
    else
      path = line:sub(4)
    end

    git_status[vim.fs.normalize(vim.fs.joinpath(git_root, path))] = status

    for dir in vim.fs.parents(path) do
      local normalized_path = vim.fs.normalize(vim.fs.joinpath(git_root, dir))
      local old_status = git_status[normalized_path]
      if old_status then
        if priority[old_status.index] < priority[status.index] then
          git_status[normalized_path].index = status.index
        end
        if priority[old_status.workspace] < priority[status.workspace] then
          git_status[normalized_path].workspace = status.workspace
        end
      else
        git_status[normalized_path] = vim.deepcopy(status)
      end
    end
  end
end

---@type vim.SystemObj?
local job = nil

local function update_git_status()
  if job and not job:is_closing() then
    return
  end

  job = vim.system({
    "git",
    "-c",
    "status.relativePaths=false",
    "status",
    "--short",
  }, { text = true }, function(out)
    if out.code ~= 0 then
      Snacks.notify.error("Failed to fetch git status: " .. out.stderr)
      return
    end

    parse(vim.split(out.stdout, "\n", { trimempty = true }))
  end)

  return job
end

local ns = vim.api.nvim_create_namespace("dotfiles_mini_files_git_extmarks")

---@param buf integer
local function render_git_status(buf)
  if job and not job:is_closing() then
    job:wait()
  end

  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

  for i, l in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    local entry = require("mini.files").get_fs_entry(buf, i)
    if entry then
      local status = git_status[entry.path]
      if status then
        vim.api.nvim_buf_set_extmark(buf, ns, i - 1, #l, {
          virt_text = {
            { "[", "Comment" },
            { status.index, "GitSignsAdd" },
            { status.workspace, "GitSignsChange" },
            { "]", "Comment" },
          },
        })
      end
    end
  end
end

local augroup = vim.api.nvim_create_augroup("dotfiles_mini_files_git_autocmds", {})

local function initialize()
  vim.api.nvim_create_autocmd("User", {
    callback = update_git_status,
    group = augroup,
    pattern = { "MiniFilesExplorerOpen", "MiniFilesAction*" },
  })

  vim.api.nvim_create_autocmd("User", {
    callback = function(arg)
      -- make sure render the buffer after the status is updated
      vim.defer_fn(function()
        if job then
          render_git_status(arg.data.buf_id)
        else
          Snacks.notify.error("No background git process")
        end
      end, 50)
    end,
    group = augroup,
    pattern = "MiniFilesBufferUpdate",
  })
end

local function deinitialize() vim.api.nvim_clear_autocmds({ group = augroup }) end

vim.api.nvim_create_autocmd({ "DirChanged", "UIEnter" }, {
  callback = function()
    if is_git_repo() then
      initialize()
    else
      deinitialize()
    end
  end,
  group = vim.api.nvim_create_augroup("dotfiles_mini_files_git_monitor", {}),
})
