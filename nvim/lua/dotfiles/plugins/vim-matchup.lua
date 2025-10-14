return {
  {
    "andymass/vim-matchup",
    config = function()
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_nomode = "i"
      vim.g.matchup_matchparen_offscreen = {}
      vim.g.matchup_treesitter_disable_virtual_text = true

      -- FIXME: https://github.com/andymass/vim-matchup/issues/416
      vim.api.nvim_create_autocmd("FileType", {
        command = "let b:matchup_matchparen_enabled = v:false",
        group = Dotfiles.augroup("matchup.issue-416"),
        pattern = { "codecompanion", "markdown" },
      })
    end,
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "LazyFile",
  },
}
