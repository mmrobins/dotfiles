set viminfo='20,\"50,%  " (vi) read/write a .viminfo file, don't store more
                        " than 50 lines of registers
autocmd BufEnter * lcd %:p:h
set hidden
source ~msw/.vimrc_sources/go_to_module.vim

" drats. How the heck to I snag the current selection into a var?
function! GoToTheAliasedClass(class)
    :write!
    :redraw!
    echom a:class
    "let l:foo = 1234
    "echo l:foo

endfunction

"map  ,ga      :call GoToTheAliasedClass(<CTRL-R><CTRL-W>)<cr>
"map! ,ga <ESC>:call GoToTheAliasedClass(<CTRL-R><CTRL-W>)<cr>i

map  ,ga      viwy:call GoToTheAliasedClass(@1)<cr>
map! ,ga <ESC>viwy:call GoToTheAliasedClass(@1)<cr>i

