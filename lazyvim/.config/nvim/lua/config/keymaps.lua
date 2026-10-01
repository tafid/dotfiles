-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("i", "jj", "<Esc>", { silent = true })

-- Примеры:
-- vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
-- vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
-- vim.keymap.del("n", "<leader>l")  -- удалить дефолтную клавишу LazyVim
--
-- Режимы: n=normal, i=insert, v=visual, x=visual-select, t=terminal
-- Клавиши, привязанные к плагину (пикеры, explorer и т.д.), лучше задавать
-- через `keys = {...}` в lua/plugins/*.lua; здесь - только общие.
