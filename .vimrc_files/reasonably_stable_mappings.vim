
if has('eval')
    let g:rtk_vimrc_files_dir='/usr/local/etc/vimrc_files/'
    function! RTKSource(file)
        if exists("g:rtk_user_customized_vimrc_files_dir")
            exec('source ' . g:rtk_user_customized_vimrc_files_dir . a:file)
        else
            exec('source ' . g:rtk_vimrc_files_dir . a:file)
        endif
    endfunction

    set nocompatible
    call RTKSource('go_to_base_class.vim')
    call RTKSource('go_to_component.vim')
    call RTKSource('go_to_path.vim')
    call RTKSource('go_to_module.vim')
    call RTKSource('go_to_test.vim')
    call RTKSource('run_the_test.vim')
    call RTKSource('go_to_implementation.vim')
    call RTKSource('html_formatting.vim')
    call RTKSource('text_formatting.vim')
    call RTKSource('show_diff.vim')
endif

