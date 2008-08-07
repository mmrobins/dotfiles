set viminfo='20,\"50,%  " (vi) read/write a .viminfo file, don't store more
                        " than 50 lines of registers
autocmd BufEnter * lcd %:p:h
set hidden

function! GoToTheTest()
    if match( expand("%:p"), "/\\CTEST/" ) <= -1
        :e TEST/%
    endif
endfunc

map  ,gt      :call GoToTheTest()<cr>
map! ,gt <ESC>:call GoToTheTest()<cr>i

