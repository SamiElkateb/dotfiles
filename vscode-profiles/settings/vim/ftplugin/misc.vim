nnoremap <Leader>lf <Cmd>call VSCodeNotify("editor.action.formatDocument")<CR>

function MiscBuildFunction()
    if IsExtension('plantuml')
        call VSCodeNotify('plantuml.preview') 
    elseif IsExtension('tex')
        call VSCodeNotify('latex-workshop.view') 
    elseif IsExtension('md')
        call VSCodeNotify('markdown.showPreview') 
    endif
endfunction
nnoremap <Leader>lb <Cmd>:call MiscBuildFunction()<CR>

" nnoremap <Leader>ls <Cmd>call VSCodeNotify("wolf.stopBarking")<CR>
" nnoremap <Leader>lt <Cmd>call VSCodeNotify("testing.runAll")<CR>
" nnoremap <Leader>ll <Cmd>call VSCodeNotify("python.runLinting")<CR>