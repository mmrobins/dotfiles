" Only do this part when compiled with support for autocommands.
if has("autocmd")

 augroup gzip
  " Remove all gzip autocommands
  au!

  " Enable editing of gzipped files
  "   read: set binary mode before reading the file
  "   uncompress text in buffer after reading
  "  write: compress file after writing
  " append: uncompress file, append, compress file
  autocmd BufReadPre,FileReadPre  *.gz set bin
  autocmd BufReadPost,FileReadPost  *.gz let ch_save = &ch|set ch=2
  autocmd BufReadPost,FileReadPost  *.gz '[,']!gunzip
  autocmd BufReadPost,FileReadPost  *.gz set nobin
  autocmd BufReadPost,FileReadPost  *.gz let &ch = ch_save|unlet ch_save
  autocmd BufReadPost,FileReadPost  *.gz execute ":doautocmd BufReadPost " . expand("%:r")

  autocmd BufWritePost,FileWritePost  *.gz !mv <afile> <afile>:r
  autocmd BufWritePost,FileWritePost  *.gz !gzip <afile>:r

  autocmd FileAppendPre     *.gz !gunzip <afile>
  autocmd FileAppendPre     *.gz !mv <afile>:r <afile>
  autocmd FileAppendPost    *.gz !mv <afile> <afile>:r
  autocmd FileAppendPost    *.gz !gzip <afile>:r
 augroup END
 augroup bz2
  " Remove all bz2 autocommands
  au!

  " Enable editing of bzipped files
  "   read: set binary mode before reading the file
  "   uncompress text in buffer after reading
  "  write: compress file after writing
  " append: uncompress file, append, compress file
  autocmd BufReadPre,FileReadPre  *.bz2 set bin
  autocmd BufReadPost,FileReadPost  *.bz2 let ch_save = &ch|set ch=2
  autocmd BufReadPost,FileReadPost  *.bz2 '[,']!bunzip2
  autocmd BufReadPost,FileReadPost  *.bz2 set nobin
  autocmd BufReadPost,FileReadPost  *.bz2 let &ch = ch_save|unlet ch_save
  autocmd BufReadPost,FileReadPost  *.bz2 execute ":doautocmd BufReadPost " . expand("%:r")

  autocmd BufWritePost,FileWritePost  *.bz2 !mv <afile> <afile>:r
  autocmd BufWritePost,FileWritePost  *.bz2 !bzip2 <afile>:r

  autocmd FileAppendPre     *.bz2 !bunzip2 <afile>
  autocmd FileAppendPre     *.bz2 !mv <afile>:r <afile>
  autocmd FileAppendPost    *.bz2 !mv <afile> <afile>:r
  autocmd FileAppendPost    *.bz2 !bzip2 <afile>:r
 augroup END

 if 0
  " When editing a file, always jump to the last cursor position.
  " This must be after the uncompress commands.
   autocmd BufReadPost * if line("'\"") && line("'\"") <= line("$") | exe "normal `\"" | endif
 endif

endif " has("autocmd")
