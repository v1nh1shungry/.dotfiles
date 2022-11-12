return function()
  require('refactoring').setup {
    prompt_func_return_type = {
      c = true,
      cpp = true,
    },
    prompt_func_param_type = {
      c = true,
      cpp = true,
    },
  }
end
