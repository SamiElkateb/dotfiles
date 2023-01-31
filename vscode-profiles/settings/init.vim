function IsExtension(extension) 
    let s:current_extension=expand('%:e')
    if match(s:current_extension, a:extension) == -1
        return 0
    else
        return 1
    endif
endfunction


let s:isFuzzyFinding=0
function FuzzyFind() 
    call VSCodeNotify('workbench.action.terminal.toggleTerminal')
    call VSCodeNotify('workbench.action.terminal.sendSequence', {"text": "fuzzyvscode \u000D"} )
    let s:isFuzzyFinding=1
endfunction

function FuzzyFindOpen() 
    if s:isFuzzyFinding 
        sleep 100m
        "  let file_path = $SHELL
        "  let file_path = system('echo $SHELL')
        let s:file_path = system("cat $TMPDIR/fuzzyselection.txt | awk -F'[:]' '{print $1}'")
        let s:file_line_number = system("cat $TMPDIR/fuzzyselection.txt | awk -F'[:]' '{print $2}'")
        let s:file_line_horizontal = system("cat $TMPDIR/fuzzyselection.txt | awk -F'[:]' '{print $3}'")
        "  let file_path = "echo fuzzycodetest"
        call VSCodeExtensionNotify('open-file', s:file_path )
        let s:isFuzzyFinding=0
    endif
endfunction
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

nnoremap <Leader>sf <Cmd>call VSCodeNotify("find-it-faster.findWithinFiles")<CR>
"  nnoremap <Leader>sf <Cmd>call FuzzyFind()<CR>
"  nnoremap <C-h> <Cmd>call FuzzyFindOpen() <CR>



nnoremap <Leader>lb <Cmd>call VSCodeNotify('workbench.action.terminal.toggleTerminal')<CR><Cmd> call VSCodeNotify('workbench.action.terminal.sendSequence', {"text": "npm run dev\u000D"} )<CR>
" nnoremap <Leader>ls <Cmd>call VSCodeNotify("wolf.stopBarking")<CR>
" nnoremap <Leader>lt <Cmd>call VSCodeNotify("testing.runAll")<CR>
nnoremap <Leader>lt <Cmd>call VSCodeNotify('workbench.action.terminal.toggleTerminal')<CR><Cmd> call VSCodeNotify('workbench.action.terminal.sendSequence', {"text": "npm run test\u000D"} )<CR>

nnoremap <Leader>lf <Cmd>call VSCodeNotify("eslint.executeAutofix")<CR>

"  nnoremap <Leader>ls <Cmd>call VSCodeExtensionNotify('open-file', '/Users/Sami/workspace/test.txt' )<CR>
"  nnoremap <Leader>lt <Cmd>call VSCodeExtensionNotify("open-file", "/Users/Sami/workspace/test.txt" )<CR>

"  nnoremap <Leader>ls <Cmd>call FuzzyFind() <CR>