-- Inspired by https://github.com/chrisgrieser/nvim-tinygit {{{
local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local previewers = require("telescope.previewers")
local git_command = require("telescope.utils").__git_command

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

  vim.ui.input({ prompt = "Git Pickaxe" }, function(query)
    if not query then
      return
    end

    local res = vim.system({ "git", "log", "--pretty=format:%h %s", "--name-only", "-G", query }):wait()
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

    local displayer = entry_display.create({
      separator = " ",
      items = {
        { width = 8 },
        { remaining = true },
        { remaining = true },
      },
    })

    local make_display = function(entry)
      return displayer({
        { entry.sha, "TelescopeResultsIdentifier" },
        { entry.file, "TelescopeResultsIdentifier" },
        entry.msg,
      })
    end

    pickers
      .new({}, {
        prompt_title = "Git Pickaxe | <CR> Open",
        finder = finders.new_table({
          results = results,
          entry_maker = function(entry)
            return vim.tbl_extend("force", {
              ordinal = entry.sha .. " " .. entry.file .. " " .. entry.msg,
              display = make_display,
            }, entry)
          end,
        }),
        previewer = previewers.new_buffer_previewer({
          title = "Git Pickaxe Preview",
          define_preview = function(self, entry)
            local putils = require("telescope.previewers.utils")
            putils.job_maker(
              git_command({
                "-C",
                Dotfiles.git_root(),
                "--no-pager",
                "diff",
                entry.sha .. "^!",
                "-G",
                query,
                "--",
                entry.file,
              }),
              self.state.bufnr,
              {
                bufname = self.state.bufname,
                callback = function(bufnr)
                  if vim.api.nvim_buf_is_valid(bufnr) then
                    putils.highlighter(bufnr, "diff", {})
                  end
                end,
              }
            )
          end,
        }),
        sorter = conf.file_sorter({}),
        attach_mappings = function(prompt_bufnr, _)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local entry = action_state:get_selected_entry()
            vim.cmd("Gedit " .. entry.sha .. ":" .. entry.file)
          end)
          return true
        end,
      })
      :find()
  end)
end

Dotfiles.map({ "<Leader>g/", pickaxe, desc = "Git pickaxe" })
-- }}}
