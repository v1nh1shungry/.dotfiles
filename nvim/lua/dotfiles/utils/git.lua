---@class dotfiles.utils.Git
local M = {}

---@return string?
function M.root() return vim.fs.root(vim.fn.getcwd(), ".git") end

local ffi = require("ffi")

ffi.cdef([[
typedef struct git_repository git_repository;

int git_libgit2_init();
int git_repository_open(git_repository **out, const char *path);
void git_repository_free(git_repository *repo);

int git_ignore_path_is_ignored(int *ignored, git_repository *repo, const char *path);
int git_repository_is_shallow(git_repository *repo);
]])

local repo

local libgit2 = ffi.load("git2")
libgit2.git_libgit2_init()

local function load_git_repo()
  if repo then
    libgit2.git_repository_free(repo)
    repo = nil
  end

  local root = M.root()
  if root then
    local out = ffi.new("git_repository *[1]")
    assert(libgit2.git_repository_open(out, root) == 0)
    repo = out[0]
  end
end

vim.api.nvim_create_autocmd("DirChanged", {
  callback = load_git_repo,
  group = Dotfiles.augroup("utils.git"),
})

load_git_repo()

---@param path string
---@return boolean
function M.ignored(path)
  if not repo then return false end

  local out = ffi.new("int[1]")
  assert(libgit2.git_ignore_path_is_ignored(out, repo, path) == 0)
  return out[0] ~= 0
end

---@return boolean
function M.shallow()
  return repo and libgit2.git_repository_is_shallow(repo) == 1
end

return M
