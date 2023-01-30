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



function IsExtension(extension) 
    let s:current_extension=expand('%:e')
    if match(s:current_extension, a:extension) == -1
        return 0
    else
        return 1
    endif
endfunction


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
"  function IsExtension(extension) 
"      let s:current_extension=expand('%:e')
"      if match(s:current_extension, a:extension) == -1
"          return "false"
"      else
"          return "true"
"      endif
"  endfunction

"  let s:fileAName =  "echo fileA:\u000D"
"  let s:fileA = a:1
"  let s:fileBName =  "fileB:\u000D"
"  let s:fileB = expand(s:fileA)
"  let file = a:1
"  function ToggleBark ()
"      call VSCodeNotify('workbench.action.terminal.toggleTerminal') 
"      let isJavascript = "echo " .. IsExtension('js') .. "\u000D"
"      "  let file = exists('a:2') ? a:2 : ''
"      "  let current_file = @%
"      "  let current_file=expand('%:e')
"      "  call VSCodeNotify('workbench.action.terminal.sendSequence', {"text": expand(a:1)} )
"      "  call VSCodeNotify('workbench.action.terminal.sendSequence', {"text": expand('<abuf>') .. "\u000D"} )
"      "  call VSCodeNotify('workbench.action.terminal.sendSequence', {"text": fnamemodify(resolve(expand('<sfile>:p')), ':h')} )
"      "  call VSCodeNotify('workbench.action.terminal.sendSequence', {"text": fnamemodify(resolve(expand('<abuf>')), ':p')} )
"      call VSCodeNotify('workbench.action.terminal.sendSequence', {"text": isJavascript} )
"      call VSCodeNotify('workbench.action.terminal.sendSequence', {"text": g:current_extension} )
"      "  call VSCodeNotify('workbench.action.terminal.sendSequence', {"text": s:fileAName} )
"      call VSCodeNotify('workbench.action.focusActiveEditorGroup') 
"  endfunction

"  nnoremap <Leader>lb <Cmd>:call ToggleBark()<CR>