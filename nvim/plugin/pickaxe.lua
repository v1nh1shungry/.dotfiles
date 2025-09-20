-- Inspired by https://github.com/chrisgrieser/nvim-tinygit {{{

---@async
---@return string?
local function normal_git_root()
  local root = Dotfiles.git.root()

  if not root then
    Dotfiles.notify.error("Aborting: not a git repository")
    return nil
  end

  if vim.trim(Dotfiles.co.system({ "git", "rev-parse", "--is-shallow-repository" }).stdout or "") == "true" then
    Dotfiles.notify.error("Aborting: repository is shallow")
    return nil
  end

  return root
end

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

  Dotfiles.co.schedule()
  Snacks.picker({
    finder = function(_, ctx)
      return require("snacks.picker.source.proc").proc({
        cmd = "git",
        args = { "-C", root, "log", "--pretty=oneline", "--abbrev-commit", "-G", query },
        cwd = root,
        transform = function(item)
          local sha, msg = string.match(item.text, "([^ ]+) (.+)")
          if not msg then
            sha = item.text
            msg = "<empty commit message>"
          end

          item.sha = sha
          item.msg = msg
          item.text = sha .. " " .. msg
          return item
        end,
      }, ctx)
    end,
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
      local cmd = {
        "git",
        "-c",
        "delta." .. vim.o.background .. "=true",
        "-C",
        root,
        "show",
        ctx.item.sha,
        "-G",
        query,
      }
      Snacks.picker.preview.cmd(cmd, ctx)
    end,
    layout = { layout = { title = "Git Pickaxe" } },
  })
end

Dotfiles.map({ "<Leader>g/", Dotfiles.co.void(pickaxe), desc = "Pickaxe" })
-- }}}
