return function()
  require('illuminate').configure {
    filetypes_denylist = {
      'NvimTree',
      'alpha',
      'checkhealth',
      'help',
      'lspsagaoutline',
      'packer',
      'startuptime',
      'toggleterm',
    }
  }
end
