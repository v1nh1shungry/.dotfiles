---@module "lazy.types"
---@type LazySpec[]
return {
  {
    "junegunn/fzf",
    build = ":call fzf#install()",
    lazy = true,
  },
  {
    "kevinhwang91/nvim-bqf",
    dependencies = "junegunn/fzf",
  },
}
