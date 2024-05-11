" --- General

set nu
set relativenumber

" --- Plugins

call plug#begin('~/.vim/plugged')

" General

Plug 'folke/tokyonight.nvim', { 'branch': 'main' } " Color scheme

call plug#end()


" --- Colors

set background=dark
colorscheme tokyonight-night
