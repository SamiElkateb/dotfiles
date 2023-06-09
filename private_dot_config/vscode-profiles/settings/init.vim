function IsExtension(extension) 
    let s:current_extension=expand('%:e')
    if match(s:current_extension, a:extension) == -1
        return 0
    else
        return 1
    endif
endfunction

function UseCommand(commandName) 
    call VSCodeNotify('workbench.action.terminal.toggleTerminal')
    call VSCodeNotify('workbench.action.terminal.sendSequence', {"text": commandName .. "\u000D"} )
    let s:isFuzzyFinding=1
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
set ignorecase
set smartcase

" keymaps
nnoremap <Leader>c <Cmd>call VSCodeNotify("workbench.action.closeActiveEditor")<CR>
nnoremap <Leader>e <Cmd>call VSCodeNotify("workbench.action.toggleSidebarVisibility")<CR>

vnoremap < <gv
vnoremap > >gv

nnoremap <Leader>zen <Cmd>call VSCodeNotify("workbench.action.toggleZenMode")<CR>

xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine

nnoremap gr <Cmd>call VSCodeNotify("editor.action.goToReferences")<CR>
nnoremap gs <Cmd>call VSCodeNotify("workbench.action.gotoSymbol")<CR>
nnoremap gi <Cmd>call VSCodeNotify("editor.action.goToImplementation")<CR>

nnoremap gb <Cmd>call VSCodeNotify("workbench.action.navigateBack")<CR>
nnoremap gf <Cmd>call VSCodeNotify("workbench.action.navigateForward")<CR>

nnoremap <S-l> <Cmd>call VSCodeNotify("workbench.action.nextEditor")<CR>
nnoremap <S-h> <Cmd>call VSCodeNotify("workbench.action.previousEditor")<CR>

" LSP
nnoremap <Leader>la <Cmd>call VSCodeNotify("editor.action.quickFix")<CR>
nnoremap <Leader>lr <Cmd>call VSCodeNotify("editor.action.rename")<CR>
nnoremap <Leader>lj <Cmd>call VSCodeNotify("editor.action.marker.nextInFiles")<CR>
nnoremap <Leader>lk <Cmd>call VSCodeNotify("editor.action.marker.prevInFiles")<CR>

nnoremap <Leader>ls <Cmd>call VSCodeNotify("breadcrumbs.focusAndSelect")<CR>

nnoremap <Leader>st <Cmd>call VSCodeNotify("find-it-faster.findWithinFiles")<CR>
nnoremap <Leader>ss <Cmd>call VSCodeNotify("searchEverywhere.search")<CR>
"  nnoremap <Leader>ss <Cmd>call VSCodeNotify("workbench.action.showAllSymbols")<CR>

"  nnoremap("<C-d>", "<C-d>zz")
"  nnoremap("<C-u>", "<C-u>zz")

"  nnoremap <Leader>sf <Cmd>call FuzzyFind()<CR>
"  nnoremap <C-h> <Cmd>call FuzzyFindOpen() <CR>

nnoremap <Leader>lf <Cmd>call VSCodeNotify("editor.action.formatDocument")<CR>

function MiscPreviewFunction()
    if IsExtension('plantuml')
        call VSCodeNotify('plantuml.preview') 
    elseif IsExtension('tex')
        call VSCodeNotify('latex-workshop.view') 
    elseif IsExtension('md')
        call VSCodeNotify('markdown.showPreview') 
    endif
endfunction

"  function MiscBuildFunction()
"      if IsExtension('plantuml')
"          call VSCodeNotify('plantuml.preview') 
"      elseif IsExtension('tex')
"          call VSCodeNotify('latex-workshop.view') 
"      elseif IsExtension('md')
"          call VSCodeNotify('markdown.showPreview') 
"      endif
"  endfunction
nnoremap <Leader>lp <Cmd>:call MiscPreviewFunction()<CR>
"  nnoremap <Leader>lb <Cmd>:call MiscPreviewFunction()<CR>

" nnoremap <Leader>ls <Cmd>call VSCodeNotify("wolf.stopBarking")<CR>
" nnoremap <Leader>lt <Cmd>call VSCodeNotify("testing.runAll")<CR>
" nnoremap <Leader>ll <Cmd>call VSCodeNotify("python.runLinting")<CR>