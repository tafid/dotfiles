return {
  "shortcuts/no-neck-pain.nvim",
  version = "*", -- использует стабильную версию
  keys = {
    { "<leader>np", "<cmd>NoNeckPain<CR>", desc = "Toggle NoNeckPain" },
  },
  opts = {
    -- Ваши персональные настройки (опционально)
    width = 140,
  },
}
