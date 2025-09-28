-- Inspired by https://github.com/chrisgrieser/nvim-tinygit {{{

local function pickaxe()
  local root = Dotfiles.git.root()

  if not root then
    Dotfiles.notify.error("Aborting: not a git repository")
    return
  end

  vim.system({ "git", "rev-parse", "--is-shallow-repository" }, { text = true }, function(obj)
    if vim.trim(obj.stdout or "") == "true" then
      Dotfiles.notify.error("Aborting: repository is shallow")
      return
    end

    vim.schedule(function()
      vim.ui.input({ prompt = "Git Pickaxe" }, function(query)
        if not query then
          return
        end

        vim.schedule(function()
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
        end)
      end)
    end)
  end)
end

Dotfiles.map({ "<Leader>g/", pickaxe, desc = "Pickaxe" })
-- }}}
