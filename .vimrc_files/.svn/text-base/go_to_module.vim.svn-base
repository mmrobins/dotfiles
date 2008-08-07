set viminfo='20,\"50,%  " (vi) read/write a .viminfo file, don't store more
                        " than 50 lines of registers
autocmd BufEnter * lcd %:p:h
set hidden

" yes, this allows non-traditional module names (lowercase, including underscores)
" but it seems such beasts are afoot in these woods. For example,
" RTK::Digitrak::Controllers::branch_area

function! GoToTheModule()
    :write!
    :redraw!

    let module_path = substitute( expand("%:p"), '/web_src/', '/perl_lib/', '' )
    if !match( module_path, '/perl_lib/')
        echom "no perl_lib found in " . module_path
    else
        let module_path = substitute(module_path, '/perl_lib/.*', '/perl_lib/', '')
    endif

    if match(getline('.'), '^ *use *RTK::Mixin *') > -1
        let module_name = matchstr(getline('.'), '^ *use RTK::Mixin[^a-zA-Z0-9]\+\zs[_a-zA-Z0-9]\+::[_a-zA-Z0-9:]\+\ze')
        let module_path = module_path . substitute(module_name, "::", "/", "g") . '.pm'
        execute ":edit " . module_path
    elseif match(getline('.'), '^ *use ') > -1
        let module_name = matchstr(getline('.'), '[_a-zA-Z0-9]\+::[_a-zA-Z0-9:]\+')
        if !strlen(module_name)
            let module_name =  matchstr(getline('.'), '\(^ *use \)\@<=[_a-zA-Z0-9]\+')
            if !strlen(module_name)
                echom unable to find module name in this use line with my wimpy regex
                return
            endif
        endif
        let module_path = module_path . substitute(module_name, "::", "/", "g") . '.pm'
        execute ":edit " . module_path
    elseif match(getline('.'), '[_a-zA-Z0-9]\+::[_a-zA-Z0-9:]\+')
        let module_name = matchstr(getline('.'), '[_a-zA-Z0-9]\+::[_a-zA-Z0-9:]\+')
        let module_path = module_path . substitute(module_name, "::", "/", "g") . '.pm'
        execute ":edit " . module_path
    else
        echom "no use line recognized with my wimpy regex"
    endif
endfunction

map  ,gm      :call GoToTheModule()<cr>
map! ,gm <ESC>:call GoToTheModule()<cr>i

