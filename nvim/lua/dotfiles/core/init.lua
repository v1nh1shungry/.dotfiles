_G.Dotfiles = require("dotfiles.utils")

vim.filetype.add({
  filename = { ["nvim.user"] = "lua" },
  pattern = {
    [".*/kitty/.+%.conf"] = "kitty",
    ["%.env%.[%w_.-]+"] = "sh",
  },
})

vim.treesitter.language.register("bash", "kitty")

vim.diagnostic.config({
  float = { border = "rounded" },
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float({
        bufnr = bufnr,
        scope = "cursor",
        focus = false,
      })
    end,
  },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.HINT] = "",
      [vim.diagnostic.severity.INFO] = "",
    },
  },
})

-- https://www.lazyvim.org/ {{{
do
  local notifs = {}
  local function temp(...) table.insert(notifs, vim.F.pack_len(...)) end

  local orig = vim.notify
  vim.notify = temp

  local timer = assert(vim.uv.new_timer())
  local check = assert(vim.uv.new_check())

  local replay = function()
    timer:stop()
    check:stop()

    if vim.notify == temp then
      vim.notify = orig -- put back the original notify if needed
    end

    vim.schedule(function()
      ---@diagnostic disable-next-line: no-unknown
      for _, notif in ipairs(notifs) do
        vim.notify(vim.F.unpack_len(notif))
      end
    end)
  end

  -- wait till vim.notify has been replaced
  check:start(function()
    if vim.notify ~= temp then
      replay()
    end
  end)
  -- or if it took more than 1s, then something went wrong
  timer:start(1000, 0, replay)
end
-- }}}

---@diagnostic disable-next-line: duplicate-set-field
vim.deprecate = function() end

require("dotfiles.core.autocmds")
require("dotfiles.core.keymaps")
require("dotfiles.core.options")
require("dotfiles.core.lazy")
require("dotfiles.core.lsp")

-- should execute after colorscheme plugins are loaded
vim.cmd("colorscheme " .. Dotfiles.user.colorscheme)
