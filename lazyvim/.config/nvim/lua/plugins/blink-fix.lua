if true then
  return {}
end

return {
  {
    "saghen/blink.cmp",
    opts = {
      fuzzy = {
        implementation = "lua", -- Переключает поиск на чистый Lua без компиляции Rust
      },
    },
  },
}
