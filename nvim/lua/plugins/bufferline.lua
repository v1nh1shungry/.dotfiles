local status_ok, bufferline = pcall(require, 'bufferline')
if not status_ok then
  return
end

local nnoremap = require('utils.keymaps').nnoremap

bufferline.setup{
  options = {
    offsets = {{
      filetype = 'NvimTree',
      text = 'File Explorer',
      text_align = 'center'
    }}
  }
}

nnoremap('H', ':BufferLineCyclePrev<CR>')
nnoremap('L', ':BufferLineCycleNext<CR>')
