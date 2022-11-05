return function()
  require('lspsaga').init_lsp_saga {
    border_style = 'rounded',
    code_action_lightbulb = { enable = false }, -- disable for `null-ls`
    code_action_keys = { quit = '<ESC>' },
    definition_action_keys = { quit = '<ESC>' },
    rename_action_quit = '<ESC>',
    symbol_in_winbar = {
      enable = true,
      separator = ' > ',
      click_support = function(node, clicks, button, modifiers)
        local st = node.range.start
        local en = node.range['end']
        if button == 'l' then
          if clicks == 2 then
            -- double left click to do nothing
          else
            vim.fn.cursor(st.line + 1, st.character + 1)
          end
        elseif button == 'r' then
          if modifiers == 's' then
            print 'lspsaga'
          end
          vim.fn.cursor(en.line + 1, en.character + 1)
        elseif button == 'm' then
          vim.fn.cursor(st.line + 1, st.character + 1)
          vim.cmd 'normal v'
          vim.fn.cursor(en.line + 1, en.character + 1)
        end
      end
    },
    scroll_in_preview = {
      scroll_down = "<C-j>",
      scroll_up = "<C-k>",
    },
  }
end
