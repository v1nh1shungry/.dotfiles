local map = Dotfiles.map

-- https://github.com/echasnovski/mini.operators {{{
local function remove_lsp_mapping(mapping)
  mapping.mode = mapping.mode or { "n" }

  if type(mapping.mode) == "string" then
    mapping.mode = { mapping.mode }
  end

  for _, m in ipairs(mapping.mode) do
    local map_desc = vim.fn.maparg(mapping[1], m, false, true).desc
    if map_desc and string.find(map_desc, "vim%.lsp") then
      vim.keymap.del(m, mapping[1])
    end
  end
end

remove_lsp_mapping({ "grn" })
remove_lsp_mapping({ "grr" })
remove_lsp_mapping({ "gra", mode = { "n", "x" } })
remove_lsp_mapping({ "gri" })
remove_lsp_mapping({ "gO" })
remove_lsp_mapping({ "<C-s>", mode = "i" })
-- }}}

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.bo[args.buf].tagfunc = nil
    vim.bo[args.buf].omnifunc = nil
  end,
  group = Dotfiles.augroup("disable_default_lsp_mappings"),
})

vim.g.mapleader = vim.keycode("<Space>")
vim.g.maplocalleader = "\\"

map({ "<C-q>", "<Cmd>bd<CR>", desc = "Close Buffer" })
map({ "<Leader>qq", "<Cmd>qa!<CR>", desc = "Quit" })

map({ "<C-s>", "<Cmd>w<CR><Esc>", desc = "Save", mode = { "i", "x", "n", "s" } })

map({ "<", "<gv", mode = "v" })
map({ ">", ">gv", mode = "v" })

map({ ",", ",<C-g>u", mode = "i" })
map({ ".", ".<C-g>u", mode = "i" })
map({ ";", ";<C-g>u", mode = "i" })

map({ "j", "v:count == 0 ? 'gj' : 'j'", expr = true, desc = "Down", mode = { "n", "x" } })
map({ "k", "v:count == 0 ? 'gk' : 'k'", expr = true, desc = "Up", mode = { "n", "x" } })
map({ "<Down>", "v:count == 0 ? 'gj' : 'j'", expr = true, desc = "Down", mode = { "n", "x" } })
map({ "<Up>", "v:count == 0 ? 'gk' : 'k'", expr = true, desc = "Up", mode = { "n", "x" } })

map({ "gV", '"`[" . strpart(getregtype(), 0, 1) . "`]"', expr = true, desc = "Visually Select Changed Text" })

map({ "<Leader><Tab>q", "<Cmd>tabclose<CR>", desc = "Close Tab" })
map({ "<Leader><Tab><Tab>", "<Cmd>tabnew<CR>", desc = "New Tab" })
map({ "[<S-Tab>", "<Cmd>tabfirst<CR>", desc = "First Tab" })
map({ "]<S-Tab>", "<Cmd>tablast<CR>", desc = "Last Tab" })
map({
  "]<Tab>",
  function()
    vim.cmd("+" .. vim.v.count1 .. "tabnext")
  end,
  desc = "Next Tab",
})
map({
  "[<Tab>",
  function()
    vim.cmd("-" .. vim.v.count1 .. "tabnext")
  end,
  desc = "Previous Tab",
})

map({ "<Leader>bn", "<Cmd>enew<CR>", desc = "New Buffer" })

map({
  "<Leader>fc",
  function()
    local NVIMRC = vim.fs.joinpath(os.getenv("HOME"), ".nvimrc")
    vim.cmd("edit " .. NVIMRC)

    if vim.fn.filereadable(NVIMRC) == 0 then
      local lines = vim.split(vim.inspect(Dotfiles.user), "\n")
      lines[1] = "return " .. lines[1]
      vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    end
  end,
  desc = "Edit Local Configuration",
})

map({ "<C-j>", "<Cmd>m .+1<CR>==", desc = "Move Down" })
map({ "<C-k>", "<Cmd>m .-2<CR>==", desc = "Move Up" })
map({ "<C-j>", ":m '>+1<CR>gv=gv", mode = "v", desc = "Move Down" })
map({ "<C-k>", ":m '<-2<CR>gv=gv", mode = "v", desc = "Move Up" })

map({ "<Leader>pl", "<Cmd>Lazy home<CR>", desc = "Lazy" })

map({ "<Leader>fU", "<Cmd>earlier 1f<CR>", desc = "Drop Modifications" })

