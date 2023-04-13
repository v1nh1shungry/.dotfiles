return {
  {
    name = 'standalone',
    type = 'codelldb',
    request = 'launch',
    program = '${fileBasenameNoExtension}',
    cwd = '${workspaceFolder}',
  },
}
