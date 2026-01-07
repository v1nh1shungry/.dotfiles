return {
  {
    "Civitasv/cmake-tools.nvim",
    keys = {
      { "<Leader>cG", "<Cmd>CMakeGenerate<CR>", desc = "CMake Generate" },
      { "<Leader>cB", "<Cmd>CMakeBuild<CR>", desc = "CMake Build" },
      { "<Leader>cR", "<Cmd>CMakeRun<CR>", desc = "Execute (CMake)" },
    },
    opts = {
      cmake_build_directory = "build",
      cmake_compile_commands_options = {
        action = "none",
      },
      cmake_generate_options = {
        "-DCMAKE_COLOR_DIAGNOSTICS=ON",
        "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON",
        "-G",
        "Ninja",
      },
      cmake_regenerate_on_save = false,
      cmake_runner = {
        name = "quickfix",
      },
      cmake_virtual_text_support = false,
    },
  },
}
