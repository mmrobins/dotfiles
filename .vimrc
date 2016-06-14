execute pathogen#infect()
exe "set path=".expand("$PATH")

" :echo g:colors_name to find out current color scheme
" colorscheme desert
" colorscheme desert256
colorscheme desert256v2
" colorscheme darkocean
" colorscheme evening_2
" I like these colors better but the visual highlighting mode is terrible
" colorscheme wombat
" colorscheme zenburn
" colorscheme solarized

" change the default EasyMotion shading to something more readable with many
" color schemes
hi link EasyMotionTarget ErrorMsg
hi link EasyMotionShade  Comment

" This fixes the visual highlighting being too light
" autocmd VimEnter,Colorscheme * :hi Visual term=reverse cterm=reverse guibg=LightGrey

" When using non-terminal vim this proved necessary and can't hurt to have anyway
set background=dark

let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=3
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=4

set nocompatible          " We're running Vim, not Vi!
syntax on                 " Enable syntax highlighting
filetype plugin indent on " Enable filetype-specific indenting and plugins
let mapleader = ","

runtime! macros/matchit.vim

" history for vim
set viminfo='100,\"50,<500,:100 " 100 files, 50 registers, 500 lines in registers, 100 command history
"set history=100000

" remember buffers between sessions - strange, didnt need this until using mac
:exec 'set viminfo=%,' . &viminfo

" Tab spacing
set shiftwidth=2 "number of space characters inserted for indentation
set tabstop=2 "number of space characters for tab key
set expandtab "use spaces instead of tab characters
set sw=2 " Shift width
set smarttab
set ai "Auto indent
"set list listchars=tab:>-, trail:., extends:>, precedes:<, eol:$
" show trailing whitespace without being annoying
set list listchars=tab:>-,trail:.,extends:>,precedes:<

" Remove trailing whitespace whenever I save
" But it makes it hard to do separate whitespace commits
" autocmd BufWritePre * :%s/\s\+$//e

" turn off paste on save because I forget to and it messes up my formatting
autocmd BufWritePre * :set nopaste

" file name completion
set wildmenu
set wildmode=list,full

" Status Line
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
"set statusline=[%n]\ %.300F\ %(\ %M%R%H)%)\%=\@(%l\,%c%V)\ %P
"set statusline=%F%m%r%h%w\ (%{&ff}){%Y}[%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
"set statusline=%<%F%h%m%r%h%w%y\ %{&ff}\ %{strftime(\"%d/%m/%Y-%H:%M\")}%=\ col:%c%V\ ascii:%b\ pos:%o\ lin:%l\,%L\ %P
"set statusline=%<%F%h%m%r%h%w%y\ %{&ff}\ %{strftime(\"%c\",getftime(expand(\"%:p\")))}%=\ lin:%l\,%L\ col:%c%V\ pos:%o\ ascii:%b\ %P
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
set laststatus=2 "Always show status line
set encoding=utf-8 " Necessary to show Unicode glyphs

highlight StatusLine ctermfg=darkblue ctermbg=grey

" Searching
set ignorecase
set smartcase " Smart case in search patterns when 'ignorecase' is on
set incsearch " Incremental search
set hlsearch  " highlight matches
set hl=l:Visual " make highlights easier to see

" Still trying to figure out if the mouse is usefull.  Messes up copy paste from terminal
" set mouse=nv

" Buffers
" previous buffer
map <leader>bp <C-^>
set hidden " allow unsaved hidden buffers
" working directory is whatever file you're working in, not root
" but this messes up Gblame, screw Gblame, I can change to root if I need it
" autocmd BufEnter * lcd %:p:h:gs/ /\\ /

" For modifying the .vimrc
nmap <leader>e :e $HOME/.vimrc<cr>
nmap <leader>s :write!<cr>:source $HOME/.vimrc<cr>
" For modifying the .bashrc
" nmap <leader>b :e $HOME/.bashrc<cr>
" nmap <leader>d :write!<cr>:!source $HOME/.bashrc<cr>

