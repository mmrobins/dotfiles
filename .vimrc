set nocompatible          " We're running Vim, not Vi!
syntax on                 " Enable syntax highlighting
filetype plugin indent on " Enable filetype-specific indenting and plugins
let mapleader = ","

runtime! macros/matchit.vim

" history for vim
set viminfo='100,\"50,<500,:100 " 100 files, 50 registers, 500 lines in registers, 100 command history

" remember buffers between sessions - strange, didnt need this until using mac
:exec 'set viminfo=%,' . &viminfo

" When using non-terminal vim this proved necessary and can't hurt to have anyway
set background=dark

" Tab spacing
set shiftwidth=4 "number of space characters inserted for indentation
set tabstop=4 "number of space characters for tab key
set expandtab "use spaces instead of tab characters
set sw=4 " Shift width
set smarttab
set ai "Auto indent
"set list listchars=tab:>-, trail:., extends:>, precedes:<, eol:$
set list listchars=tab:>-,trail:.,extends:>,precedes:<

" file name completion
set wildmenu
set wildmode=longest,list

" Status Line
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
"set statusline=[%n]\ %.300F\ %(\ %M%R%H)%)\%=\@(%l\,%c%V)\ %P
"set statusline=%F%m%r%h%w\ (%{&ff}){%Y}[%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
"set statusline=%<%F%h%m%r%h%w%y\ %{&ff}\ %{strftime(\"%d/%m/%Y-%H:%M\")}%=\ col:%c%V\ ascii:%b\ pos:%o\ lin:%l\,%L\ %P
"set statusline=%<%F%h%m%r%h%w%y\ %{&ff}\ %{strftime(\"%c\",getftime(expand(\"%:p\")))}%=\ lin:%l\,%L\ col:%c%V\ pos:%o\ ascii:%b\ %P
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
set laststatus=2 "Always show status line
highlight StatusLine ctermfg=darkblue ctermbg=grey

" Searching
set ignorecase
set smartcase " Smart case in search patterns when 'ignorecase' is on
set incsearch " Incremental search
set hlsearch  " highlight matches

" Still trying to figure out if the mouse is usefull.  Messes up copy paste from terminal
" set mouse=nv

" Buffers
map <leader>be :BufExplorer<cr>
map <leader>bp :BufExplorer<cr>j<cr>
autocmd BufEnter * lcd %:p:h:gs/ /\\ / " working directory is whatever file you're working in, not root
set hidden " allow unsaved hidden buffers

" For modifying the .vimrc
nmap <leader>e :e $HOME/.vimrc<cr>
nmap <leader>s :write!<cr>:source $HOME/.vimrc<cr>
" For modifying the .bashrc
nmap <leader>b :e $HOME/.bashrc<cr>
nmap <leader>d :write!<cr>:!source $HOME/.bashrc<cr>

" pasting without alignment problems
map! <leader>p <Esc>:set paste!<cr>i
map  <leader>p :set paste!<cr>i

" Perl Debugging
map <leader>dd A<cr>use Data::Dump qw/ dump /;<cr>die dump
map <leader>wd A<cr>use Data::Dump qw/ dump /;<cr>warn dump

" Folding and unfolding
map <leader>f :set foldmethod=indent<cr>zM<cr>
map <leader>F :set foldmethod=manual<cr>zR<cr>

" Toggling the taglist
map <leader>l :TlistToggle<cr>

map <leader>sql <Esc>:g/,/:%s/, /,\r/g<cr>:%s/select /select\r/<cr>:%s/from\\|where\\|group by\\|order by/\r&/g<cr>:%s/\(from\\|where\\|group by\\|order by\) /&\r/g<cr>:g/ inner join/:%s/ inner join/\rinner join/g<cr>:g/ and/:%s/ and/\rand/g<cr>:g!/select\\|from\\|where\\|group by\\|order by\\|\//><cr>

" Highlights code that goes beyond 100 chars
match Todo '\%101v'

