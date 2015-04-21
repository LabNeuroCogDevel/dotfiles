set nocompatible
set hidden
set t_Co=256


filetype on
filetype plugin on
syntax enable

set hlsearch

set nu
set showcmd




" Who doesn't like autoindent?
set autoindent
" 8 is default character tab
set shiftwidth=3
set softtabstop=3
set tabstop=3
" Spaces are better than a tab character
set expandtab
set smarttab

set wildmenu
set wildmode=list:longest,full


" sudo save
cmap w!! %!sudo tee > /dev/null %

" perl
let perl_include_pod = 1
" syntax color complex things like @{${"foo"}}
let perl_extended_vars = 1

" jj is escape
inoremap jj <ESC>
" set leader, but , is reverse movement
" let mapleader=","


"""" PLUGINS """"

" use :Bundle* commands
" git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#rc()

Bundle 'xoria256.vim'
colorscheme xoria256

Bundle 'gmarik/vundle'
Bundle 'ZenCoding.vim'

Bundle 'better-snipmate-snippet'
Bundle 'rainbow_parentheses.vim'
" Bundle 'ShowMarks'
" <leader>mt  toggle display

Bundle 'surround.vim'
" ds<">    - delete <">
" cs<"><'> - change " to '
" ys<o><"> - wrap " around object e.g aw 

Bundle 'repeat.vim'
Bundle 'ctrlp.vim'
Bundle 'EasyMotion'
" <leader><leader><motion>

Bundle 'UltiSnips'
Bundle 'commentary.vim'
" \\<motion> comment/uncomment

Bundle "http://github.com/gmarik/vim-visual-star-search.git"
" * or # search for selected text


Bundle 'vim-orgmode'
Bundle 'Markdown-syntax'


" see all "vimux" below
Bundle 'Screen-vim---gnu-screentmux'
Bundle 'Vim-R-plugin'
" \rf - start; \rq - quit
" \bd - send block, go down
" \sd - send selection


" linters
" Bundle 'Syntastic'
" Bundle 'ucompleteme'

"Bundle 'TT2'

" matlab lint, for .m files
Bundle 'matlab.vim'
Bundle 'mlint.vim'
autocmd BufEnter *.m    compiler mlint
" <leader>l

" tmux with vim-screen
let g:ScreenImpl = 'Tmux'


" do syntax checking (lint) on open
let g:syntastic_check_on_open = 1


" solarize
" http://ethanschoonover.com/solarized/vim-colors-solarized
"let g:solarized_termcolors=256

" mini buff
"let g:miniBufExplMapWindowNavVim = 1 
"let g:miniBufExplMapWindowNavArrows = 1 
"let g:miniBufExplMapCTabSwitchBufs = 1 
"let g:miniBufExplModSelTarget = 1 


" UtilSnips
" :h UltiSnips-triggers
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

set guifont=Droid\ Sans\ Mono\ 12

Bundle 'vimux.vim'
" send selction
vmap <leader>s "vy :call VimuxRunCommand(@v . "\n", 0)<CR>
" send selction
nmap <leader>s V<leader>s<CR>
