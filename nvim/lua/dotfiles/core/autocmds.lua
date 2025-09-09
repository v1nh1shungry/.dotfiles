-- https://www.lazyvim.org/configuration/general#auto-commands {{{
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
  desc = "Automatically check if any buffers were changed outside of Nvim",
  group = Dotfiles.augroup("checktime"),
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
  group = Dotfiles.augroup("last_loc"),
})

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end

    vim.fn.mkdir(vim.fn.fnamemodify(vim.uv.fs_realpath(event.match) or event.match, ":p:h"), "p")
  end,
  desc = "Automatically create directory if not exists",
  group = Dotfiles.augroup("auto_create_dir"),
})

do
  local minimal_options = {
    bo = {
      buflisted = false,
    },
    wo = {
      number = false,
      relativenumber = false,
      colorcolumn = "",
      statuscolumn = "",
      signcolumn = "no",
    },
  }

  local function setup_minimal_ui()
    if vim.list_contains({ "help", "nofile" }, vim.bo.buftype) then
      local b_restore_ui = {}
      local w_restore_ui = {}

      for opt, value in pairs(minimal_options.bo) do
        b_restore_ui[opt] = vim.bo[opt]
        vim.bo[opt] = value
      end
      for opt, value in pairs(minimal_options.wo) do
        w_restore_ui[opt] = vim.wo[opt]
        vim.wo[opt] = value
      end

      vim.b.restore_minimal_ui = b_restore_ui
      vim.w.restore_minimal_ui = w_restore_ui

      local ret = vim.fn.maparg("q", "n", false, true)
      if ret.buffer ~= 1 then
        Dotfiles.map({ "q", "<Cmd>close<CR>", buffer = true, desc = ":close (minimal)" })
      end
    else
      for opt, value in pairs(vim.b.restore_minimal_ui or {}) do
        vim.bo[opt] = value
      end
      for opt, value in pairs(vim.w.restore_minimal_ui or {}) do
        vim.wo[opt] = value
      end

      local map_desc = vim.fn.maparg("q", "n", false, true).desc
      if map_desc and map_desc == ":close (minimal)" then
        vim.keymap.del("n", "q", { buffer = true })
      end
    end
  end

  local augroup = Dotfiles.augroup("minimal_ui")
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
if vim.fn.executable("fcitx5-remote") == 1 then
  local augroup = Dotfiles.augroup("im")
  local previous_im

  local function get_current_im() return vim.trim(vim.fn.system("fcitx5-remote")) end

  ---@param enable? boolean
  local function activate_im(enable)
    if type(enable) ~= "boolean" then
      enable = true
    end
    vim.fn.system({ "fcitx5-remote", enable and "-o" or "-c" })
  end

  vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
    callback = Dotfiles.co.void(function()
      if previous_im == "1" then
        activate_im(false)
      elseif previous_im == "2" then
        activate_im()
      end
    end),
    desc = "Automatically activate Fcitx5 if needed",
    group = augroup,
  })

  vim.api.nvim_create_autocmd({ "VimEnter", "InsertLeave", "CmdlineLeave" }, {
    callback = Dotfiles.co.void(function()
      previous_im = get_current_im()
      activate_im(false)
    end),
    desc = "Automatically deactivate Fcitx5",
    group = augroup,
  })
end
-- }}}

-- https://github.com/neovim/neovim/issues/16572#issuecomment-1954420136 {{{
do
  local augroup = Dotfiles.augroup("sync_terminal_color")

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
