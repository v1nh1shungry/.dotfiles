return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'rust', 'toml' })
      end
    end,
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        taplo = {},
        rust_analyzer = {
          settings = {
            ['rust-analyzer'] = {
              diagnostics = { disabled = { 'unresolved-proc-macro' } },
              cargo = { loadOutDirsFromCheck = true },
              procMacro = { enable = true },
              check = { command = 'clippy' },
            },
          },
        },
      },
    },
  },
}
