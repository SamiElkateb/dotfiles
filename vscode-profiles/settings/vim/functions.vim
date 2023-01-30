function IsExtension(extension) 
    let s:current_extension=expand('%:e')
    if match(s:current_extension, a:extension) == -1
        return 0
    else
        return 1
    endif
endfunction