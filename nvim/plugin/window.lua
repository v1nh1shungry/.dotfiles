-- Inspired by https://github.com/simeji/winresizer
local map = require("dotfiles.utils.keymap")

local config = {
  vert_resize = 10,
  hori_resize = 3,
}

local function can_move_to(direction)
  local from = vim.fn.winnr()
  vim.cmd("wincmd " .. direction)
  local to = vim.fn.winnr()
  vim.cmd(from .. " wincmd w")
  return from ~= to
end

local function get_edge_info()
  local directions = { "h", "j", "k", "l" }
  local result = {}
  for _, d in ipairs(directions) do
    result[d] = can_move_to(d)
  end
  return result
end

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

map({
  "<C-Left>",
  function()
    resize("h")
  end,
  desc = "Left shift",
})
map({
  "<C-Right>",
  function()
    resize("l")
  end,
  desc = "Right shift",
})
map({
  "<C-Up>",
  function()
    resize("k")
  end,
  desc = "Up shift",
})
map({
  "<C-Down>",
  function()
    resize("j")
  end,
  desc = "Down shift",
})
