-- TODO: dashboard
if not Dotfiles.user.nightly then
  return
end

---@class dotfiles.nightly.Metadata
---@field last_update integer
---@field current string
---@field latest string
---@field rollback? string

local NIGHTLY_DIRECTORY = vim.fs.joinpath(vim.fn.stdpath("data"), "nightly")
local NIGHTLY_METADATA_DIRECTORY = vim.fs.joinpath(NIGHTLY_DIRECTORY, "install-metadata.json")
local LOCKFILE = vim.fs.joinpath(NIGHTLY_DIRECTORY, "LOCK")
local TIMEOUT_SECS = Dotfiles.user.nightly * 60 * 60

local USR_LOCAL_DIRECTORY = vim.fs.joinpath(vim.env.HOME, ".local")
local USR_BIN_DIRECTORY = vim.fs.joinpath(USR_LOCAL_DIRECTORY, "bin")

local GITHUB_PROXY = "https://gh-proxy.com/"
local ASSET_NAME = "nvim-linux-x86_64"
local ASSET_PACKAGE_NAME = ASSET_NAME .. ".tar.gz"

local AUGROUP = Dotfiles.augroup("nightly")

if vim.fn.isdirectory(NIGHTLY_DIRECTORY) == 0 then
  vim.fn.mkdir(NIGHTLY_DIRECTORY)
end

local ffi = require("ffi")

ffi.cdef([[
int lockf(int fd, int cmd, long len);
]])

local F_TLOCK = 2
local F_ULOCK = 0

local LOCK_FD = vim.uv.fs_open(LOCKFILE, "w", tonumber("0644", 8))

local function unlock()
  ffi.C.lockf(LOCK_FD, F_ULOCK, 0)
end

---@param force? boolean
local function lock(force)
  if ffi.C.lockf(LOCK_FD, F_TLOCK, 0) == -1 then
    if force then
      Snacks.notify.warn("There is another session holding the lock, please wait for it")
    end

    return false
  end

  Dotfiles.async.api.nvim_create_autocmd("VimLeave", {
    callback = unlock,
    group = AUGROUP,
  })

  return true
end

---@async
---@param url string
local function api(url)
  local res = Dotfiles.async.system({ "curl", "-fsSL", url })
  if res.code ~= 0 then
    Snacks.notify.error(("Failed to request %s: %s"):format(url, res.stderr))
    return
  end

  return vim.json.decode(res.stdout)
end

local function read_metadata()
  if Dotfiles.async.fn.filereadable(NIGHTLY_METADATA_DIRECTORY) == 1 then
    return vim.json.decode(table.concat(Dotfiles.async.fn.readfile(NIGHTLY_METADATA_DIRECTORY), "\n"))
  end
end

---@param metadata dotfiles.nightly.Metadata
local function write_metadata(metadata)
  metadata.last_update = os.time()
  Dotfiles.async.fn.writefile({ vim.json.encode(metadata) }, NIGHTLY_METADATA_DIRECTORY)
end

---@async
---@param version string
---@return boolean
local function install(version)
  local VERSION_DIR = vim.fs.joinpath(NIGHTLY_DIRECTORY, version)

  local res = Dotfiles.async.system({
    "ln",
    "-sf",
    vim.fs.joinpath(VERSION_DIR, "bin", "nvim"),
    vim.fs.joinpath(USR_BIN_DIRECTORY, "nvim"),
  })

  if res.code ~= 0 then
    Snacks.notify.error("Failed to install binary: " .. res.stderr)
    return false
  end

  local ENTRY_PATH = vim.fs.joinpath(USR_LOCAL_DIRECTORY, "share", "applications", "nvim.desktop")

  res = Dotfiles.async.system({
    "install",
    "-Dm644",
    vim.fs.joinpath(VERSION_DIR, "share", "applications", "nvim.desktop"),
    "-T",
    ENTRY_PATH,
  })

  if res.code ~= 0 then
    Snacks.notify.error("Failed to install desktop entry: " .. res.stderr)
    return false
  end

  res = Dotfiles.async.system({
    "sed",
    "-i",
    "s|Icon=nvim|Icon="
      .. vim.fs.joinpath(VERSION_DIR, "share", "icons", "hicolor", "128x128", "apps", "nvim.png")
      .. "|g",
    ENTRY_PATH,
  })

  if res.code ~= 0 then
    Snacks.notify.error("Failed to install desktop entry: " .. res.stderr)
    return false
  end

  res = Dotfiles.async.system({
    "sed",
    "-i",
    "s|Exec=nvim|Exec=" .. vim.fs.joinpath(USR_BIN_DIRECTORY, "nvim") .. "|g",
    ENTRY_PATH,
  })

  if res.code ~= 0 then
    Snacks.notify.error("Failed to install desktop entry: " .. res.stderr)
    return false
  end

  res = Dotfiles.async.system({
    "install",
    "-Dm444",
    vim.fs.joinpath(VERSION_DIR, "share", "man", "man1", "nvim.1"),
    "-t",
    vim.fs.joinpath(USR_LOCAL_DIRECTORY, "share", "man", "man1"),
  })

  if res.code ~= 0 then
    Snacks.notify.error("Failed to install man page: " .. res.stderr)
    return false
  end

  return true
