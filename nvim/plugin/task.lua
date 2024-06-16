local map = require("dotfiles.utils.keymap")

local config = {
  save = true,
  compile = {
    c = {
      "ccache",
      "gcc",
      "${relativeFile}",
      "-o",
      "${relativeFileDirname}${/}${fileBasenameNoExtension}",
      "-g",
      "-fsanitize=address,undefined",
      "-fno-omit-frame-pointer",
      "-std=c17",
      "-Wall",
      "-Wextra",
    },
    cpp = {
      "ccache",
      "g++",
      "${relativeFile}",
      "-o",
      "${relativeFileDirname}${/}${fileBasenameNoExtension}",
      "-g",
      "-fsanitize=address,undefined",
      "-fno-omit-frame-pointer",
      "-std=c++17",
      "-Wall",
      "-Wextra",
    },
  },
  execute = {
    c = { "${relativeFileDirname}${/}${fileBasenameNoExtension}" },
    cpp = { "${relativeFileDirname}${/}${fileBasenameNoExtension}" },
    python = { "python", "${relativeFile}" },
    lua = { "nvim", "-l", "${relativeFile}" },
    javascript = { "node", "${relativeFile}" },
  },
  launch = {},
}

for _, ft in ipairs({ "c", "cpp" }) do
  config.launch[ft] = {
    {
      name = "Launch",
      type = "gdb",
      request = "launch",
      program = "${relativeFileDirname}/${fileBasenameNoExtension}",
      cwd = "${workspaceFolder}",
      stopAtBeginningOfMainSubprogram = false,
    },
  }
end

config = vim.tbl_deep_extend("force", config, require("dotfiles.user").task)

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

local augroup = vim.api.nvim_create_augroup("dotfiles_task_autocmds", {})

for lang, cmd in pairs(config.compile) do
  vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
      map({
        "<Leader>fb",
        function()
          cmd = cook_command(cmd)
          if config.save then
            vim.cmd("w")
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
              if res.stderr and res.stderr ~= "" then
                local winnr = vim.fn.winnr()
                local lines = vim.split(res.stderr, "\n", { trimempty = true })
                vim.fn.setqflist({}, "a", { lines = lines })
                vim.cmd("copen")
                vim.cmd(winnr .. " wincmd w")
              else
                vim.cmd("cclose")
              end
            end)
          )
        end,
        buffer = args.buf,
        desc = "Compile",
      })
    end,
    group = augroup,
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

for ft, cmd in pairs(config.execute) do
  vim.api.nvim_create_autocmd("FileType", {
    callback = function(event)
      map({
        "<Leader>fx",
        function()
          if config.save then
            vim.cmd("w")
          end
          execute(table.concat(cook_command(cmd), " "))
        end,
        buffer = event.buf,
        desc = "Execute",
      })
    end,
    group = augroup,
    pattern = ft,
  })
end

for ft, conf in pairs(config.launch) do
  vim.api.nvim_create_autocmd("FileType", {
    callback = function(event)
      map({
        "<Leader>dc",
        function()
          local dap = require("dap")
          if not dap.configurations[ft] then
            dap.configurations[ft] = conf
          end
          vim.cmd("DapContinue")
        end,
        buffer = event.buf,
        desc = "Continue",
      })
    end,
    group = augroup,
    pattern = ft,
  })
end
