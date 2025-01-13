-- TODO: show each file separately

-- Inspired by https://github.com/chrisgrieser/nvim-tinygit {{{
local function is_normal_git_repo()
  if not Dotfiles.is_git_repo() then
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

  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local conf = require("telescope.config").values
  local finders = require("telescope.finders")
  local make_entry = require("telescope.make_entry")
  local pickers = require("telescope.pickers")
  local previewers = require("telescope.previewers")
  local git_command = require("telescope.utils").__git_command

  vim.ui.input({ prompt = "Git Pickaxe" }, function(query)
    if not query then
      return
    end

    pickers
      .new({}, {
        prompt_title = "Git Pickaxe | <CR> Diffview History",
        finder = finders.new_oneshot_job(git_command({ "log", "--pretty=oneline", "--abbrev-commit", "-G", query }), {
          entry_maker = make_entry.gen_from_git_commits({}),
        }),
        previewer = previewers.new_buffer_previewer({
          title = "Git Pickaxe Preview",
          define_preview = function(self, entry)
            local putils = require("telescope.previewers.utils")
            putils.job_maker(
              git_command({
                "--no-pager",
                "diff",
                entry.value .. "^!",
                "-G",
                query,
              }),
              self.state.bufnr,
              {
                value = entry.value,
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
            vim.cmd("DiffviewOpen " .. action_state.get_selected_entry().value .. "^")
          end)
          return true
        end,
      })
      :find()
  end)
end

Dotfiles.map({ "<Leader>g/", pickaxe, desc = "Git pickaxe" })
-- }}}
