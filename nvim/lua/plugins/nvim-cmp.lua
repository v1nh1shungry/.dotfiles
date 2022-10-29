return function()
  local cmp = require('cmp')
  local luasnip = require('luasnip')

  vim.cmd [[packadd lspkind.nvim]]

  local formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, item)
      local kind = require('lspkind').cmp_format({ mode = 'symbol_text' })(entry, item)
      local s = vim.split(kind.kind, '%s', { trimempty = true })
      kind.kind = ' ' .. s[1] .. ' '
      kind.menu = '    [' .. s[2] .. ']'
      return kind
    end,
  }

  cmp.setup {
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    formatting = formatting,
    mapping = cmp.mapping.preset.insert({
      ['<C-j>'] = cmp.mapping.select_next_item(),
      ['<C-k>'] = cmp.mapping.select_prev_item(),
      ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          local entry = cmp.get_selected_entry()
          if not entry then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          else
            cmp.confirm()
          end
        else
          fallback()
        end
      end, { "i", "s", "c", }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'buffer' },
      { name = 'path' },
    })
  }

  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    formatting = formatting,
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }),
  })
end
