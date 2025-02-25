-- https://www.lazyvim.org/configuration/general#auto-commands {{{
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
  group = Dotfiles.augroup("checktime"),
})

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank({ timeout = 500 })
  end,
  group = Dotfiles.augroup("highlight_yank"),
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
  group = Dotfiles.augroup("last_loc"),
})

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
  group = Dotfiles.augroup("auto_create_dir"),
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
  group = Dotfiles.augroup("resize_splits"),
})

-- FIXME: `InspectTree` buffer does not setup minimal UI
vim.api.nvim_create_autocmd({ "BufEnter", "BufRead" }, {
  callback = function(args)
    if vim.list_contains({ "help", "nofile", "quickfix" }, vim.bo.buftype) then
      vim.opt_local.buflisted = false
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
      vim.opt_local.cc = ""
      vim.opt_local.stc = ""
      vim.opt_local.foldcolumn = "0"
      vim.opt_local.signcolumn = "no"

      local ret = vim.fn.maparg("q", "n", false, true)
      if ret.buffer ~= 1 then
        vim.schedule(function()
          Dotfiles.map({
            "q",
            function()
              vim.cmd("close")
              pcall(vim.api.nvim_buf_delete, args.buf, { force = true })
            end,
            buffer = args.buf,
            desc = "Close",
          })
        end)
      end
    end
  end,
  group = Dotfiles.augroup("minimal_ui"),
})

vim.api.nvim_create_autocmd("FileType", {
  command = "setlocal wrap",
  group = Dotfiles.augroup("wrap"),
  pattern = { "gitcommit", "markdown", "text" },
})
-- }}}

local toggle_num_augroup = Dotfiles.augroup("toggle_number")
vim.api.nvim_create_autocmd({ "CmdlineEnter", "InsertEnter", "WinLeave" }, {
  command = "if &number | set norelativenumber | end",
  group = toggle_num_augroup,
})
vim.api.nvim_create_autocmd({ "CmdlineLeave", "InsertLeave", "WinEnter" }, {
  command = "if &number | set relativenumber | end",
  group = toggle_num_augroup,
})
