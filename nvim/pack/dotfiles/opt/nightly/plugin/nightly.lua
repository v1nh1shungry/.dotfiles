if not Dotfiles.user.nightly then
  return
end

---@class dotfiles.nightly.Metadata
---@field last_update integer
---@field current string
---@field latest string
---@field rollback? string

local NIGHTLY_DIRECTORY = vim.fs.joinpath(vim.fn.stdpath("data"), "nightly")
local NIGHTLY_METADATA_PATH = vim.fs.joinpath(NIGHTLY_DIRECTORY, "install-metadata.json")
local LOCKFILE = vim.fs.joinpath(NIGHTLY_DIRECTORY, "LOCK")
local TIMEOUT_SECS = Dotfiles.user.nightly * 60 * 60

local USR_LOCAL_DIRECTORY = vim.fs.joinpath(vim.env.HOME, ".local")
local USR_BIN_DIRECTORY = vim.fs.joinpath(USR_LOCAL_DIRECTORY, "bin")

local GITHUB_REPO_NAME = "neovim"
if vim.version.cmp(Dotfiles.C.glibc_version(), "2.31") <= 0 then
  GITHUB_REPO_NAME = "neovim-releases"
end

local ASSET_NAME = "nvim-linux-x86_64"
local ASSET_PACKAGE_NAME = ASSET_NAME .. ".tar.gz"

local AUGROUP = Dotfiles.augroup("nightly")

local LOCK_FD = assert(vim.uv.fs_open(LOCKFILE, "w", tonumber("0644", 8)))

if vim.fn.isdirectory(NIGHTLY_DIRECTORY) == 0 then
  vim.fn.mkdir(NIGHTLY_DIRECTORY)
end

local function unlock() Dotfiles.C.lock(LOCK_FD, false) end

---@async
---@param force? boolean
---@return boolean
local function lock(force)
  if Dotfiles.C.lock(LOCK_FD) == -1 then
    if force then
      Dotfiles.notify.warn("There is another session holding the lock, please wait for it")
    end

    return false
  end

  Dotfiles.co.api.nvim_create_autocmd("VimLeave", {
    callback = unlock,
    group = AUGROUP,
  })

  return true
end

---@async
---@param url string
---@return table?
local function api(url)
  local res = Dotfiles.co.system({ "curl", "-fsSL", url })
  if res.code ~= 0 then
    Dotfiles.notify.error("Failed to request %s: %s", url, res.stderr)
    return nil
  end

  return vim.json.decode(res.stdout)
end

---@async
---@return dotfiles.nightly.Metadata?
local function read_metadata()
  if Dotfiles.co.fn.filereadable(NIGHTLY_METADATA_PATH) == 1 then
    return vim.json.decode(table.concat(Dotfiles.co.fn.readfile(NIGHTLY_METADATA_PATH), "\n"))
  end

  return nil
end

---@async
---@param metadata dotfiles.nightly.Metadata
local function write_metadata(metadata)
  metadata.last_update = os.time()
  Dotfiles.co.fn.writefile({ vim.json.encode(metadata) }, NIGHTLY_METADATA_PATH)
end

