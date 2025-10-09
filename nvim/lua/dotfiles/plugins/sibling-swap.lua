return {
  {
    "Wansmer/sibling-swap.nvim",
    keys = {
      { "<C-h>", function() require("sibling-swap").swap_with_left() end, desc = "Swap with left" },
      { "<C-l>", function() require("sibling-swap").swap_with_right() end, desc = "Swap with right" },
    },
    opts = { use_default_keymaps = false },
  },
}
