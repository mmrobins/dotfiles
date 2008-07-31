set nocompatible          " We're running Vim, not Vi!
syntax on                 " Enable syntax highlighting
filetype plugin indent on " Enable filetype-specific indenting and plugins

let g:rtk_user_customized_vimrc_files_dir='~/.vimrc_files/'
source ~/.vimrc_files/reasonably_stable_mappings.vim
map ,be :BufExplorer<cr>

set shiftwidth=4
set tabstop=4
set expandtab
set smarttab
set ai
"set list listchars=tab:>-, trail:., extends:>, precedes:<, eol:$
set list listchars=tab:>-,trail:.,extends:>,precedes:<
" file name completion
set wildmenu
set wildmode=longest,list

" For modifying the .vimrc
nmap ,e :e $HOME/.vimrc<cr>

" For modifying the .bashrc
nmap ,b :e $HOME/.bashrc<cr>

nmap ,s :write!<cr>:source $HOME/.vimrc<cr>
nmap ,d :write!<cr>:!source $HOME/.bashrc<cr>

map! ,p <Esc>:set paste!<cr>i

highlight StatusLine ctermfg=darkblue ctermbg=grey
set statusline=[%n]\ %.300F\ %(\ %M%R%H)%)\%=\@(%l\,%c%V)\ %P
set laststatus=2
set ignorecase
set smartcase         " Smart case in search patterns when 'ignorecase' is on
set incsearch

" Folding and unfolding
map ,f :set foldmethod=indent<cr>zM<cr>
map ,F :set foldmethod=manual<cr>zR<cr>

