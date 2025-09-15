return {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      workspace = {
        library = {
          "$VIMRUNTIME",
          "$HOME/.local/share/nvim/lazy",
        },
      },
    },
  },
}
