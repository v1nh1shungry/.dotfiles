-- Better scrollbind
-- Idea from https://github.com/jackplus-xyz/scroll-it.nvim

local enabled = true

vim.api.nvim_create_autocmd("WinScrolled", {
  callback = function(args)
    if not enabled then
      return
    end

    if vim.bo.buftype ~= "" then
      return
    end

    local current_win = args.match
    if not vim.v.event[current_win] then
      return
    end

    local scrolled = vim.v.event[current_win].topline
    if scrolled == 0 then
      return
    end

    current_win = tonumber(current_win)
    local current_buf = vim.api.nvim_get_current_buf()
    local wins = vim
      .iter(vim.api.nvim_list_wins())
      :filter(function(w)
        return vim.api.nvim_win_get_buf(w) == current_buf
      end)
      :totable()
    table.sort(wins)

    if #wins <= 1 or current_win ~= wins[1] then
      return
    end

    for i = 2, #wins do
      vim.api.nvim_win_call(wins[i], function()
        local key = vim.keycode(math.abs(scrolled) .. (scrolled > 0 and "<C-e>" or "<C-y>"))
        vim.api.nvim_feedkeys(key, "nx", false)
      end)
    end
  end,
  group = Dotfiles.augroup("scroll-it"),
})

Snacks.toggle({
  name = "Sync scroll",
  get = function()
    return enabled
  end,
  set = function(state)
    enabled = state
  end,
}):map("<Leader>us")
