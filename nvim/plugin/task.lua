local nnoremap = require('utils.keymaps').nnoremap
local opts = require('user').task

local compile_opts = {
  c = {
    'gcc',
    '${filename}',
    '-o',
    '${filenameNoExtesion}',
    '-g',
    '-fsanitize=address,undefined',
    '-std=c17',
    '-Wall',
    '-Wextra',
  },
  cpp = {
    'g++',
    '${filename}',
    '-o',
    '${filenameNoExtesion}',
    '-g',
    '-fsanitize=address,undefined',
    '-std=c++17',
    '-Wall',
    '-Wextra',
  },
}

local execute_opts = {
  c = { '${filenameNoExtesion}' },
  cpp = { '${filenameNoExtesion}' },
  python = { 'python', '${filename}' },
  lua = { 'nvim', '-l', '${filename}' },
  javascript = { 'node', '${filename}' },
}

compile_opts = vim.tbl_deep_extend('force', compile_opts, opts.compile)
execute_opts = vim.tbl_deep_extend('force', execute_opts, opts.execute)

local cook = function(cmd)
  cmd = vim.deepcopy(cmd)
  for i, c in ipairs(cmd) do
    if c == '${filename}' then
      cmd[i] = vim.fn.expand('%:p')
    elseif c == '${filenameNoExtesion}' then
      cmd[i] = vim.fn.expand('%:p:r')
    end
  end
  return cmd
end

for lang, cmd in pairs(compile_opts) do
  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      nnoremap {
        '<Leader>fb',
        function()
          cmd = cook(cmd)
          vim.fn.setqflist({}, ' ', { title = table.concat(cmd, ' ') })
          if opts.save then
            vim.cmd.w()
          end
          vim.system(
            cmd,
            {
              stderr = vim.schedule_wrap(function(error, data)
                if error == nil and data == nil then
                  return
                end
                vim.fn.setqflist({}, 'a', { lines = vim.split(error and error or data, '\n', { trimempty = true }) })
                vim.cmd.copen()
                vim.cmd.wincmd('p')
              end),
            },
            vim.schedule_wrap(function(res)
              if res.code == 0 then
                vim.notify('Sucessfully compile the program!', vim.log.levels.INFO, { title = 'Task' })
              end
            end)
          )
        end,
        buffer = args.buf,
        desc = 'Compile',
      }
    end,
    pattern = lang,
  })
end

local term = nil

local function execute(cmd)
  if term then
    term:close()
  end
  term = require('toggleterm.terminal').Terminal:new {
    cmd = cmd,
    direction = 'horizontal',
    close_on_exit = false,
  }
  term:toggle()
end

for lang, cmd in pairs(execute_opts) do
  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      nnoremap {
        '<Leader>fx',
        function()
          if opts.save then
            vim.cmd.w()
          end
          execute(table.concat(cook(cmd), ' '))
        end,
        buffer = args.buf,
        desc = 'Execute',
      }
    end,
    pattern = lang,
  })
end
