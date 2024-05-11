" --- General

set nu
set relativenumber

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

Plug 'folke/tokyonight.nvim', { 'branch': 'main' } " Color scheme

call plug#end()


" --- Colors

set background=dark
colorscheme tokyonight-night
