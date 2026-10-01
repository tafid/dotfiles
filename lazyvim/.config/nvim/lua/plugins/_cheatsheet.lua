-- Шпаргалка по lua/plugins/*.lua. Файл не загружается (return {}), можно удалить.
-- Реальные примеры: example.lua. Подключение языков/наборов: :LazyExtras
if true then return {} end

-- Каждый файл в lua/plugins/ возвращает таблицу спеков; спек плагина LazyVim
-- СЛИВАЕТСЯ с родным, поэтому указываем только то, что меняем.
return {
  -- Изменить опции (таблица сливается с дефолтами)
  { "folke/snacks.nvim", opts = { picker = { sources = { files = { hidden = true } } } } },

  -- Изменить уже собранные опции функцией (например, дополнить список)
  { "plugin/name", opts = function(_, opts) table.insert(opts.sources, { name = "x" }) end },

  -- Клавиши: добавить / переопределить / отключить (false)
  { "folke/snacks.nvim", keys = {
    { "<leader>/", false },
    { "<leader>fp", function() end, desc = "Описание" },
  } },

  -- Добавить новый плагин
  { "user/repo", event = "VeryLazy", opts = {} },

  -- Отключить плагин
  { "akinsho/bufferline.nvim", enabled = false },
}

-- Практические советы:
-- * Сначала загляни в :LazyExtras: языки, линтеры, telescope и т.д. уже готовы.
-- * Какие opts есть у плагина: :Lazy -> выбрать плагин, спек LazyVim или README самого плагина.
-- * `opts = { ... }` дополняет настройки; `opts = function(_, opts) ... end` меняет уже собранную таблицу.
-- * Пикер по умолчанию - snacks.nvim (<leader>e, <leader><space>, <leader>/), а не telescope.
--   Настройки telescope без extra editor.telescope ни на что не влияют.
-- * lazy-lock.json меняется сам при :Lazy update; коммить его, чтобы версии плагинов
--   совпадали на разных машинах.
-- * Свои настройки только в ~/.config/nvim/lua/, исходники LazyVim не править.
-- * Куда что писать: options -> config/options.lua, клавиши -> config/keymaps.lua,
--   автокоманды -> config/autocmds.lua, плагины -> plugins/*.lua.
