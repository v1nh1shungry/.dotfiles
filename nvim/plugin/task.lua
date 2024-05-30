local map = require("utils.keymap")
local opts = require("user").task

local compile_opts = {
  c = {
    "ccache",
    "gcc",
    "${relativeFile}",
    "-o",
    "${relativeFileDirname}/${fileBasenameNoExtension}",
    "-g",
    "-fsanitize=address,undefined",
    "-std=c17",
    "-Wall",
    "-Wextra",
  },
  cpp = {
    "ccache",
    "g++",
    "${relativeFile}",
    "-o",
    "${relativeFileDirname}/${fileBasenameNoExtension}",
    "-g",
    "-fsanitize=address,undefined",
    "-std=c++17",
    "-Wall",
    "-Wextra",
  },
}

local execute_opts = {
  c = { "${relativeFileDirname}/${fileBasenameNoExtension}" },
  cpp = { "${relativeFileDirname}/${fileBasenameNoExtension}" },
  python = { "python", "${relativeFile}" },
  lua = { "nvim", "-l", "${relativeFile}" },
  javascript = { "node", "${relativeFile}" },
}

compile_opts = vim.tbl_deep_extend("force", compile_opts, opts.compile)
execute_opts = vim.tbl_deep_extend("force", execute_opts, opts.execute)

local function cook_variable(line)
  local variables = {
    ["${file}"] = function() return vim.fn.expand("%:p") end,
    ["${relativeFile}"] = function() return vim.fn.expand("%") end,
    ["${relativeFileDirname}"] = function() return vim.fn.expand("%:h") end,
    ["${fileBasename}"] = function() return vim.fn.expand("%:t") end,
    ["${fileBasenameNoExtension}"] = function() return vim.fn.expand("%:t:r") end,
    ["${fileExtname}"] = function() return vim.fn.expand("%:e") end,
    ["${fileDirname}"] = function() return vim.fs.dirname(vim.fn.expand("%:p:h")) end,
    ["${fileDirnameBasename}"] = function() return vim.fn.expand("%:p:h:t") end,
    ["${cwd}"] = function() return vim.uv.cwd() end,
    ["${/}"] = function() return "/" end,
  }

  for k, v in pairs(variables) do
    line = line:gsub(k, v())
  end

  return line
end

local function cook_command(cmd)
  cmd = vim.deepcopy(cmd)
  for i, line in ipairs(cmd) do
    cmd[i] = cook_variable(line)
  end
  return cmd
end

for lang, cmd in pairs(compile_opts) do
  vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
      map({
        "<Leader>fb",
        function()
          cmd = cook_command(cmd)

          if opts.save then
            vim.cmd.w()
          end

          vim.fn.setqflist({}, " ", { title = table.concat(cmd, " ") })

          vim.system(
            cmd,
            { text = true },
            vim.schedule_wrap(function(res)
              if res.code == 0 then
                vim.notify("Sucessfully compile the program!", vim.log.levels.INFO, { title = "Task" })
              else
                vim.notify("Compile error!", vim.log.levels.ERROR, { title = "Task" })
              end
              if res.stderr then
                local winnr = vim.fn.winnr()
                local lines = vim.tbl_filter(
                  function(l) return l:match("^.+:%d+:%d+:") end,
                  vim.split(res.stderr, "\n", { trimempty = true })
                )
                if #lines == 0 then
                  vim.cmd("cclose")
                  return
                end
                vim.fn.setqflist({}, "a", { lines = lines })
                vim.cmd("copen")
                vim.cmd(winnr .. " wincmd w")
              end
            end)
          )
        end,
        buffer = args.buf,
        desc = "Compile",
      })
    end,
    pattern = lang,
  })
end

local term = nil

local function execute(cmd)
  if term then
    term:close()
  end
  term = require("toggleterm.terminal").Terminal:new({
    cmd = cmd,
    direction = "horizontal",
    close_on_exit = false,
  })
  term:toggle()
end

for lang, cmd in pairs(execute_opts) do
  vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
      map({
        "<Leader>fx",
        function()
          if opts.save then
            vim.cmd.w()
          end
          execute(table.concat(cook_command(cmd), " "))
        end,
        buffer = args.buf,
        desc = "Execute",
      })
    end,
    pattern = lang,
  })
end
