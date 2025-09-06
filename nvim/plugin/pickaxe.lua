-- Inspired by https://github.com/chrisgrieser/nvim-tinygit {{{

---@async
---@return string?
local function normal_git_root()
  local root = Dotfiles.git.root()

  if not root then
    Dotfiles.notify.error("Aborting: not a git repository")
    return nil
  end

  if vim.trim(Dotfiles.co.system({ "git", "rev-parse", "--is-shallow-repository" }).stdout) == "true" then
    Dotfiles.notify.error("Aborting: repository is shallow")
    return nil
  end

  return root
end

---@param line string
---@return string, string
local function parse_commit(line) return string.match(line, "([^ ]+) (.+)") end

---@async
local function pickaxe()
  local root = normal_git_root()
  if not root then
    return
  end

  local query = Dotfiles.co.input({ prompt = "Git Pickaxe" })
  if not query then
    return
  end

  require("fzf-lua").fzf_exec("git log --pretty=oneline --abbrev-commit -G " .. query, {
    actions = {
      ["default"] = function(selected)
        local sha = parse_commit(selected[1])
        vim.cmd(("DiffviewFileHistory --base=%s -n=1 -G=%s"):format(sha, query))
      end,
    },
    preview = {
      type = "cmd",
      fn = function(items)
        local sha = parse_commit(items[1])
        return ("git -C %s show %s -G %s | delta"):format(root, sha, query)
      end,
    },
  })
end

Dotfiles.map({ "<Leader>g/", Dotfiles.co.void(pickaxe), desc = "Pickaxe" })
-- }}}
