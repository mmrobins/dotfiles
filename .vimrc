set nocompatible          " We're running Vim, not Vi!
syntax on                 " Enable syntax highlighting
filetype plugin indent on " Enable filetype-specific indenting and plugins

" Rentrak specific stuff
let g:rtk_user_customized_vimrc_files_dir='~/.vimrc_files/'
source ~/.vimrc_files/reasonably_stable_mappings.vim

" Tab spacing
set shiftwidth=4 "number of space characters inserted for indentation
set tabstop=4 "number of space characters for tab key
set expandtab "use spaces instead of tab characters
set smarttab
set ai "Auto indent
"set list listchars=tab:>-, trail:., extends:>, precedes:<, eol:$
set list listchars=tab:>-,trail:.,extends:>,precedes:<

" file name completion
set wildmenu
set wildmode=longest,list

" Status Line
set statusline=[%n]\ %.300F\ %(\ %M%R%H)%)\%=\@(%l\,%c%V)\ %P
"set statusline=%F%m%r%h%w\ (%{&ff}){%Y}[%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")} 
"set statusline=%<%F%h%m%r%h%w%y\ %{&ff}\ %{strftime(\"%d/%m/%Y-%H:%M\")}%=\ col:%c%V\ ascii:%b\ pos:%o\ lin:%l\,%L\ %P 
"set statusline=%<%F%h%m%r%h%w%y\ %{&ff}\ %{strftime(\"%c\",getftime(expand(\"%:p\")))}%=\ lin:%l\,%L\ col:%c%V\ pos:%o\ ascii:%b\ %P 
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")} 
set laststatus=2 "Always show status line
highlight StatusLine ctermfg=darkblue ctermbg=grey

" Searching
set ignorecase
set smartcase " Smart case in search patterns when 'ignorecase' is on
set incsearch "Incremental search

" Mouse usable in xterm but messes up other stuff like ctrl+M
" set mouse=a

map ,be :BufExplorer<cr>

" For modifying the .vimrc
nmap ,e :e $HOME/.vimrc<cr>
nmap ,s :write!<cr>:source $HOME/.vimrc<cr>
" For modifying the .bashrc
nmap ,b :e $HOME/.bashrc<cr>
nmap ,d :write!<cr>:!source $HOME/.bashrc<cr>

map! ,p <Esc>:set paste!<cr>i
map  ,p :set paste!<cr>i

" Folding and unfolding
map ,f :set foldmethod=indent<cr>zM<cr>
map ,F :set foldmethod=manual<cr>zR<cr>

" Toggling the taglist
map ,l :TlistToggle<cr>

" Highlights code that goes beyond 100 chars
match Todo '\%101v'