map({ "$", "g_", mode = "x", desc = "End of Line" })

map({ "<Leader>ui", "<Cmd>Inspect<CR>", desc = "Inspect Position" })
map({ "<Leader>uI", "<Cmd>InspectTree<CR>", desc = "Treesitter Tree" })

map({
  "]w",
  function()
    vim.diagnostic.jump({ count = vim.v.count1, severity = vim.diagnostic.severity.WARN })
  end,
  desc = "Goto Next Warning",
})
map({
  "[w",
  function()
    vim.diagnostic.jump({ count = -vim.v.count1, severity = vim.diagnostic.severity.WARN })
  end,
  desc = "Goto Previous Warning",
})
map({
  "]e",
  function()
    vim.diagnostic.jump({ count = vim.v.count1, severity = vim.diagnostic.severity.ERROR })
  end,
  desc = "Goto Next Error",
})
map({
  "[e",
  function()
    vim.diagnostic.jump({ count = -vim.v.count1, severity = vim.diagnostic.severity.ERROR })
  end,
  desc = "Goto Previous Error",
})
map({
  "]W",
  function()
    vim.diagnostic.jump({ count = math.huge, severity = vim.diagnostic.severity.WARN, wrap = false })
  end,
  desc = "Goto Last Warning",
})
map({
  "[W",
  function()
    vim.diagnostic.jump({ count = -math.huge, severity = vim.diagnostic.severity.WARN, wrap = false })
  end,
  desc = "Goto First Warning",
})
map({
  "]E",
  function()
    vim.diagnostic.jump({ count = math.huge, severity = vim.diagnostic.severity.ERROR, wrap = false })
  end,
  desc = "Goto Last Error",
})
map({
  "[E",
  function()
    vim.diagnostic.jump({ count = -math.huge, severity = vim.diagnostic.severity.ERROR, wrap = false })
  end,
  desc = "Goto First Error",
})

map({ "<Leader>xx", vim.diagnostic.setloclist, desc = "Document Diagnostics" })
map({ "<Leader>xX", vim.diagnostic.setqflist, desc = "Workspace Diagnostics" })

map({ "<BS>", "<C-o>s", mode = "s" })

map({ "<Esc>", "<Cmd>noh<CR><Esc>", mode = { "i", "n" }, desc = "Escape and Clear Highlight" })

map({
  "dm",
  function()
    local input = vim.F.npcall(function()
      return string.char(vim.fn.getchar())
    end)
    if not input then
      return
    end
    pcall(vim.cmd.delmark, input)
  end,
  desc = "Delete Mark",
})
map({
  "dm-",
  function()
    local cur_ln = vim.api.nvim_win_get_cursor(0)
    for _, mark in ipairs(vim.fn.getmarklist(vim.api.nvim_get_current_buf())) do
      if cur_ln[1] == mark.pos[2] then
        vim.cmd("delmark " .. mark.mark:sub(2, 2))
      end
    end
  end,
  desc = "Delete Mark in Current Line",
})
map({
  "dm<Space>",
  "<Cmd>delm!<CR>",
  desc = "Delete All Marks",
})

-- https://github.com/chrisgrieser/nvim-origami/blob/main/lua/origami/fold-keymaps.lua {{{
local function normal(expr)
  return vim.cmd("normal! " .. expr)
end

map({
  "h",
  function()
    local count = vim.v.count1
    for _ = 1, count do
      if vim.api.nvim_win_get_cursor(0)[2] == 0 then
        local ok = pcall(normal, "zc")
        if not ok then
          normal("h")
        end
      else
        normal("h")
      end
    end
  end,
  desc = "Left",
})

map({
  "l",
  function()
    local count = vim.v.count1
    for _ = 1, count do
      pcall(normal, vim.fn.foldclosed(".") > -1 and "zo" or "l")
    end
  end,
  desc = "Right",
})
-- }}}

map({ "g/", "<Esc>/\\%V", mode = "x", silent = false, desc = "Search Selection" })

map({ "n", "'Nn'[v:searchforward].'zv'", expr = true, desc = "Next Search" })
map({ "n", "'Nn'[v:searchforward]", mode = { "x", "o" }, expr = true, desc = "Next Search" })
map({ "N", "'nN'[v:searchforward].'zv'", expr = true, desc = "Previous Search" })
map({ "N", "'nN'[v:searchforward]", mode = { "x", "o" }, expr = true, desc = "Previous Search" })

vim.keymap.del("n", "<C-w><C-d>")
