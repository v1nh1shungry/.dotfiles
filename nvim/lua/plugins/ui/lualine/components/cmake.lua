local M = {}

local cmake = require('cmake-tools')

M.preset = {
  function()
    local preset = cmake.get_configure_preset()
    return 'CMake: [' .. (preset and preset or 'X') .. ']'
  end,
  cond = function()
    return cmake.is_cmake_project() and cmake.has_cmake_preset()
  end,
  on_click = function() vim.cmd.CMakeSelectConfigurePreset() end,
}

M.build_type = {
  function()
    local type = cmake.get_build_type()
    return 'CMake: [' .. (type and type or 'X') .. ']'
  end,
  cond = function()
    return cmake.is_cmake_project() and not cmake.has_cmake_preset()
  end,
  on_click = function() vim.cmd.CMakeSelectBuildType() end,
}

M.kit = {
  function()
    local kit = cmake.get_kit()
    return '[' .. (kit and kit or 'X') .. ']'
  end,
  icon = '',
  cond = function()
    return cmake.is_cmake_project() and not cmake.has_cmake_preset()
  end,
  on_click = function() vim.cmd.CMakeSelectKit() end,
}

M.build = {
  function() return '' end,
  cond = cmake.is_cmake_project,
  on_click = function() vim.cmd.CMakeBuild() end,
}

M.build_preset = {
  function()
    local preset = cmake.get_build_preset()
    return '[' .. (preset and preset or 'X') .. ']'
  end,
  cond = function()
    return cmake.is_cmake_project() and cmake.has_cmake_preset()
  end,
  on_click = function() vim.cmd.CMakeSelectBuildPreset() end,
}

M.build_target = {
  function()
    local target = cmake.get_build_target()
    return '[' .. (target and target or 'X') .. ']'
  end,
  cond = cmake.is_cmake_project,
  on_click = function() vim.cmd.CMakeSelectBuildTarget() end,
}

M.debug = {
  function() return '' end,
  cond = cmake.is_cmake_project,
  on_click = function() vim.cmd.CMakeDebug() end,
}

M.run = {
  function() return '' end,
  cond = cmake.is_cmake_project,
  on_click = function() vim.cmd.CMakeRun() end,
}

M.launch_target = {
  function()
    local target = cmake.get_launch_target()
    return '[' .. (target and target or 'X') .. ']'
  end,
  cond = cmake.is_cmake_project,
  on_click = function() vim.cmd.CMakeSelectLaunchTarget() end,
}

return M