" pasting without alignment problems
"map! <leader>p <Esc>:set paste!<cr>i
"map  <leader>p :set paste!<cr>i
set pastetoggle=<leader>p

" Perl Debugging
" map <leader>dd A<cr>use Data::Dump qw/ dump /;<cr>die dump
" map <leader>wd A<cr>use Data::Dump qw/ dump /;<cr>warn dump

" Folding and unfolding
" I almost never use these anymore now that I'm not in Perl
map <leader>f :set foldmethod=indent<cr>zM<cr>
map <leader>F :set foldmethod=manual<cr>zR<cr>

" Toggling the taglist
map <leader>l :TlistToggle<cr>

" Reformat sql to look nice
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

" Twitter - this hasn't been too useful, I'll probably delete it soon
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
    if exists("b:rails_root") " && filereadable(b:rails_root . "/script/spec")
      if match( expand("%:p"), "spec" ) > -1
        exec(":A")
      endif
    else
      if match( expand("%:p"), "spec/unit" ) > -1
          let imp_file = substitute(expand("%:p"), "spec/unit", "lib/puppet", "")
          let imp_file = substitute(imp_file, '\(\w\+\)_spec.rb', '\1.rb', '')
          exec(":e ". imp_file)
      else
          let imp_file = substitute(expand("%:p"), 'spec/\(\w\+\)', 'lib/\1', "")
          let imp_file = substitute(imp_file, '\(\w\+\)_spec.rb', '\1.rb', '')
          exec(":e ". imp_file)
      end
    end
endfunc

function! GoToTheTest()
    if exists("b:rails_root") " && filereadable(b:rails_root . "/script/spec")
      if match( expand("%:p"), "spec" ) <= 0
        exec(":A")
      endif
    else
      if match( expand("%:p"), "lib/puppet" ) > -1
          let test_file = substitute(expand("%:p"), "lib/puppet", "spec/unit", "")
          let test_file = substitute(test_file, '\(\w\+\).rb', '\1_spec.rb', '')
          exec(":e ". test_file)
      else
          let test_file = substitute(expand("%:p"), 'lib/\(\w\+\)', 'spec/\1', "")
          let test_file = substitute(test_file, '\(\w\+\).rb', '\1_spec.rb', '')
          exec(":e ". test_file)
      end
    end
endfunc
map  <leader>gt      :call GoToTheTest()<CR>
map! <leader>gt <ESC>:call GoToTheTest()<CR>i
map  <leader>gi      :call GoToTheImplementation()<CR>
map! <leader>gi <ESC>:call GoToTheImplementation()<CR>i

" showing git diffs
map  <leader>sd      :w!<CR>:! git diff --color-words HEAD %<CR>
map! <leader>sd <ESC>:w!<CR>:! git diff --color-words HEAD %<CR>

function! RunSpec(args)
"   if exists("b:rails_root") && filereadable(b:rails_root . "/script/spec")
"     :call CdRoot()
"     let spec = b:rails_root . "/script/spec"
"     let cmd = ":!" . spec . ' ' . expand("%:p") . " -cfn --debugger --loadby mtime --backtrace " . a:args
"   else
      let spec = "bundle exec rspec"
      let cmd = ":!" . spec . ' ' . expand("%:p") . " -bcfd " . a:args
"   end
    execute cmd
endfunction

" run one rspec example or describe block based on cursor position
map <leader>t <ESC>:w<cr>:call GoToTheTest()<CR>:call RunSpec("-l " . <C-r>=line('.')<CR>)<CR>
" run full rspec file
map <leader>T <ESC>:w<cr>:call GoToTheTest()<CR>:call RunSpec("")<CR>

" remove trailing whitespace
map  <leader>wt      :%s/\s\+$//<cr>
map! <leader>wt <esc>:%s/\s\+$//<cr>i

" change to the root of the project director so long as the project is under
" the work directory
function! CdRoot()
    if match( expand("%:p"), "work/" ) > -1
        :cd %:p:s?\(work/.\{-}/\).*?\1?
    endif
