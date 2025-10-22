-- https://www.lazyvim.org/configuration/general#auto-commands {{{
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
  desc = "Check for external buffer changes",
  group = Dotfiles.augroup("core.autocmds.checktime"),
})

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(event)
    local exclude = { "gitcommit", "man" }
    local buf = event.buf
    if vim.list_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].dotfiles_last_loc then
      return
    end
    vim.b[buf].dotfiles_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "Move to last location",
  group = Dotfiles.augroup("core.autocmds.last_loc"),
})

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end

    vim.fn.mkdir(vim.fn.fnamemodify(vim.uv.fs_realpath(event.match) or event.match, ":p:h"), "p")
  end,
  desc = "Create directory if it doesn't exist",
  group = Dotfiles.augroup("core.autocmds.create-dir"),
})

do
  local function setup_minimal_ui()
    if vim.list_contains({ "help", "nofile" }, vim.bo.buftype) then
      vim.opt_local.buflisted = false
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
      vim.opt_local.colorcolumn = ""
      vim.opt_local.statuscolumn = ""
      vim.opt_local.signcolumn = "no"

      local ret = vim.fn.maparg("q", "n", false, true)
      if ret.buffer ~= 1 then
        Dotfiles.map({ "q", "<Cmd>close<CR>", buffer = true, desc = ":close" })
      end
    end
  end

  local augroup = Dotfiles.augroup("core.autocmds.minimal-ui")
  vim.api.nvim_create_autocmd({ "BufEnter", "BufRead" }, {
    callback = setup_minimal_ui,
    desc = "Setup minimal UI for nofile",
    group = augroup,
  })
  vim.api.nvim_create_autocmd({ "OptionSet" }, {
    callback = setup_minimal_ui,
    group = augroup,
    desc = "Setup minimal UI for nofile",
    pattern = "buftype",
  })
end
-- }}}

-- Inspired by https://github.com/keaising/im-select.nvim {{{
do
  local fcitx_cmd = nil

  if vim.fn.executable("fcitx5-remote") == 1 then
    fcitx_cmd = "fcitx5-remote"
  elseif vim.fn.executable("fcitx-remote") == 1 then
    fcitx_cmd = "fcitx-remote"
  end

  if fcitx_cmd then
    local augroup = Dotfiles.augroup("core.autocmds.switch-input-method")
    local previous_im

    ---@param enable? boolean
    local function activate_im(enable)
      if type(enable) ~= "boolean" then
        enable = true
      end
      vim.system({ fcitx_cmd, enable and "-o" or "-c" })
    end

    vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter", "TermEnter" }, {
      callback = function()
        if previous_im == "1" then
          activate_im(false)
        elseif previous_im == "2" then
          activate_im()
        end
      end,
      desc = "Automatically activate fcitx",
      group = augroup,
    })

    vim.api.nvim_create_autocmd({ "VimEnter", "InsertLeave", "CmdlineLeave", "TermLeave" }, {
      callback = function()
        vim.system({ fcitx_cmd }, { text = true }, function(out)
          -- FIXME: `nvim +Man!` would fail, don't know why.
          if out.code ~= 0 then
            vim.schedule(function() vim.api.nvim_del_augroup_by_id(augroup) end)
            return
          end

          previous_im = vim.trim(assert(out.stdout))
          activate_im(false)
        end)
      end,
      desc = "Automatically deactivate fcitx",
      group = augroup,
    })
  end
end
-- }}}

-- https://github.com/neovim/neovim/issues/16572#issuecomment-1954420136 {{{
do
  local augroup = Dotfiles.augroup("core.autocmds.sync-terminal-color")

  vim.api.nvim_create_autocmd({ "UIEnter", "ColorScheme" }, {
    callback = function()
      local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
      if normal.bg then
        io.write(string.format("\027]11;#%06x\027\\", normal.bg))
      end
    end,
    desc = "Sync terminal's background color",
    group = augroup,
  })

  vim.api.nvim_create_autocmd("UILeave", {
    callback = function() io.write("\027]111\027\\") end,
    desc = "Restore terminal's background color",
    group = augroup,
  })
end
-- }}}

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.highlight.on_yank() end,
  desc = "Highlight yanked text",
  group = Dotfiles.augroup("core.autocmds.highlight-on-yank"),
})
