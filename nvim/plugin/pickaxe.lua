-- Inspired by https://github.com/chrisgrieser/nvim-tinygit {{{
local function is_normal_git_repo()
  if not Dotfiles.git_root() then
    Snacks.notify.error("Aborting: not a git repository")
    return false
  end

  if vim.trim(Dotfiles.co.system({ "git", "rev-parse", "--is-shallow-repository" }).stdout) == "true" then
    Snacks.notify.error("Aborting: repository is shallow")
    return false
  end

  return true
end

local function pickaxe()
  if not is_normal_git_repo() then
    Snacks.notify.warn("Not a normal Git repository")
    return
  end

  local query = Dotfiles.co.input({ prompt = "Git Pickaxe" })
  if not query then
    return
  end

  local res = Dotfiles.co.system({ "git", "log", "--pretty=oneline", "--abbrev-commit", "-G", query })
  if res.code ~= 0 then
    Snacks.notify.error("Failed to execute git command: " .. res.stderr)
    return
  end

  local results = {}
  for _, line in ipairs(vim.split(res.stdout, "\n", { trimempty = true })) do
    local sha, msg = string.match(line, "([^ ]+) (.+)")
    if not msg then
      sha = line
      msg = "<empty commit message>"
    end

    table.insert(results, {
      text = sha .. " " .. msg,
      sha = sha,
      msg = msg,
    })
  end

  Dotfiles.co.schedule()
  Snacks.picker({
    items = results,
    format = function(item)
      return {
        { item.sha, "SnacksPickerLabel" },
        { " ", virtual = true },
        { item.msg, "SnacksPickerComment" },
      }
    end,
    confirm = function(picker, item)
      picker:close()
      vim.cmd(("DiffviewFileHistory --base=%s -n=1 -G=%s"):format(item.sha, query))
    end,
    preview = function(ctx)
      Snacks.picker.preview.cmd({
        "git",
        "-C",
        Dotfiles.git_root(),
        "--no-pager",
        "show",
        ctx.item.sha,
        "-G",
        query,
      }, ctx, { ft = "git" })
    end,
    layout = { layout = { title = "Git Pickaxe" } },
  })
end

Dotfiles.map({ "<Leader>g/", Dotfiles.co.void(pickaxe), desc = "Git Pickaxe" })
-- }}}
