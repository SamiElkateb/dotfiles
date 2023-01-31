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