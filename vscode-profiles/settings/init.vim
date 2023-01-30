set clipboard=unnamedplus

" vim.g.mapleader = ' '
let mapleader="\<Space>"

" keymaps
nnoremap <Leader>c <Cmd>call VSCodeNotify("workbench.action.closeActiveEditor")<CR>
nnoremap <Leader>e <Cmd>call VSCodeNotify("workbench.action.toggleSidebarVisibility")<CR>

nnoremap <Leader>zen <Cmd>call VSCodeNotify("workbench.action.toggleZenMode")<CR>

xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine

nnoremap gr <Cmd>call VSCodeNotify("editor.action.goToReferences")<CR>
nnoremap gs <Cmd>call VSCodeNotify("workbench.action.gotoSymbol")<CR>

nnoremap <S-l> <Cmd>call VSCodeNotify("workbench.action.nextEditor")<CR>
nnoremap <S-h> <Cmd>call VSCodeNotify("workbench.action.previousEditor")<CR>

" LSP
nnoremap <Leader>la <Cmd>call VSCodeNotify("editor.action.quickFix")<CR>
nnoremap <Leader>lr <Cmd>call VSCodeNotify("editor.action.rename")<CR>
nnoremap <Leader>lj <Cmd>call VSCodeNotify("editor.action.marker.nextInFiles")<CR>
nnoremap <Leader>lk <Cmd>call VSCodeNotify("editor.action.marker.prevInFiles")<CR>

nnoremap <Leader>ls <Cmd>call VSCodeNotify("breadcrumbs.focusAndSelect")<CR>




nnoremap <Leader>lf <Cmd>call VSCodeNotify("editor.action.formatDocument")<CR>


nnoremap <Leader>lb <Cmd>call VSCodeNotify('workbench.action.terminal.toggleTerminal')<CR><Cmd> call VSCodeNotify('workbench.action.terminal.sendSequence', {"text": "make run\u000D"} )<CR>
nnoremap <Leader>lt <Cmd>call VSCodeNotify('workbench.action.terminal.toggleTerminal')<CR><Cmd> call VSCodeNotify('workbench.action.terminal.sendSequence', {"text": "make test\u000D"} )<CR>

" nnoremap <Leader>ls <Cmd>call VSCodeNotify("wolf.stopBarking")<CR>
" nnoremap <Leader>ll <Cmd>call VSCodeNotify("python.runLinting")<CR>
