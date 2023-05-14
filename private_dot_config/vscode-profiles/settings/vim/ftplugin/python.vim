nnoremap <Leader>lf <Cmd>call VSCodeNotify("editor.action.formatDocument")<CR>

let s:barkState = 0
function ToggleBark ()
    if s:barkState == 0
        let s:barkState = 1
        call VSCodeNotify("wolf.barkAtCurrentFile")
    else
        let s:barkState = 0
        call VSCodeNotify("wolf.stopBarking")
    endif
endfunction

nnoremap <Leader>lb <Cmd> :call ToggleBark()<CR>
" nnoremap <Leader>lt <Cmd>call VSCodeNotify("testing.runAll")<CR>
nnoremap <Leader>lt <Cmd>call VSCodeNotify('workbench.action.terminal.toggleTerminal')<CR><Cmd> call VSCodeNotify('workbench.action.terminal.sendSequence', {"text": "pytest\u000D"} )<CR>
nnoremap <Leader>ll <Cmd>call VSCodeNotify("python.runLinting")<CR>
