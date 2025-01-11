local config = {
  save = true,
  compile = {
    c = {
      "ccache",
      "gcc",
      "${relativeFile}",
      "-o",
      "${relativeFileDirname}${/}${fileBasenameNoExtension}",
      "-g3",
      "-fsanitize=address,undefined",
      "-fno-omit-frame-pointer",
      "-std=c17",
      "-Wall",
      "-Wextra",
    },
    cmake = {
      "cmake",
      "-S",
      ".",
      "-B",
      "build",
      "-G",
      "Ninja",
      "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON",
      "-DCMAKE_C_COMPILER_LAUNCHER=ccache",
      "-DCMAKE_CXX_COMPILER_LAUNCHER=ccache",
    },
    cpp = {
      "ccache",
      "g++",
      "${relativeFile}",
      "-o",
      "${relativeFileDirname}${/}${fileBasenameNoExtension}",
      "-g3",
      "-fsanitize=address,undefined",
      "-fno-omit-frame-pointer",
      "-std=c++17",
      "-Wall",
      "-Wextra",
    },
  },
  execute = {
    c = { "${relativeFileDirname}${/}${fileBasenameNoExtension}" },
    cmake = { "cmake", "--build", "build" },
    cpp = { "${relativeFileDirname}${/}${fileBasenameNoExtension}" },
    python = {
      vim.fn.executable("python") == 1 and "python" or "python3",
      "${relativeFile}",
    },
    lua = { "nvim", "-l", "${relativeFile}" },
    javascript = { "node", "${relativeFile}" },
  },
}

config = vim.tbl_deep_extend("force", config, require("dotfiles.user").task)

local function cook_variable(line)
  local variables = {
    ["${file}"] = function()
      return vim.fn.expand("%:p")
    end,
    ["${relativeFile}"] = function()
      return vim.fn.expand("%")
    end,
    ["${relativeFileDirname}"] = function()
      return vim.fn.expand("%:h")
    end,
    ["${fileBasename}"] = function()
      return vim.fn.expand("%:t")
    end,
    ["${fileBasenameNoExtension}"] = function()
      return vim.fn.expand("%:t:r")
    end,
    ["${fileExtname}"] = function()
      return vim.fn.expand("%:e")
    end,
    ["${fileDirname}"] = function()
      return vim.fs.dirname(vim.fn.expand("%:p:h"))
    end,
    ["${fileDirnameBasename}"] = function()
      return vim.fn.expand("%:p:h:t")
    end,
    ["${cwd}"] = function()
      return vim.uv.cwd()
    end,
    ["${/}"] = function()
      return "/"
    end,
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

local AUGROUP = Dotfiles.augroup("task")

for lang, cmd in pairs(config.compile) do
  vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
      Dotfiles.map({
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
    group = AUGROUP,
    pattern = lang,
  })
end

local term = nil

local function execute(cmd)
  if term and term:valid() then
    term:close()
  end
  term = Snacks.terminal.open(cmd, {
    win = { position = "bottom" },
    interactive = false,
  })
  return term
end

for ft, cmd in pairs(config.execute) do
  vim.api.nvim_create_autocmd("FileType", {
    callback = function(event)
      Dotfiles.map({
        "<Leader>fx",
        function()
          if config.save then
            vim.cmd("w")
          end
          execute(cook_command(cmd))
        end,
        buffer = event.buf,
        desc = "Execute",
      })
    end,
    group = AUGROUP,
    pattern = ft,
  })
end
