-- TODO: redesign and rewrite
local AUGROUP = Dotfiles.augroup("task")

local config = {
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
    cpp = { "${relativeFileDirname}${/}${fileBasenameNoExtension}" },
    python = {
      vim.fn.executable("python") == 1 and "python" or "python3",
      "${relativeFile}",
    },
    lua = { "nvim", "-l", "${relativeFile}" },
    javascript = { "node", "${relativeFile}" },
  },
}

config = vim.tbl_deep_extend("force", config, Dotfiles.user.task)

---@param line string
---@return string
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
    ["${cwd}"] = function() return vim.fn.getcwd() end,
    ["${/}"] = function() return "/" end,
  }

  for k, v in pairs(variables) do
    line = line:gsub(k, v())
  end

  return line
end

---@param cmd string[]
---@return string[]
local function cook_command(cmd) return vim.iter(vim.deepcopy(cmd)):map(cook_variable):totable() end

for ft, cmd in pairs(config.compile) do
  vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
      Dotfiles.map({
        "<Leader>fb",
        function()
          cmd = cook_command(cmd)

          vim.cmd("w")

          vim.cmd("lclose")
          vim.fn.setloclist(0, {}, " ", { title = table.concat(cmd, " ") })

          vim.system(
            cmd,
            nil,
            vim.schedule_wrap(function(res)
              if res.code == 0 then
                Snacks.notify.info("Sucessfully compile the program")
              else
                Snacks.notify.error("Failed to compile the program")
              end

              if res.stderr and res.stderr ~= "" then
                local lines = vim.split(res.stderr, "\n", { trimempty = true })
                vim.fn.setloclist(0, {}, "a", { lines = lines })
                vim.cmd("lopen")
                vim.cmd("wincmd p")
              end
            end)
          )
        end,
        buffer = args.buf,
        desc = "Compile",
      })
    end,
    group = AUGROUP,
    pattern = ft,
  })
end

local term = nil ---@type snacks.win?

for ft, cmd in pairs(config.execute) do
  vim.api.nvim_create_autocmd("FileType", {
    callback = function(event)
      Dotfiles.map({
        "<Leader>fx",
        function()
          vim.cmd("w")

          cmd = cook_command(cmd)

          if term and term:valid() then term:close() end

          term = Snacks.terminal.open(cmd, {
            win = { position = "bottom" },
            interactive = false,
          })
        end,
        buffer = event.buf,
        desc = "Execute",
      })
    end,
    group = AUGROUP,
    pattern = ft,
  })
end
