

nnoremap <Leader>lb <Cmd>call VSCodeNotify('workbench.action.terminal.toggleTerminal')<CR><Cmd> call VSCodeNotify('workbench.action.terminal.sendSequence', {"text": "npm run dev\u000D"} )<CR>
" nnoremap <Leader>ls <Cmd>call VSCodeNotify("wolf.stopBarking")<CR>
" nnoremap <Leader>lt <Cmd>call VSCodeNotify("testing.runAll")<CR>
nnoremap <Leader>lt <Cmd>call VSCodeNotify('workbench.action.terminal.toggleTerminal')<CR><Cmd> call VSCodeNotify('workbench.action.terminal.sendSequence', {"text": "npm run test\u000D"} )<CR>

nnoremap <Leader>lf <Cmd>call VSCodeNotify("eslint.executeAutofix")<CR>

"  nnoremap <Leader>ls <Cmd>call VSCodeExtensionNotify('open-file', '/Users/Sami/workspace/test.txt' )<CR>
"  nnoremap <Leader>lt <Cmd>call VSCodeExtensionNotify("open-file", "/Users/Sami/workspace/test.txt" )<CR>

"  nnoremap <Leader>ls <Cmd>call FuzzyFind() <CR>