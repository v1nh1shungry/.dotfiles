local status_ok, saga = pcall(require, 'lspsaga')
if not status_ok then
  return
end

saga.init_lsp_saga {
  symbol_in_winbar = {
    enable = true,
    separator = '  ',
    click_support = function(node, clicks, button, modifiers)
      local st = node.range.start
      local en = node.range['end']
      if button == "l" then
        if clicks == 2 then
            -- double left click to do nothing
        else
            vim.fn.cursor(st.line + 1, st.character + 1)
        end
      elseif button == "r" then
        if modifiers == "s" then
            print "lspsaga"
        end
        vim.fn.cursor(en.line + 1, en.character + 1)
      elseif button == "m" then
        vim.fn.cursor(st.line + 1, st.character + 1)
        vim.cmd "normal v"
        vim.fn.cursor(en.line + 1, en.character + 1)
      end
    end
  }
}
