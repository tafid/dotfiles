-- if true then
--   return {}
-- end

return {
  -- 1. Add the theme plugin from GitHub
  { "olimorris/onedarkpro.nvim", priority = 1000 },

  -- 2. Tell LazyVim to use it as the active colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onelight",
    },
  },
}
