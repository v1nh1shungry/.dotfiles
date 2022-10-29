return {
  cmd = {
    'clangd',
    '--compile-commands-dir=build',
    '--all-scopes-completion',
    '--background-index',
    '--clang-tidy',
    '--completion-style=detailed',
    '--fallback-style=LLVM',
    '--folding-ranges',
    '--function-arg-placeholders',
    '--header-insertion=never',
    '--include-cleaner-stdlib',
    '--enable-config',
    '-j=12',
    '--pch-storage=memory',
  },
  single_file_support = true,
}