endfunction
map <leader>cr <esc>:call CdRoot()<CR>
map <leader>cf <esc>:cd %:p:h:gs/ /\\ /<CR>
map <leader>ack <esc>:call CdRoot()<CR>:Ack

" A hackish attempt at doing an autoalign like I used to have at Rentrak
"map  <leader>a <esc>?^$\\|{\\|(<CR>/ => <CR>V/^$\\|}\\|)<CR>? => <CR>:Align => <CR>/nofindme<CR>
"map! <leader>a <esc>?/^$<CR>V/^$<CR>:Align =><CR>i

"map <leader>pr A<cr>require 'profiler'<cr>Profiler__::start_profile<cr>Profiler__::stop_profile<cr>Profiler__::print_profile($stderr)<ESC>
map <leader>pr A<cr>require 'ruby-prof'<cr>RubyProf.start<cr>rprofresult = RubyProf.stop<cr>printer = RubyProf::GraphPrinter.new(rprofresult)<cr>printer.print(STDOUT,0)<ESC>

" Insert debugger into code at cursor
map <leader>rd A<cr>require 'debugger'; debugger<ESC>
map <leader>rb A<cr>require 'byebug'; byebug<ESC>
map <leader>rp A<cr>binding.pry<ESC>
map <leader>jd A<cr>debugger;<ESC>
map <leader>jc A<cr>console.log();<ESC>hi

" central store for swap files instead of having them sprinkled throughout my projects
set backupdir=~/.vim/backup//
set directory=~/.vim/swp//

" Syntastic syntax checking on save
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_enable_signs=1
let g:syntastic_disabled_filetypes = ['prolog', 'html', 'javascript']

" Mac Clipboard copy and paste
map <leader>- :w! ~/tmp/vimclipboard<cr>:!cat ~/tmp/vimclipboard \| pbcopy<cr><cr>
map <leader>+ :r ~/tmp/vimclipboard<cr>

" Split line, autoformat, autoalign
map <leader>x V:s/\([({[]\)/\1\r/<cr>V:s/\([])}]\)/\r\1/<cr>V%:s/,/,\r/g<cr>jV%=V%:EasyAlign:<cr>

" LESS CSS syntax highlighting
au BufNewFile,BufRead *.less set filetype=less

" Nerdtree toggle
map <leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>

" Gblame
map <leader>gb :Gblame wCM<CR>

cabbr <expr> %% expand('%:p:h')

" not sure why vim has a problem finding ctags
let Tlist_Ctags_Cmd='/usr/local/bin/ctags'
" set iskeyword-=_ " not sure if I'll like this...
map <leader>ct <esc>:!/usr/local/bin/ctags -R<CR>
autocmd BufWritePost *.rb,*.js silent! !/usr/local/bin/ctags -R &> /dev/null &
" bundle list --paths=true | xargs ctags --extra=+f --exclude=.git --exclude=public --exclude=tmp --exclude=*.js --exclude=log -R *

"set iskeyword+=?
"set iskeyword+=!

map <leader>a :execute "Ack " . expand("<cword>") <CR>

noremap Q gqap
command! Prose inoremap <buffer> . .<C-G>u|
            \ inoremap <buffer> ! !<C-G>u|
            \ inoremap <buffer> ? ?<C-G>u|
            \ setlocal spell spelllang=en
            \     nolist nowrap tw=74 fo=t1 nonu|
            \ augroup PROSE|
            \   autocmd InsertEnter <buffer> set fo+=a|
            \   autocmd InsertLeave <buffer> set fo-=a|
            \ augroup END

command! Code silent! iunmap <buffer> .|
            \ silent! iunmap <buffer> !|
            \ silent! iunmap <buffer> ?|
            \ setlocal nospell list nowrap
            \     tw=74 fo=cqr1 showbreak=…|
            \ silent! autocmd! PROSE * <buffer>

au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" craxy slow with long lines
" https://superuser.com/questions/302186/vim-scrolls-very-slow-when-a-line-is-too-long
set synmaxcol=120
set ttyfast " u got a fast terminal
set ttyscroll=3
set lazyredraw " to avoid scrolling problems
set nocursorline
