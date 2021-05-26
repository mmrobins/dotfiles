call plug#begin()
Plug 'elixir-lang/vim-elixir', { 'for': 'elixir' }
Plug 'flazz/vim-colorschemes'
Plug 'jlanzarotta/bufexplorer'
Plug 'junegunn/vim-easy-align'
Plug 'kien/ctrlp.vim'
Plug 'kien/rainbow_parentheses.vim'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-ruby/vim-ruby'
Plug 'w0rp/ale'
call plug#end()
"Plug 'vim-syntastic/syntastic'

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

" show line numbers
set number

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
" set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
"set statusline=[%n]\ %.300F\ %(\ %M%R%H)%)\%=\@(%l\,%c%V)\ %P
"set statusline=%F%m%r%h%w\ (%{&ff}){%Y}[%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
"set statusline=%<%F%h%m%r%h%w%y\ %{&ff}\ %{strftime(\"%d/%m/%Y-%H:%M\")}%=\ col:%c%V\ ascii:%b\ pos:%o\ lin:%l\,%L\ %P
"set statusline=%<%F%h%m%r%h%w%y\ %{&ff}\ %{strftime(\"%c\",getftime(expand(\"%:p\")))}%=\ lin:%l\,%L\ col:%c%V\ pos:%o\ ascii:%b\ %P
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
set laststatus=2 "Always show status line
set encoding=utf-8 " Necessary to show Unicode glyphs

" highlight StatusLine ctermfg=darkblue ctermbg=grey

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
"map <leader>l :TlistToggle<cr>

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
  if match( expand("%:p"), "spec" ) > -1
    exec(":A")
  endif
endfunc

function! GoToTheTest()
  if match( expand("%:p"), "spec" ) <= 0
    exec(":A")
  endif
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
      let cmd = ":!" . spec . ' ' . expand("%:p") . a:args . " -bcfd "
"   end
    execute cmd
endfunction

" run one rspec example or describe block based on cursor position
map <leader>t <ESC>:w<cr>:call GoToTheTest()<CR>:call RunSpec(":" . <C-r>=line('.')<CR>)<CR>
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
map <leader>ep A<cr>require IEx; IEx.pry<ESC>
map <leader>rp A<cr>binding.pry<ESC>
map <leader>jd A<cr>debugger;<ESC>
map <leader>jc A<cr>console.log();<ESC>hi

" central store for swap files instead of having them sprinkled throughout my projects
"set backupdir=~/.vim/backup//
"set directory=~/.vim/swp//
" I just don't need swap, have git and save all the time
set nobackup
set noswapfile

" Syntastic syntax checking on save
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
"
"let g:syntastic_enable_signs=1
"let g:syntastic_disabled_filetypes = ['prolog', 'html']
"let g:syntastic_javascript_checkers = ['eslint']
" let g:syntastic_elixir_checkers = ['elixir']
" let g:syntastic_enable_elixir_checker = 1
" let g:syntastic_debug = 1

" Mac Clipboard copy and paste
map <leader>- :w! ~/tmp/vimclipboard<cr>:!cat ~/tmp/vimclipboard \| pbcopy<cr><cr>
map <leader>+ :r ~/tmp/vimclipboard<cr>
" http://vim.wikia.com/wiki/Mac_OS_X_clipboard_sharing
set clipboard=unnamed

" Split line, autoformat, autoalign
map <leader>x V:s/\([({[]\)/\1\r/<cr>V:s/\([])}]\)/\r\1/<cr>V%:s/,/,\r/g<cr>jV%=V%:EasyAlign:<cr>

" LESS CSS syntax highlighting
au BufNewFile,BufRead *.less set filetype=less

" Nerdtree toggle
map <leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>

" Gblame
map <leader>gb :Gblame<CR>

cabbr <expr> %% expand('%:p:h')

" not sure why vim has a problem finding ctags
"let Tlist_Ctags_Cmd='/usr/local/bin/ctags'
" set iskeyword-=_ " not sure if I'll like this...
"map <leader>ct <esc>:!/usr/local/bin/ctags -R<CR>
"autocmd BufWritePost *.rb,*.js silent! !/usr/local/bin/ctags -R &> /dev/null &
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
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git\|deps\|_build'

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Set specific linters
"let g:ale_linters = {
"\   'javascript': ['eslint'],
"\   'ruby': ['standardrb', 'rubocop'],
"\}
" Only run linters named in ale_linters settings.
"let g:ale_linters_explicit = 1
let g:airline#extensions#ale#enabled = 1
let g:ale_sign_column_always = 1
"let g:ale_set_highlights = 1
"let g:ale_set_loclist = 0
"let g:ale_set_quickfix = 1
"let g:ale_sign_error = '●'
"let g:ale_sign_warning = '.'
let g:ale_lint_on_save = 1
let g:ale_terraform_terraform_executable = 'terraform'
"let g:ale_linters = {
"      \ 'ruby': ['ruby', 'standardrb', 'rubocop'],
"      \ 'vim': ['vint'],
"      \}
let g:ale_linters = {
      \ 'ruby': ['ruby', 'rubocop'],
      \ 'vim': ['vint'],
      \}
let g:ale_ruby_rubocop_executable = $HOME.'/.rbenv/shims/bundle'

" https://github.com/vim-airline/vim-airline/issues/1845
let g:airline_section_a = '' " hide mode
let g:airline_section_b = '' " hide git branch, it's in my prompt
let g:airline_section_z = '%l:%c ascii:%b' " line:column ascii:code

" https://flowfx.de/blog/teach-vim-rails-about-request-specs/
let g:rails_projections = {
      \ "app/controllers/*_controller.rb": {
      \   "test": [
      \     "spec/controllers/{}_controller_spec.rb",
      \     "spec/requests/{}_spec.rb"
      \   ],
      \ },
      \ "spec/requests/*_spec.rb": {
      \   "alternate": [
      \     "app/controllers/{}_controller.rb",
      \   ],
      \ }}