end

---@async
---@param force? boolean
local function update(force)
  if not lock(force) then
    return
  end

  ---@type dotfiles.nightly.Metadata
  local metadata = read_metadata() or {}
  if not force and metadata.last_update and os.time() - metadata.last_update < TIMEOUT_SECS then
    unlock()
    return
  end

  Snacks.notify.info("Start updating nightly neovim")

  local release = api("https://api.github.com/repos/neovim/neovim/releases/tags/nightly")
  if not release then
    unlock()
    return
  end

  if metadata.latest and metadata.latest == release.target_commitish then
    Snacks.notify.info("No update for nightly neovim")

    if metadata.current ~= metadata.latest and install(metadata.latest) then
      metadata.current = metadata.latest
    end

    write_metadata(metadata)

    unlock()
    return
  end

  local url
  for _, asset in ipairs(release.assets) do
    if asset.name == ASSET_PACKAGE_NAME then
      url = asset.browser_download_url
      break
    end
  end

  if not url then
    Snacks.notify.error("No available package in github release")
    unlock()
    return
  end

  local res = Dotfiles.async.system({
    "curl",
    "-fsSLO",
    GITHUB_PROXY .. url,
  }, { cwd = vim.uv.os_tmpdir() })

  if res.code ~= 0 then
    Snacks.notify.error("Failed to download nightly neovim package: " .. res.stderr)
    unlock()
    return
  end

  local package_path = vim.fs.joinpath(vim.uv.os_tmpdir(), ASSET_PACKAGE_NAME)
  res = Dotfiles.async.system({
    "tar",
    "xf",
    package_path,
    "--transform",
    ("s/%s/%s/"):format(ASSET_NAME, release.target_commitish),
    "--directory",
    NIGHTLY_DIRECTORY,
  })

  if res.code ~= 0 then
    Snacks.notify.error("Failed to extract nightly neovim package: " .. res.stderr)
    unlock()
    return
  end

  if metadata.rollback and metadata.rollback ~= metadata.latest then
    vim.fs.rm(vim.fs.joinpath(NIGHTLY_DIRECTORY, metadata.rollback), { recursive = true, force = true })
  end

  if install(release.target_commitish) then
    metadata.rollback = metadata.latest
    metadata.latest = release.target_commitish
    metadata.current = metadata.latest

    write_metadata(metadata)

    Snacks.notify.info("Complete updating nightly neovim")
  end

  unlock()

  vim.fs.rm(package_path, { force = true })
end

local function rollback()
  if not lock(true) then
    return
  end

  ---@type dotfiles.nightly.Metadata
  local metadata = read_metadata() or {}
  if not metadata.rollback or metadata.current == metadata.rollback then
    Snacks.notify.warn("No available rollback")
    unlock()
    return
  end

  if install(metadata.rollback) then
    metadata.current = metadata.rollback
    write_metadata(metadata)
    Snacks.notify.info("Complete rolling back nightly neovim")
  end

  unlock()
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    Dotfiles.async.run(update)
  end,
  group = AUGROUP,
})

Dotfiles.map({
  "<Leader>pnu",
  Dotfiles.async.void(function()
    update(true)
  end),
  desc = "Update",
})
Dotfiles.map({
  "<Leader>pnr",
  Dotfiles.async.void(rollback),
  desc = "Rollback",
})
