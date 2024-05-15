" --- General

set nu
set relativenumber

" indentation
set autoindent      " Keep indentation from previous line
set smartindent     " Automatically inserts indentation in some cases
set cindent         " Like smartindent, but stricter and more customisable

set expandtab       " Use softtabstop spaces instead of tab characters for indentation
set shiftwidth=4    " Indent by 4 spaces when using >>, <<, == etc.
set softtabstop=4   " Indent by 4 spaces when pressing <TAB>

if has ("autocmd")
    " File type detection. Indent based on filetype. Recommended.
    filetype plugin indent on
endif


" In insert or command mode, move normally by using Ctrl
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
cnoremap <C-h> <Left>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-l> <Right>

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

