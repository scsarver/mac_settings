"https://dougblack.io/words/a-good-vimrc.html
set number " show line numbers in vim
set relativenumber " show relative line numbers
syntax enable           " enable syntax processing
colorscheme slate         " awesome colorscheme
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set expandtab       " tabs are spaces
set showcmd             " show command in bottom bar
set cursorline          " highlight current line
set wildmenu            " visual autocomplete for command menu
set lazyredraw          " redraw only when we need to.
set showmatch           " highlight matching [{()}]
set incsearch           " search as characters are entered
set hlsearch            " highlight matches
" turn off search highlight
nnoremap ,<space>  :nohlsearch<CR>
