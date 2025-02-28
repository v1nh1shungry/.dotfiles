-- Inspired by https://github.com/simeji/winresizer
local config = {
  vert_resize = 10,
  hori_resize = 3,
}

---@alias dotfiles.Direction "h"|"j"|"k"|"l"
---@param direction dotfiles.Direction
---@return boolean
local function can_move_to(direction)
  local from = vim.fn.winnr()
  vim.cmd("wincmd " .. direction)
  local to = vim.fn.winnr()
  vim.cmd(from .. " wincmd w")
  return from ~= to
end

---@return table<dotfiles.Direction, boolean>
local function get_edge_info()
  local directions = { "h", "j", "k", "l" } ---@type dotfiles.Direction[]
  local result = {}
  for _, d in ipairs(directions) do
    result[d] = can_move_to(d)
  end
  return result
end

---@return table<dotfiles.Direction, "+"|"-">
local function get_behaviors()
  local signs = {
    h = "+",
    j = "-",
    k = "+",
    l = "-",
  }
  local info = get_edge_info()
  if not info["h"] and info["l"] then
    signs["h"] = "-"
    signs["l"] = "+"
  end
  if not info["k"] and info["j"] then
    signs["k"] = "-"
    signs["j"] = "+"
  end
  return signs
end

---@param direction dotfiles.Direction
local function resize(direction)
  local behaviors = get_behaviors()
  local commands = {
    h = "vertical resize " .. behaviors["h"] .. config.vert_resize,
    l = "vertical resize " .. behaviors["l"] .. config.vert_resize,
    k = "resize " .. behaviors["k"] .. config.hori_resize,
    j = "resize " .. behaviors["j"] .. config.hori_resize,
  }
  vim.cmd(commands[direction])
end

Dotfiles.map({
  "<C-w><",
  function()
    resize("h")
  end,
  desc = "Left Shift",
})
Dotfiles.map({
  "<C-w>>",
  function()
    resize("l")
  end,
  desc = "Right Shift",
})
Dotfiles.map({
  "<C-w>+",
  function()
    resize("k")
  end,
  desc = "Up Shift",
})
Dotfiles.map({
  "<C-w>-",
  function()
    resize("j")
  end,
  desc = "Down Shift",
})
