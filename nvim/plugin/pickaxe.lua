-- Inspired by https://github.com/chrisgrieser/nvim-tinygit {{{
local function is_normal_git_repo()
  if not Dotfiles.git_root() then
    Snacks.notify.error("Aborting: not a git repository")
    return false
  end

  if vim.trim(vim.system({ "git", "rev-parse", "--is-shallow-repository" }):wait().stdout) == "true" then
    Snacks.notify.error("Aborting: repository is shallow")
    return false
  end

  return true
end

local function pickaxe()
  if not is_normal_git_repo() then
    return
  end

  vim.ui.input(
    { prompt = "Git Pickaxe" },
    vim.schedule_wrap(function(query)
      if not query then
        return
      end

      vim.system({ "git", "log", "--pretty=format:%h %s", "--name-only", "-G", query }, nil, function(res)
        if res.code ~= 0 then
          Snacks.notify.error("Failed to execute git command: " .. res.stderr)
          return
        end

        if res.stdout == "" then
          Snacks.notify.warn("No result")
          return
        end

        local results = {}
        for _, c in ipairs(vim.split(res.stdout, "\n\n", { trimempty = true })) do
          local lines = vim.split(c, "\n", { trimempty = true })
          if #lines <= 1 then
            Snacks.notify.error(("Failed to parse result when parsing '%s'"):format(c))
            return
          end

          local sha, msg = string.match(lines[1], "([^ ]+) (.+)")
          if not msg then
            sha = lines[1]
            msg = "<empty commit message>"
          end

          for i = 2, #lines do
            table.insert(results, {
              sha = sha,
              msg = msg,
              file = lines[i],
            })
          end
        end

        vim.schedule(function()
          Snacks.picker({
            items = results,
            format = function(item)
              return {
                { item.sha, "SnacksPickerLabel" },
                { " ", virtual = true },
                { item.file, "SnacksPickerLabel" },
                { " ", virtual = true },
                { item.msg, "SnacksPickerComment" },
              }
            end,
            confirm = function(picker, item)
              picker:close()
              vim.cmd("Gedit " .. item.sha .. ":" .. item.file)
            end,
            preview = function(ctx)
              local buf = ctx.preview:scratch()
              local output = {}
              local killed = false

              local job = vim.system({
                "git",
                "-C",
                Dotfiles.git_root(),
                "--no-pager",
                "show",
                ctx.item.sha,
                "-G",
                query,
                "--",
                ctx.item.file,
              }, {
                stdout = vim.schedule_wrap(function(_, data)
                  output[#output + 1] = data
                  vim.bo[buf].modifiable = true
                  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(table.concat(output, "\n"), "\n"))
                  vim.bo[buf].modifiable = false
                end),
              }, function(r)
                if not killed and r.code ~= 0 then
                  vim.bo[buf].modifiable = true
                  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(r.stderr, "\n"))
                  vim.bo[buf].modifiable = false
                end
              end)
              ctx.preview:highlight({ ft = "git" })
              vim.api.nvim_create_autocmd("BufWipeout", {
                buffer = buf,
                callback = function()
                  killed = true
                  job:kill(9)
                end,
              })
            end,
          })
        end)
      end)
    end)
  )
end

Dotfiles.map({ "<Leader>g/", pickaxe, desc = "Git pickaxe" })
-- }}}
