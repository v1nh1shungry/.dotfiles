if not require("dotfiles.user").nightly then
  return
end

local BUILD_DIRECTORY = vim.fs.joinpath(vim.uv.os_tmpdir(), "dotfiles_neovim_nightly")
local INSTALL_DIRECTORY = vim.fs.joinpath(vim.fn.stdpath("data"), "nightly")
local INSTALL_METADATA_PATH = vim.fs.joinpath(INSTALL_DIRECTORY, "install-metadata.json")
local LOCKFILE = vim.fs.joinpath(vim.uv.os_tmpdir(), "DOTFILES_NVIM_NIGHTLY_BUILDLOCK")
local TIMEOUT_SECS = require("dotfiles.user").nightly * 60 * 60
local USR_BIN_PATH = vim.fs.joinpath(vim.uv.os_homedir(), ".local", "bin", "nvim")

local AUGROUP = Dotfiles.augroup("nightly")

local function unlock()
  if vim.fn.filereadable(LOCKFILE) == 1 then
    vim.fs.rm(LOCKFILE, { force = true })
  end
end

-- FIXME: implement a **real** file lock here
local function lock()
  if vim.fn.filereadable(LOCKFILE) == 1 then
    -- TODO: maybe too noisy
    Snacks.notify.warn("There is another session holding the lock, please wait for it")
    return false
  end
  vim.fn.writefile({ tostring(vim.uv.os_getpid()) }, LOCKFILE)
  vim.api.nvim_create_autocmd("VimLeave", {
    callback = unlock,
    group = AUGROUP,
  })
  return true
end

local function fetch()
  local ret
  if vim.fn.isdirectory(BUILD_DIRECTORY) == 1 then
    ret = Dotfiles.async.system({ "git", "checkout", "master" }, { cwd = BUILD_DIRECTORY })
    if ret.code ~= 0 then
      Snacks.notify.error("Failed to checkout master branch")
      return false
    end
    ret = Dotfiles.async.system({ "git", "pull", "--rebase" }, { cwd = BUILD_DIRECTORY })
  else
    ret =
      Dotfiles.async.system({ "git", "clone", "--depth=1", "https://github.com/neovim/neovim.git", BUILD_DIRECTORY })
  end

  if ret.code ~= 0 then
    Snacks.notify.error("Failed to get the latest neovim source: " .. ret.stderr)
    return false
  end

  return true
end

local function get_metadata()
  if vim.fn.filereadable(INSTALL_METADATA_PATH) == 1 then
    Dotfiles.async.schedule()
    return vim.json.decode(table.concat(vim.fn.readfile(INSTALL_METADATA_PATH), "\n"))
  end
end

local function get_head_sha1()
  local ret = Dotfiles.async.system({ "git", "rev-parse", "HEAD" }, { cwd = BUILD_DIRECTORY, text = true })
  if ret.code ~= 0 then
    Snacks.notify.error("Failed to get HEAD SHA-1 of neovim repo: " .. ret.stderr)
    return
  end
  return vim.trim(ret.stdout)
end

-- TODO: copy icons, desktop etc
local function compile_and_install()
  local ret = Dotfiles.async.system(
    { "make", "CMAKE_BUILD_TYPE=Release", "CMAKE_INSTALL_PREFIX=" .. INSTALL_DIRECTORY },
    { cwd = BUILD_DIRECTORY }
  )
  if ret.code ~= 0 then
    Snacks.notify.error("Failed to build nightly neovim: " .. ret.stderr)
    return false
  end

  ret = Dotfiles.async.system({ "make", "install" }, { cwd = BUILD_DIRECTORY })
  if ret.code ~= 0 then
    Snacks.notify.error("Failed to install nightly neovim: " .. ret.stderr)
    return false
  end

  Dotfiles.async.schedule()
  if vim.list_contains(vim.split(vim.env.PATH, ":"), vim.fs.dirname(USR_BIN_PATH)) then
    vim.uv.fs_symlink(vim.fs.joinpath(INSTALL_DIRECTORY, "bin", "nvim"), USR_BIN_PATH)
  end

  return true
end

