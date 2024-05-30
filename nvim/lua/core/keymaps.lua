local map = require("utils.keymap")
local toggle = require("utils.toggle")

vim.keymap.del("n", "grn")
vim.keymap.del("n", "grr")
vim.keymap.del("n", "gra")
vim.keymap.del("i", "<C-s>")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

map({ "<Leader>qq", "<Cmd>qa!<CR>", desc = "Quit" })

map({ "<C-s>", "<Cmd>w<CR><Esc>", desc = "Save", mode = { "i", "x", "n", "s" } })

map({ "<Esc><Esc>", "<C-\\><C-n>", mode = "t" })

map({ "<", "<gv", mode = "v" })
map({ ">", ">gv", mode = "v" })

map({ "<Leader>xq", toggle.quickfix, desc = "Toggle quickfix" })

map({ "<Leader>xl", toggle.location, desc = "Toggle location list" })

map({ "<Leader>ux", require("utils.toggle").diagnostic, desc = "Toggle diagnostic" })

map({ ",", ",<c-g>u", mode = "i" })
map({ ".", ".<c-g>u", mode = "i" })
map({ ";", ";<c-g>u", mode = "i" })

map({ "j", "v:count == 0 ? 'gj' : 'j'", expr = true, desc = "Down", mode = { "n", "x" } })
map({ "k", "v:count == 0 ? 'gk' : 'k'", expr = true, desc = "Up", mode = { "n", "x" } })

map({ "gV", '"`[" . strpart(getregtype(), 0, 1) . "`]"', expr = true, desc = "Visually select changed text" })

map({ "<Leader><Tab>q", "<Cmd>tabclose<CR>", desc = "Close tab" })
map({ "<Leader><Tab><Tab>", "<Cmd>tabnew<CR>", desc = "New tab" })
map({ "]<Tab>", function() return "<Cmd>+" .. vim.v.count1 .. "tabnext<CR>" end, desc = "Next tab", expr = true })
map({ "[<Tab>", function() return "<Cmd>-" .. vim.v.count1 .. "tabnext<CR>" end, desc = "Previous tab", expr = true })

map({ "<Leader>,", "<Cmd>e #<CR>", desc = "Last buffer" })

map({ "<Leader>uc", toggle.option("conceallevel", false, { 0, 3 }), desc = "Toggle conceal" })
map({ "<Leader>uw", toggle.option("wrap"), desc = "Toggle wrap" })
map({ "<Leader>ug", toggle.option("background", false, { "light", "dark" }), desc = "Set background" })

map({ "<Leader>fc", "<Cmd>e ~/.nvimrc<CR>", desc = "Open preferences" })

map({ "<C-j>", "<Cmd>m .+1<CR>==", desc = "Move down" })
map({ "<C-k>", "<Cmd>m .-2<CR>==", desc = "Move up" })
map({ "<C-j>", "<Esc><Cmd>m .+1<Cr>==gi", mode = "i", desc = "Move Down" })
map({ "<C-k>", "<Esc><Cmd>m .-2<Cr>==gi", mode = "i", desc = "Move Up" })
map({ "<C-j>", ":m '>+1<CR>gv=gv", mode = "v", desc = "Move down" })
map({ "<C-k>", ":m '<-2<CR>gv=gv", mode = "v", desc = "Move up" })

map({
  "[<Space>",
  "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>",
  desc = "Put empty line above",
})
map({
  "]<Space>",
  "<Cmd>call append(line('.'), repeat([''], v:count1))<CR>",
  desc = "Put empty line below",
})

map({ "<Leader>l", "<Cmd>Lazy home<CR>", desc = "Lazy" })

map({ "<Leader>fU", "<Cmd>earlier 1f<CR>", desc = "Give up modifications" })

map({ "$", "g_", mode = "x", desc = "End of line" })

map({ "<Leader>ui", "<Cmd>Inspect<CR>", desc = "Inspect position under the cursor" })
map({ "<Leader>uI", "<Cmd>InspectTree<CR>", desc = "Treesitter Tree" })

map({ "<C-n>", "<Down>", desc = "Next command in history", mode = "c" })
map({ "<C-p>", "<Up>", desc = "Previous command in history", mode = "c" })

map({
  "<Leader>mp",
  function()
    if vim.fn.mkdir("cmake", "p") == 0 then
      vim.notify("CPM.cmake: can't create 'cmake' directory", vim.log.levels.ERROR)
      return
    end
    vim.notify("Downloading CPM.cmake...")
    vim.system({
      "wget",
      "-O",
      "cmake/CPM.cmake",
      "https://github.com/cpm-cmake/CPM.cmake/releases/latest/download/get_cpm.cmake",
    }, {}, function(out)
      if out.code == 0 then
        vim.notify("CPM.cmake: downloaded cmake/CPM.cmake successfully")
      else
        vim.notify("CPM.cmake: failed to download CPM.cmake", vim.log.levels.ERROR)
      end
    end)
  end,
  desc = "Get CPM.cmake",
})

map({
  "<Leader>cx",
  function()
    vim.cmd([[execute "normal! \<ESC>"]])
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local current_bufnr = vim.api.nvim_get_current_buf()
    local current_winnr = vim.api.nvim_win_get_number(vim.api.nvim_get_current_win())
    local lines = vim.api.nvim_buf_get_lines(current_bufnr, start_pos[2] - 1, end_pos[2], true)
    vim.api.nvim_buf_set_lines(current_bufnr, start_pos[2] - 1, end_pos[2], true, {})
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.bo[bufnr].filetype = vim.bo[current_bufnr].filetype
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)
    vim.api.nvim_open_win(bufnr, true, { split = "right" })
    vim.cmd([[execute "normal! =G"]])
    vim.bo[bufnr].modifiable = false
    vim.cmd(current_winnr .. " wincmd w")
  end,
  mode = "x",
  desc = "Snapshot",
})

map({ "gco", "o<Esc>Vcx<Esc><Cmd>normal gcc<Cr>fxa<Bs>", desc = "Add Comment Below" })
map({ "gcO", "O<Esc>Vcx<Esc><Cmd>normal gcc<Cr>fxa<Bs>", desc = "Add Comment Above" })

map({ "<Leader>um", toggle.maximize, desc = "Maximize current window" })

map({ "[Q", "<Cmd>cfirst<CR>", desc = "First quickfix" })
map({ "]Q", "<Cmd>clast<CR>", desc = "Last quickfix" })

map({ "<Leader>fs", "<Cmd>luafile %<CR>", desc = "Souce" })
