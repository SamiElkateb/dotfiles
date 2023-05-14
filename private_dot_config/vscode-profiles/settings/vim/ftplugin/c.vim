
nnoremap <Leader>lf <Cmd>call VSCodeNotify("editor.action.formatDocument")<CR>


nnoremap <Leader>lb <Cmd>call VSCodeNotify('workbench.action.terminal.toggleTerminal')<CR><Cmd> call VSCodeNotify('workbench.action.terminal.sendSequence', {"text": "make run\u000D"} )<CR>
nnoremap <Leader>lt <Cmd>call VSCodeNotify('workbench.action.terminal.toggleTerminal')<CR><Cmd> call VSCodeNotify('workbench.action.terminal.sendSequence', {"text": "make test\u000D"} )<CR>

" nnoremap <Leader>ls <Cmd>call VSCodeNotify("wolf.stopBarking")<CR>
" nnoremap <Leader>ll <Cmd>call VSCodeNotify("python.runLinting")<CR>