" Run Ruby unit tests with gT (for all) or gt (only test under
" cursor) in command mode
augroup RubyTests
  au!
  autocmd BufRead,BufNewFile *_test.rb,test_*.rb
    \ :nmap <leader>t V:<C-U>!$HOME/.vim/ruby_run_focused_unit_test
    \ % <C-R>=line("'<")<CR>p <CR>|
    \ :nmap <leader>T :<C-U>!ruby %<CR>
augroup END

" Twitter
if filereadable(expand($HOME . "/.vim_private_mattrobinsonnet"))
    map <leader>pw <Esc>:source ~/.vim_private_mattrobinsonnet<cr>:PosttoTwitter<cr>
endif
if filereadable(expand($HOME . "/.vim_private_mmrobins"))
    map <leader>pp <Esc>:source ~/.vim_private_mmrobins<cr>:PosttoTwitter<cr>
endif

" Use ack instead of grep
set grepprg=ack\ -a\ --nobinary\ --sort-files\ --color

"puppet test switching - may want to encapsulate this for other projects if I find I need that
function! GoToTheImplementation()
    if match( expand("%:p"), "spec/unit" ) > -1
        :e %:p:s?spec/unit?lib/puppet?
    endif
endfunc

function! GoToTheTest()
    if match( expand("%:p"), "lib/puppet" ) > -1
        :e %:p:s?lib/puppet?spec/unit?
    endif
endfunc
map  <leader>gt      :call GoToTheTest()<CR>
map! <leader>gt <ESC>:call GoToTheTest()<CR>i
map  <leader>gi      :call GoToTheImplementation()<CR>
map! <leader>gi <ESC>:call GoToTheImplementation()<CR>i

" showing git diffs
map  <leader>sd      :w!<CR>:! git diff HEAD % \| diff_painter.pl \| less -R<CR>
map! <leader>sd <ESC>:w!<CR>:! git diff HEAD % \| diff_painter.pl \| less -R<CR>

function! RunSpec(args)
    if exists("b:rails_root") && filereadable(b:rails_root . "/script/spec")
      let spec = b:rails_root . "/script/spec"
    else
      let spec = "spec"
    end
    let cmd = ":! " . spec . " % -cfn --loadby mtime " . a:args
    execute cmd
endfunction

" run one rspec example or describe block based on cursor position
map <leader>t <ESC>:w<cr>:call GoToTheTest()<CR>:call RunSpec("-l " . <C-r>=line('.')<CR>)<CR>
" run full rspec file
map <leader>T <ESC>:w<cr>:call GoToTheTest()<CR>:call RunSpec("")<CR>

" remove trailing whitespace
map  <leader>wt      :%s/\s\+$//<cr>
map! <leader>wt <esc>:%s/\s\+$//<cr>i

function! CdRoot()
    if match( expand("%:p"), "work/" ) > -1
        :cd %:p:s?\(work/\w\+/\).*?\1?
    endif
endfunction
map <leader>cr <esc>:call CdRoot()<CR>
map <leader>ack <esc>:call CdRoot()<CR>:Ack

function! GoToTheModule()
    let module_path = expand("%:p")
    echo module_path
    if match(module_path, '/puppet/lib') > 0
        let module_path = substitute(module_path, '/puppet/lib/.*', '/puppet/lib/', '')

        if match(getline('.'), '[_a-zA-Z0-9]\+::[_a-zA-Z0-9:]\+') > -1
            let module_name = matchstr(getline('.'), '[_a-zA-Z0-9]\+::[_a-zA-Z0-9:]\+')
            let module_path = module_path . substitute(module_name, "::", "/", "g") . '.rb'
            execute ":edit " . module_path
        else
            echom "no use line recognized with my wimpy regex"
        endif
    else
        echom "no puppet lib found in " . module_path
    endif
endfunction
map  <leader>gm      :call GoToTheModule()<cr>

function! Auto_Tableize()
endfunction
map  ,a      :call Auto_Tableize()<cr>
map! ,a <esc>:call Auto_Tableize()<cr>i
