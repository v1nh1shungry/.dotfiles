return {
  {
    "andymass/vim-matchup",
    config = function()
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_nomode = "i"
      vim.g.matchup_matchparen_offscreen = {}
      vim.g.matchup_treesitter_disable_virtual_text = true
    end,
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "LazyFile",
  },
}