---@async
---@param id string
---@return boolean
local function install(id)
  local TARGET_DIR = vim.fs.joinpath(NIGHTLY_DIRECTORY, id)

  local res = Dotfiles.co.system({
    "ln",
    "-sf",
    vim.fs.joinpath(TARGET_DIR, "bin", "nvim"),
    vim.fs.joinpath(USR_BIN_DIRECTORY, "nvim"),
  })

  if res.code ~= 0 then
    Dotfiles.notify.error("Failed to install binary: " .. res.stderr)
    return false
  end

  local DESKTOP_ENTRY_PATH = vim.fs.joinpath(USR_LOCAL_DIRECTORY, "share", "applications", "nvim.desktop")

  res = Dotfiles.co.system({
    "install",
    "-Dm644",
    vim.fs.joinpath(TARGET_DIR, "share", "applications", "nvim.desktop"),
    "-T",
    DESKTOP_ENTRY_PATH,
  })

  if res.code ~= 0 then
    Dotfiles.notify.error("Failed to install desktop entry: " .. res.stderr)
    return false
  end

  res = Dotfiles.co.system({
    "sed",
    "-i",
    "s|Icon=nvim|Icon="
      .. vim.fs.joinpath(TARGET_DIR, "share", "icons", "hicolor", "128x128", "apps", "nvim.png")
      .. "|g",
    DESKTOP_ENTRY_PATH,
  })

  if res.code ~= 0 then
    Dotfiles.notify.error("Failed to install desktop entry: " .. res.stderr)
    return false
  end

  res = Dotfiles.co.system({
    "sed",
    "-i",
    "s|Exec=nvim|Exec=" .. vim.fs.joinpath(USR_BIN_DIRECTORY, "nvim") .. "|g",
    DESKTOP_ENTRY_PATH,
  })

  if res.code ~= 0 then
    Dotfiles.notify.error("Failed to install desktop entry: " .. res.stderr)
    return false
  end

  res = Dotfiles.co.system({
    "install",
    "-Dm444",
    vim.fs.joinpath(TARGET_DIR, "share", "man", "man1", "nvim.1"),
    "-t",
    vim.fs.joinpath(USR_LOCAL_DIRECTORY, "share", "man", "man1"),
  })

  if res.code ~= 0 then
    Dotfiles.notify.error("Failed to install man page: " .. res.stderr)
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

  local metadata = read_metadata() or {}
  if not force and metadata.last_update and os.time() - metadata.last_update < TIMEOUT_SECS then
    unlock()
    return
  end

  Dotfiles.notify("Start updating nightly neovim")

  local release = api(("https://api.github.com/repos/neovim/%s/releases/tags/nightly"):format(GITHUB_REPO_NAME))
  if not release then
    unlock()
    return
  end

  if metadata.latest and metadata.latest == release.id then
    Dotfiles.notify("No update for nightly neovim")

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
    Dotfiles.notify.error("No available nightly neovim package")
    unlock()
    return
  end

  local res = Dotfiles.co.system({ "curl", "-fsSLO", url }, { cwd = vim.uv.os_tmpdir() })

  if res.code ~= 0 then
    Dotfiles.notify.error("Failed to download nightly neovim package: " .. res.stderr)
    unlock()
    return
  end

  local package_path = vim.fs.joinpath(vim.uv.os_tmpdir(), ASSET_PACKAGE_NAME)
  res = Dotfiles.co.system({
    "tar",
    "xf",
    package_path,
    "--transform",
    ("s/%s/%s/"):format(ASSET_NAME, release.id),
    "--directory",
    NIGHTLY_DIRECTORY,
  })

  if res.code ~= 0 then
    Dotfiles.notify.error("Failed to extract nightly neovim package: " .. res.stderr)
    unlock()
    return
  end

  if metadata.rollback and metadata.rollback ~= metadata.latest then
    vim.fs.rm(vim.fs.joinpath(NIGHTLY_DIRECTORY, metadata.rollback), { recursive = true, force = true })
  end

  if install(release.id) then
    metadata.rollback = metadata.latest
    metadata.latest = release.id
    metadata.current = metadata.latest

    write_metadata(metadata)

    Dotfiles.notify("Complete updating nightly neovim")
  end

  unlock()

  vim.fs.rm(package_path, { force = true })
end

---@async
local function rollback()
  if not lock(true) then
    return
  end

  local metadata = read_metadata() or {}
  if not metadata.rollback or metadata.current == metadata.rollback then
    Dotfiles.notify.warn("No available rollback")
    unlock()
    return
  end

  if install(metadata.rollback) then
    metadata.current = metadata.rollback
    write_metadata(metadata)
    Dotfiles.notify("Complete rolling back nightly neovim")
  end

  unlock()
end

Dotfiles.co.run(update)

Dotfiles.map({ "<Leader>pnu", Dotfiles.co.void(update, true), desc = "Update" })
Dotfiles.map({ "<Leader>pnr", Dotfiles.co.void(rollback), desc = "Rollback" })
