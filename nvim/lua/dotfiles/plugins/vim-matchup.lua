return {
  {
    "andymass/vim-matchup",
    config = function()
      vim.g.matchup_matchparen_deferred = true
      vim.g.matchup_matchparen_nomode = "i"
      vim.g.matchup_matchparen_offscreen = {}
      vim.g.matchup_treesitter_disable_virtual_text = true

      -- FIXME: https://github.com/andymass/vim-matchup/issues/416
      vim.g.matchup_treesitter_disabled = { "codecompanion", "markdown" }
    end,
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "LazyFile",
  },
}