---@param force boolean
local function build_nightly(force)
  if not lock() then
    return
  end

  local meta = get_metadata()
  if not force and meta and meta.date and os.time() - meta.date < TIMEOUT_SECS then
    unlock()
    return
  end

  Snacks.notify.info("Start building nightly neovim...")

  if not fetch() then
    unlock()
    return
  end

  local latest_sha1 = get_head_sha1()
  if not latest_sha1 then
    unlock()
    return
  end

  if meta and meta.version and meta.version == latest_sha1 then
    Snacks.notify.info("Neovim has no update")
    unlock()
    return
  end

  if not compile_and_install() then
    unlock()
    return
  end

  Dotfiles.async.schedule()
  vim.fn.writefile(
    { vim.json.encode({ rollback = meta.version, version = latest_sha1, date = os.time() }) },
    INSTALL_METADATA_PATH
  )

  unlock()

  Snacks.notify.info("Complete building nightly neovim successfully")
end

vim.api.nvim_create_autocmd("User", {
  callback = function()
    Dotfiles.async.run(build_nightly)
  end,
  group = AUGROUP,
  pattern = "VeryLazy",
})

-- TODO: can load updated first
-- TODO: print error msg in the dashboard
-- TODO: turn #XXX into PR links
local function dashboard()
  if not lock() then
    return
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].filetype = "markdown"

  local TITLE = "Neovim Nightly Dashboard"
  local win = Snacks.win({
    buf = buf,
    width = 0.7,
    height = 0.7,
    border = "rounded",
    title = TITLE .. " (Updating...)",
    title_pos = "center",
  }).win

  if not fetch() then
    unlock()
    return
  end

  local meta = get_metadata()

  local cmd = { "git", "log", "--oneline", "--no-decorate" }
  if meta and meta.version then
    table.insert(cmd, meta.version .. "..HEAD")
  end

  local contents = {}

  local ret = Dotfiles.async.system(cmd, { cwd = BUILD_DIRECTORY, text = true })
  if ret.code == 0 then
    local updates = vim.split(ret.stdout, "\n", { trimempty = true })
    if #updates > 0 then
      table.insert(contents, "# Updates")
      vim.list_extend(
        contents,
        vim
          .iter(updates)
          :map(function(l)
            return "* " .. l
          end)
          :totable()
      )
      table.insert(contents, "")
    end
  else
    Snacks.notify.error("Failed to fetch git history: " .. ret.stderr)
  end

  if meta and meta.version then
    cmd = { "git", "log", "--oneline", "--no-decorate" }
    if meta.rollback then
      table.insert(cmd, meta.rollback .. ".." .. meta.version)
    else
      table.insert(cmd, meta.version)
    end

    ret = Dotfiles.async.system(cmd, { cwd = BUILD_DIRECTORY, text = true })
    if ret.code == 0 then
      local updated = vim.split(ret.stdout, "\n", { trimempty = true })
      if #updated > 0 then
        table.insert(contents, "# Updated")
        vim.list_extend(
          contents,
          vim
            .iter(updated)
            :map(function(l)
              return "* " .. l
            end)
            :totable()
        )
      end
    else
      Snacks.notify.error("Failed to get git history: " .. ret.stderr)
    end
  end

  unlock()

  Dotfiles.async.schedule()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, contents)
  vim.api.nvim_win_set_config(win, vim.tbl_extend("force", vim.api.nvim_win_get_config(win), { title = TITLE }))
end

local function rollback()
  if not lock() then
    return
  end

  local meta = get_metadata()
  if not meta or not meta.rollback then
    Snacks.notify.error("Failed to get last neovim nightly SHA1")
    unlock()
    return
  end

  Snacks.notify.info("Start rolling neovim back to " .. meta.rollback)

  if not fetch() then
    unlock()
    return
  end

  local ret = Dotfiles.async.system({ "git", "checkout", meta.rollback }, { cwd = BUILD_DIRECTORY })
  if ret.code ~= 0 then
    Snacks.notify.error("Failed to checkout " .. meta.rollback)
    unlock()
    return
  end

  if not compile_and_install() then
    unlock()
    return
  end

  Dotfiles.async.schedule()
  vim.fn.writefile({ vim.json.encode({ version = meta.rollback, date = os.time() }) }, INSTALL_METADATA_PATH)

  unlock()
  Snacks.notify.info("Complete rolling back neovim successfully")
end

Dotfiles.map({
  "<Leader>pnn",
  function()
    Dotfiles.async.run(dashboard)
  end,
  desc = "Neovim nightly dashboard",
})
Dotfiles.map({
  "<Leader>pnb",
  function()
    Dotfiles.async.run(build_nightly, true)
  end,
  desc = "Build neovim nightly",
})
Dotfiles.map({
  "<Leader>pnr",
  function()
    Dotfiles.async.run(rollback)
  end,
  desc = "Rollback neovim nightly",
})
