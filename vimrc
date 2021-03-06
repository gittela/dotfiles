set nocompatible              " be iMproved, required
filetype off                  " required
 
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
 
" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
 
Plugin 'tpope/vim-rails' 

Plugin 'Lokaltog/vim-distinguished'

call vundle#end()            " required

filetype plugin on
syntax on

" SECURE: Do not parse mode comments in files.
set modelines=0

" Large undo levels.
set undolevels=1000

" Size of command history.
set history=50

" Always use unicode.
set encoding=utf8

" Fix backspace.
" set backspace=indent,eol,start

" Keep a backup file.
set backup

" Do not back up temporary files.
set backupskip=/tmp/*,/private/tmp/*"

" Store backup files in one place.
set backupdir^=$HOME/.vim/backup//

" Store swap files in one place.
set dir^=$HOME/.vim/swap//

" Store undo files in one place.
set undodir^=$HOME/.vim/undo//

" Store view files in one place.
set viewdir=$HOME/.vim/view//

" Save undo tree.
set undofile

" Allow undoing a reload from disk.
set undoreload=1000

set tabstop=2
set shiftwidth=2
set expandtab
if &t_Co == 256
  colo distinguished
endif
let mapleader = ','
set nu
set ruler
set cc=80
