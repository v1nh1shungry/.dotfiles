return {
  {
    "rafcamlet/nvim-luapad",
    cmd = "Luapad",
    opts = {
      on_init = function()
        local bufnr = vim.api.nvim_get_current_buf()
        vim.bo[bufnr].buflisted = false
        require("dotfiles.utils.keymap")({ "q", "<C-w>q", desc = "Quit", buffer = bufnr })
      end,
    },
  },
  {
    "NStefan002/screenkey.nvim",
    keys = { { "<Leader>uk", "<Cmd>Screenkey<CR>", desc = "Screen key" } },
  },
  {
    "stevearc/profile.nvim",
    config = function()
      local should_profile = os.getenv("NVIM_PROFILE")
      if should_profile then
        require("profile").instrument_autocmds()
        if should_profile:lower():match("^start") then
          require("profile").start("*")
        else
          require("profile").instrument("*")
        end
      end
      local function toggle_profile()
        local prof = require("profile")
        if prof.is_recording() then
          prof.stop()
          vim.ui.input(
            { prompt = "Save profile to:", completion = "file", default = "profile.json" },
            function(filename)
              if filename then
                prof.export(filename)
                vim.notify(string.format("Wrote %s", filename))
              end
            end
          )
        else
          prof.start("*")
        end
      end
      map({ "<Leader>up", toggle_profile, desc = "Toggle profile" })
    end,
    lazy = not os.getenv("NVIM_PROFILE"),
  },
  {
    "echasnovski/mini.doc",
    lazy = true,
    opts = {},
  },
}
