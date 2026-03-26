" --- Plugins

call plug#begin('~/.vim/plugged')

" General
Plug 'junegunn/vim-easy-align'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' } " Color scheme

call plug#end()


" --- Colors

" set background=dark
" colorscheme tokyonight-day

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

