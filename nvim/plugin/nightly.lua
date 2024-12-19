if not require("dotfiles.user").nightly then
  return
end

local BUILD_DIRECTORY = vim.fs.joinpath(vim.uv.os_tmpdir(), "dotfiles_neovim_nightly")
local INSTALL_DIRECTORY = vim.fs.joinpath(vim.fn.stdpath("data"), "nightly")
local INSTALL_METADATA_PATH = vim.fs.joinpath(INSTALL_DIRECTORY, "install-metadata.json")
local LOCKFILE = vim.fs.joinpath(vim.uv.os_tmpdir(), "NVIM_BUILDLOCK")
local TIMEOUT_SECS = require("dotfiles.user").nightly * 60 * 60

local augroup = Dotfiles.augroup("nightly")

-- FIXME: implement a **real** file lock here
local function lock()
  if vim.fn.filereadable(LOCKFILE) == 1 then
    return false
  end
  vim.fn.writefile({ tostring(vim.uv.os_getpid()) }, LOCKFILE)
  return true
end

local function unlock()
  vim.fs.rm(LOCKFILE, { force = true })
end

local function build_nightly()
  if not lock() then
    return
  end

  local meta
  if vim.fn.filereadable(INSTALL_METADATA_PATH) == 1 then
    meta = vim.json.decode(table.concat(vim.fn.readfile(INSTALL_METADATA_PATH), "\n"))
    if meta.date and os.time() - meta.date < TIMEOUT_SECS then
      unlock()
      return
    end
  end

  Snacks.notify.info("Start building nightly neovim...")

  local ret

  if vim.fn.isdirectory(BUILD_DIRECTORY) == 1 then
    ret = Dotfiles.async.system({ "git", "pull", "--rebase" }, { cwd = BUILD_DIRECTORY })
  else
    ret =
      Dotfiles.async.system({ "git", "clone", "--depth=1", "https://github.com/neovim/neovim.git", BUILD_DIRECTORY })
  end
  if ret.code ~= 0 then
    Snacks.notify.error("Failed to get the latest neovim source: " .. ret.stderr)
    unlock()
    return
  end

  ret = Dotfiles.async.system({ "git", "rev-parse", "HEAD" }, { cwd = BUILD_DIRECTORY, text = true })
  if ret.code ~= 0 then
    Snacks.notify.error("Failed to get HEAD SHA-1 of neovim repo: " .. ret.stderr)
    unlock()
    return
  end

  local latest_sha1 = ret.stdout
  if meta and meta.version and meta.version == latest_sha1 then
    Snacks.notify.info("Neovim has no update")
    unlock()
    return
  end

  ret = Dotfiles.async.system(
    { "make", "CMAKE_BUILD_TYPE=Release", "CMAKE_INSTALL_PREFIX=" .. INSTALL_DIRECTORY },
    { cwd = BUILD_DIRECTORY }
  )
  if ret.code ~= 0 then
    Snacks.notify.error("Failed to build nightly neovim: " .. ret.stderr)
    unlock()
    return
  end

  ret = Dotfiles.async.system({ "make", "install" }, { cwd = BUILD_DIRECTORY })
  if ret.code ~= 0 then
    Snacks.notify.error("Failed to install nightly neovim: " .. ret.stderr)
    unlock()
    return
  end

  Dotfiles.async.schedule()
  local usr_bin_path = vim.fs.joinpath(vim.uv.os_homedir(), ".local", "bin")
  if vim.tbl_contains(vim.split(vim.env.PATH, ":"), usr_bin_path) then
    vim.uv.fs_symlink(vim.fs.joinpath(INSTALL_DIRECTORY, "bin", "nvim"), vim.fs.joinpath(usr_bin_path, "nvim"))
  end

  Dotfiles.async.schedule()
  vim.fn.writefile({ vim.json.encode({
    version = latest_sha1,
    date = os.time(),
  }) }, INSTALL_METADATA_PATH)

  unlock()

  -- TODO: copy icons, desktop etc
  Snacks.notify.info("Complete building nightly neovim successfully")
end

vim.api.nvim_create_autocmd("User", {
  callback = function()
    Dotfiles.async.run(build_nightly)
  end,
  group = augroup,
  pattern = "VeryLazy",
})
