local map = Dotfiles.map

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

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.bo[args.buf].tagfunc = nil
    vim.bo[args.buf].omnifunc = nil
  end,
  group = Dotfiles.augroup("disable_default_lsp_mappings"),
})

vim.g.mapleader = vim.keycode("<Space>")
vim.g.maplocalleader = "\\"

map({ "<Leader>qq", "<Cmd>qa!<CR>", desc = "Quit" })

map({ "<C-s>", "<Cmd>w<CR><Esc>", desc = "Save", mode = { "i", "x", "n", "s" } })

map({ "<", "<gv", mode = "v" })
map({ ">", ">gv", mode = "v" })

map({ "<Leader>xq", Dotfiles.toggle.quickfix, desc = "Toggle quickfix" })
map({ "<Leader>xl", Dotfiles.toggle.location, desc = "Toggle location list" })

map({ ",", ",<C-g>u", mode = "i" })
map({ ".", ".<C-g>u", mode = "i" })
map({ ";", ";<C-g>u", mode = "i" })

map({ "j", "v:count == 0 ? 'gj' : 'j'", expr = true, desc = "Down", mode = { "n", "x" } })
map({ "k", "v:count == 0 ? 'gk' : 'k'", expr = true, desc = "Up", mode = { "n", "x" } })
map({ "<Down>", "v:count == 0 ? 'gj' : 'j'", expr = true, desc = "Down", mode = { "n", "x" } })
map({ "<Up>", "v:count == 0 ? 'gk' : 'k'", expr = true, desc = "Up", mode = { "n", "x" } })

map({ "gV", '"`[" . strpart(getregtype(), 0, 1) . "`]"', expr = true, desc = "Visually select changed text" })

map({ "<Leader><Tab>q", "<Cmd>tabclose<CR>", desc = "Close tab" })
map({ "<Leader><Tab><Tab>", "<Cmd>tabnew<CR>", desc = "New tab" })
map({ "<Leader><Tab>0", "<Cmd>tabfirst<CR>", desc = "First tab" })
map({ "<Leader><Tab>$", "<Cmd>tablast<CR>", desc = "Last tab" })
map({
  "]<Tab>",
  function()
    return "<Cmd>+" .. vim.v.count1 .. "tabnext<CR>"
  end,
  desc = "Next tab",
  expr = true,
})
map({
  "[<Tab>",
  function()
    return "<Cmd>-" .. vim.v.count1 .. "tabnext<CR>"
  end,
  desc = "Previous tab",
  expr = true,
})

map({ "<Leader>,", "<Cmd>e #<CR>", desc = "Last buffer" })

map({ "<Leader>fc", "<Cmd>e ~/.nvimrc<CR>", desc = "Open preferences" })

map({ "<C-j>", "<Cmd>m .+1<CR>==", desc = "Move down" })
map({ "<C-k>", "<Cmd>m .-2<CR>==", desc = "Move up" })
map({ "<C-j>", "<Esc><Cmd>m .+1<Cr>==gi", mode = "i", desc = "Move Down" })
map({ "<C-k>", "<Esc><Cmd>m .-2<Cr>==gi", mode = "i", desc = "Move Up" })
map({ "<C-j>", ":m '>+1<CR>gv=gv", mode = "v", desc = "Move down" })
map({ "<C-k>", ":m '<-2<CR>gv=gv", mode = "v", desc = "Move up" })

map({ "<Leader>pl", "<Cmd>Lazy home<CR>", desc = "Lazy" })

map({ "<Leader>fU", "<Cmd>earlier 1f<CR>", desc = "Give up modifications" })

map({ "$", "g_", mode = "x", desc = "End of line" })

map({ "<Leader>ui", "<Cmd>Inspect<CR>", desc = "Inspect position under the cursor" })
map({ "<Leader>uI", "<Cmd>InspectTree<CR>", desc = "Treesitter Tree" })

map({ "<C-w>z", Dotfiles.toggle.maximize, desc = "Zoom" })

map({ "<Leader>cd", vim.diagnostic.open_float, desc = "Show diagnostics" })

map({
  "]w",
  function()
    vim.diagnostic.jump({ count = vim.v.count1, severity = vim.diagnostic.severity.WARN })
  end,
  desc = "Jump to the next warning",
})
map({
  "[w",
  function()
    vim.diagnostic.jump({ count = -vim.v.count1, severity = vim.diagnostic.severity.WARN })
  end,
  desc = "Jump to the previous warning",
})
map({
  "]e",
  function()
    vim.diagnostic.jump({ count = vim.v.count1, severity = vim.diagnostic.severity.ERROR })
  end,
  desc = "Jump to the next error",
})
map({
  "[e",
  function()
    vim.diagnostic.jump({ count = -vim.v.count1, severity = vim.diagnostic.severity.ERROR })
  end,
  desc = "Jump to the previous error",
})
map({
  "]W",
  function()
    vim.diagnostic.jump({ count = math.huge, severity = vim.diagnostic.severity.WARN, wrap = false })
  end,
  desc = "Jump to the last warning",
})
map({
  "[W",
  function()
    vim.diagnostic.jump({ count = -math.huge, severity = vim.diagnostic.severity.WARN, wrap = false })
  end,
  desc = "Jump to the first warning",
})
map({
  "]E",
  function()
    vim.diagnostic.jump({ count = math.huge, severity = vim.diagnostic.severity.ERROR, wrap = false })
  end,
  desc = "Jump to the last error",
})
map({
  "[E",
  function()
    vim.diagnostic.jump({ count = -math.huge, severity = vim.diagnostic.severity.ERROR, wrap = false })
  end,
  desc = "Jump to the first error",
})

map({ "<Leader>xx", vim.diagnostic.setqflist, desc = "Diagnostics" })

map({ "<BS>", "<C-o>s", mode = "s" })

map({ "<C-f>", "<Right>", mode = { "i", "c" }, desc = "Move a character forward" })
map({ "<C-b>", "<Left>", mode = { "i", "c" }, desc = "Move a character backward" })
map({ "<M-f>", "<S-Right>", mode = { "i", "c" }, desc = "Move a word forward" })
map({ "<M-b>", "<S-Left>", mode = { "i", "c" }, desc = "Move a word backward" })
map({ "<C-a>", "<Home>", mode = { "i", "c" }, desc = "Begin of line" })
map({ "<C-e>", "<End>", mode = { "i", "c" }, desc = "End of line" })

map({ "<Esc>", "<Cmd>noh<CR><Esc>", mode = { "i", "n" }, desc = "Escape and clear hlsearch" })

map({
  "dm",
  function()
    local ok, input = pcall(function()
      return string.char(vim.fn.getchar())
    end)
    if not ok then
      return
    end
    pcall(vim.cmd.delmark, input)
  end,
  desc = "Delete mark",
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
  desc = "Delete mark in current line",
})
map({
  "dm<Space>",
  "<Cmd>delm!<CR>",
  desc = "Delete all marks",
})
