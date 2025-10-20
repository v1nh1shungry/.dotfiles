return {
  {
    "nvim-mini/mini.files",
    config = function()
      -- Modified from https://github.com/stevearc/oil.nvim/blob/master/doc/recipes.md#hide-gitignored-files-and-show-git-tracked-hidden-files {{{
      local function new_git_ignored()
        return setmetatable({}, {
          __index = function(self, key)
            local obj = vim
              .system(
                { "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" },
                { cwd = key, text = true }
              )
              :wait()

            local ret = {}

            if obj.code == 0 and obj.stdout then
              for line in vim.gsplit(obj.stdout, "\n", { plain = true, trimempty = true }) do
                ret[line:gsub("/$", "")] = true
              end
            end

            rawset(self, key, ret)
            return ret
          end,
        })
      end
      -- }}}

      local show_hidden = false
      local git_ignored = new_git_ignored()

      local NS = Dotfiles.ns("plugins.mini-files.extmarks")
      local AUGROUP = Dotfiles.augroup("plugins.mini-files")

      ---@type string[]
      local IGNORED_PATTERN = {
        ".cache",
        ".git",
        "build",
        "node_modules",
      }

      ---@return boolean
      local function filter_show(_) return true end

      ---@return boolean
      local function filter_hide(fs_entry)
        if vim.list_contains(IGNORED_PATTERN, fs_entry.name) then
          return false
        end

        local dir = vim.fs.dirname(fs_entry.path)
        return not git_ignored[dir][fs_entry.name]
      end

      vim.api.nvim_create_autocmd("User", {
        callback = function(args)
          Snacks.toggle({
            name = "Hidden Files",
            get = function() return show_hidden end,
            set = function()
              show_hidden = not show_hidden
              MiniFiles.refresh({ content = { filter = show_hidden and filter_show or filter_hide } })
            end,
          }):map("g.", { buffer = args.data.buf_id })
        end,
        desc = "Setup keymappings for mini.files",
        group = AUGROUP,
        pattern = "MiniFilesBufferCreate",
      })

      vim.api.nvim_create_autocmd("User", {
        callback = function(args)
          vim.api.nvim_buf_clear_namespace(args.data.buf_id, NS, 0, -1)

          if not show_hidden then
            return
          end

          for i = 1, vim.api.nvim_buf_line_count(args.data.buf_id) do
            local entry = MiniFiles.get_fs_entry(args.data.buf_id, i)
            if entry and not filter_hide(entry) then
              vim.api.nvim_buf_set_extmark(args.data.buf_id, NS, i - 1, 0, {
                line_hl_group = "DiagnosticUnnecessary",
              })
            end
          end
        end,
        desc = "Render ignored files for mini.files",
        group = AUGROUP,
        pattern = "MiniFilesBufferUpdate",
      })

      vim.api.nvim_create_autocmd("User", {
        callback = function() git_ignored = new_git_ignored() end,
        desc = "Refresh Git status",
        group = AUGROUP,
        pattern = "MiniFilesExplorerOpen",
      })

      require("mini.files").setup({
        content = {
          filter = function(fs_entry) return show_hidden and filter_show(fs_entry) or filter_hide(fs_entry) end,
        },
      })
    end,
    dependencies = "nvim-mini/mini.icons",
    lazy = not (
        vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0) --[[@as string]]) == 1
      ),
    keys = {
      {
        "<Leader>e",
        function()
          if not MiniFiles.close() then
            MiniFiles.open()
          end
        end,
        desc = "Explorer",
      },
    },
  },
}
