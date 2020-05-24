" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

Plug 'bronson/vim-trailing-whitespace'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }

" Gruvbox colors
Plug 'morhetz/gruvbox'

" Initialize plugin system
call plug#end()

" Set gruvbox colorsheme
set nocompatible
set t_Co=16
" set t_Co=256
syntax on
colorscheme gruvbox

set background=dark

" Basic config
syntax enable
set number relativenumber
set tabstop=4

set paste
