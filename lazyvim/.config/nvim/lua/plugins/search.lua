-- Показывать скрытые и игнорируемые (.gitignore) файлы в explorer, поиске файлов и grep
local show_all = {
  hidden = true,
  ignored = true,
  exclude = { ".git/", "node_modules/" }, -- мусор, в котором искать не нужно
}

return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = show_all,
        files = show_all,
        grep = show_all,
        grep_word = show_all,
        grep_buffers = show_all,
      },
    },
  },
}
