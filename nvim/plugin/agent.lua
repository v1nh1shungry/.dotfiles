local has_codex = vim.fn.executable("codex")

if not has_codex then
  return
end

---@class Agent
---@field term snacks.terminal?
---@field cmd string|string[]
---@field resume_cmd string|string[]
local Agent = {}
Agent.__index = Agent

---@param opts { cmd: string|string[], resume_cmd?: string|string[] }
---@return Agent
function Agent.new(opts)
  return setmetatable({
    term = nil,
    cmd = opts.cmd,
    resume_cmd = opts.resume_cmd or opts.cmd,
  }, Agent)
end

---@param cmd string|string[]
function Agent:_spawn(cmd)
  local t = Snacks.terminal(cmd, {
    env = {
      NVIM_SOCKET_PATH = vim.v.servername,
    },
    win = {
      keys = {
        term_normal = { "<C-c>", function() vim.cmd("stopinsert") end, desc = "Enter Normal Mode", mode = "t" },
        hide = { "<C-c>", function(self) self:hide() end, desc = "Hide" },
      },
      position = "right",
      width = 0.5,
    },
  })

  self.term = t

  -- FIXME: add autocmds to monitor if the program exitted.
end

function Agent:toggle()
  if self.term then
    self.term:toggle()
  else
    self:_spawn(self.resume_cmd)
  end
end

function Agent:new_session()
  if self.term then
    self.term:close()
    self.term = nil
  end
  self:_spawn(self.cmd)
end

if has_codex then
  local codex = Agent.new({ cmd = "codex", resume_cmd = { "codex", "resume" } })
  Dotfiles.map({ "<Leader>ao", function() codex:toggle() end, desc = "Codex (Resume)" })
  Dotfiles.map({ "<Leader>aO", function() codex:new_session() end, desc = "Codex (New)" })
end
