local map = Dotfiles.map

vim.g.mapleader = vim.keycode("<Space>")
vim.g.maplocalleader = "\\"

-- https://github.com/echasnovski/mini.operators {{{
---@param mapping { [1]: string, mode?: string|string[] }
local function remove_lsp_mapping(mapping)
  mapping.mode = mapping.mode or { "n" }

  if type(mapping.mode) == "string" then
    mapping.mode = {
      mapping.mode --[[@as string]],
    }
  end

  for _, m in
    ipairs(mapping.mode --[=[@as string[]]=])
  do
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
  group = Dotfiles.augroup("lsp.disable_default_mappings"),
})

map({ "<C-q>", "<Cmd>bd<CR>", desc = "Close Buffer" })
map({ "<Leader>qq", "<Cmd>qa!<CR>", desc = "Quit" })

map({ "<C-s>", "<Cmd>w<CR><Esc>", desc = "Save", mode = { "i", "x", "n", "s" } })

-- Modified from https://github.com/LazyVim/LazyVim {{{
map({ "<", "<gv", mode = "v" })
map({ ">", ">gv", mode = "v" })

map({ ",", ",<C-g>u", mode = "i" })
map({ ".", ".<C-g>u", mode = "i" })
map({ ";", ";<C-g>u", mode = "i" })

map({ "j", "v:count == 0 ? 'gj' : 'j'", expr = true, desc = "Down", mode = { "n", "x" } })
map({ "k", "v:count == 0 ? 'gk' : 'k'", expr = true, desc = "Up", mode = { "n", "x" } })
map({ "<Down>", "v:count == 0 ? 'gj' : 'j'", expr = true, desc = "Down", mode = { "n", "x" } })
map({ "<Up>", "v:count == 0 ? 'gk' : 'k'", expr = true, desc = "Up", mode = { "n", "x" } })

map({ "<C-j>", "<cmd>execute 'move .+' . v:count1<cr>==", desc = "Move Down" })
map({ "<C-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", desc = "Move Up" })
map({ "<C-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", mode = "v", desc = "Move Down" })
map({ "<C-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", mode = "v", desc = "Move Up" })

map({
  "<Esc>",
  function()
    vim.cmd("noh")
    vim.snippet.stop()
    return "<Esc>"
  end,
  expr = true,
  mode = { "i", "n" },
  desc = "Escape and Clear Highlight",
})

map({ "n", "'Nn'[v:searchforward].'zv'", expr = true, desc = "Next Search" })
map({ "n", "'Nn'[v:searchforward]", mode = { "x", "o" }, expr = true, desc = "Next Search" })
map({ "N", "'nN'[v:searchforward].'zv'", expr = true, desc = "Previous Search" })
map({ "N", "'nN'[v:searchforward]", mode = { "x", "o" }, expr = true, desc = "Previous Search" })

map({ "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", desc = "Add Comment Below" })
map({ "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", desc = "Add Comment Above" })

map({
  "<Leader>xl",
  function()
    local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
    if not success and err then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end,
  desc = "Toggle Location List",
})
map({
  "<Leader>xq",
  function()
    local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
    if not success and err then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end,
  desc = "Toggle Quickfix List",
})
-- }}}

map({ "gV", '"`[" . strpart(getregtype(), 0, 1) . "`]"', expr = true, desc = "Select Changed Text" })

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
      lines[1] = "return " .. lines[1] .. " ---@type dotfiles.user.Config"
      vim.api.nvim_buf_set_lines(
        0,
        0,
        -1,
        false,
        vim.list_extend({
          '---@module "dotfiles.utils"',
          '---@module "lazy.types"',
          "",
        }, lines)
      )
    end
  end,
  desc = "Edit Local Configuration",
})

map({ "<Leader>pl", "<Cmd>Lazy home<CR>", desc = "Lazy" })

map({ "<Leader>fU", "<Cmd>earlier 1f<CR>", desc = "Drop Modifications" })

map({ "$", "g_", mode = "x", desc = "End of Line" })

map({ "<Leader>ui", "<Cmd>Inspect<CR>", desc = "Inspect Position" })
map({ "<Leader>uI", "<Cmd>InspectTree<CR>", desc = "Treesitter Tree" })

---@param severity string
---@param next? boolean
---@param ending? boolean
local function goto_diagnostic(severity, next, ending)
  return function()
    vim.diagnostic.jump({
      count = (next and 1 or -1) * (ending and math.huge or vim.v.count1),
      severity = vim.diagnostic.severity[severity],
    })
  end
end

map({ "]w", goto_diagnostic("WARN", true), desc = "Next Warning" })
map({ "[w", goto_diagnostic("WARN"), desc = "Previous Warning" })
map({ "]W", goto_diagnostic("WARN", true, true), desc = "Last Warning" })
map({ "[W", goto_diagnostic("WARN", false, true), desc = "First Warning" })
map({ "]e", goto_diagnostic("ERROR", true), desc = "Next Error" })
map({ "[e", goto_diagnostic("ERROR"), desc = "Previous Error" })
map({ "]E", goto_diagnostic("ERROR", true, true), desc = "Last Error" })
map({ "[E", goto_diagnostic("ERROR", false, true), desc = "First Error" })

map({ "<Leader>xx", vim.diagnostic.setloclist, desc = "Document Diagnostics" })
map({ "<Leader>xX", vim.diagnostic.setqflist, desc = "Workspace Diagnostics" })

map({ "<BS>", "<C-o>s", mode = "s" })

map({
  "dm",
  function()
    local input = vim.F.npcall(string.char, vim.fn.getchar())
    if not input or not input:match("%a") then
      Snacks.notify.error("Aborted: invalid mark")
      return
    end
    pcall(vim.cmd.delmark, input)
    vim.cmd("redraw!")
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
    vim.cmd("redraw!")
  end,
  desc = "Delete Mark in Current Line",
})
map({ "dm<Space>", "<Cmd>delm!<Bar>redraw!<CR>", desc = "Delete All Marks" })

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
      ---@diagnostic disable-next-line: param-type-mismatch
      pcall(normal, vim.fn.foldclosed(".") > -1 and "zo" or "l")
    end
  end,
  desc = "Right",
})
-- }}}

map({ "g/", "<Esc>/\\%V", mode = "x", silent = false, desc = "Search Selection" })

vim.keymap.del("n", "<C-w><C-d>")

map({ "<S-h>", "<Cmd>bprevious<CR>", desc = "Previous Buffer" })
map({ "<S-l>", "<Cmd>bnext<CR>", desc = "Next Buffer" })

-- Modified from https://github.com/chrisgrieser/nvim-recorder {{{
map({
  "q",
  function()
    return vim.fn.reg_recording() == "" and "qa" or "q"
  end,
  expr = true,
  desc = "Record Macro",
})
map({
  "cq",
  function()
    vim.ui.input({
      prompt = "Edit Macro",
      default = vim.api.nvim_replace_termcodes(vim.fn.keytrans(vim.fn.getreg("a")), true, true, true),
    }, function(input)
      if not input then
        return
      end
      vim.fn.setreg("a", input, "c")
    end)
  end,
})
-- }}}
