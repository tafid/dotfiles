return {
  {
    "Pocco81/auto-save.nvim",
    lazy = false,
    opts = {
      debounce_delay = 500, -- time in ms before saving after a change
      execution_message = {
        message = function()
          return ""
        end, -- disables the "autosave" notification in the bottom right
      },
    },
    keys = {
      { "<leader>uv", "<cmd>ASToggle<CR>", desc = "Toggle autosave" },
    },
  },
}
