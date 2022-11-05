vim.opt.guifont = 'JetBrains Mono,MesloLGS NF,Segoe UI Emoji:h12'
vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_cursor_vfx_mode = 'pixiedust'

require('utils.keymaps').inoremap('<C-v>', '<ESC>"+pi')
