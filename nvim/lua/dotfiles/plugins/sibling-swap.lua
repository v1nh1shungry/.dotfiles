return {
  {
    "Wansmer/sibling-swap.nvim",
    keys = {
      { "<C-h>", function() require("sibling-swap").swap_with_left() end, desc = "Swap With Left" },
      { "<C-l>", function() require("sibling-swap").swap_with_right() end, desc = "Swap With Right" },
    },
    opts = { use_default_keymaps = false },
  },
}
