set viminfo='20,\"50,%  " (vi) read/write a .viminfo file, don't store more
                        " than 50 lines of registers
autocmd BufEnter * lcd %:p:h
set hidden
source ~msw/.vimrc_sources/go_to_implementation.vim

" yes, this allows non-traditional module names (lowercase, including underscores)
" but it seems such beasts are afoot in these woods. For example,
" RTK::Digitrak::Controllers::branch_area

function! GoToTheBaseClass()
    :write!
    :redraw!
    let l:saved_line_no = line('.')
    let l:saved_col_no = col('.')
    call cursor(l:saved_line_no + 1, col(1))

    let module_path = expand("%:p")
    if !match( module_path, '/perl_lib/')
        echom "no perl_lib found in " . module_path
        return
    else
        let module_path = substitute(module_path, "/perl_lib/.*", "/perl_lib/", "")
    endif

    let use_base_pattern = '^use base '
    if search(use_base_pattern, "bW") || search(use_base_pattern, "W")
        let module_name = matchstr(getline('.'), '[_a-zA-Z0-9]\+::[a-zA-Z0-9:]\+')
        if !strlen(module_name)
            let start = matchend(getline('.'), '\sqw')
            if start < 9
                let start = 9
            endif
            let module_name =  matchstr(getline('.'), '[A-Z][a-zA-Z0-9]\+', start)
            if !strlen(module_name)
                let module_name = matchstr(getline('.'), '[_a-zA-Z0-9]\+', start)
                if !strlen(module_name)
                    echom unable to find base class name in this use line with my wimpy regex
                    return
                endif
            endif
        endif
        let module_path = module_path . substitute(module_name, "::", "/", "g") . '.pm'
        call cursor(l:saved_line_no, l:saved_col_no)
        execute ":edit " . module_path
    elseif match( expand("%:p"), "TEST" ) > -1
        call GoToTheImplementation()
        call GoToTheBaseClass()
    else
        echom "no base class found with my wimpy regex"
    endif
endfunction

map  ,gb      :call GoToTheBaseClass()<cr>
map! ,gb <ESC>:call GoToTheBaseClass()<cr>i

