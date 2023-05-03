#!/usr/bin/env bash

# TODO: handle https://www.geeksforgeeks.org/how-to-get-the-duration-of-audio-in-python/
#
 # selected=`cat ~/.config/tmux/.tmux-cht-languages ~/.config/tmux/.tmux-cht-command | fzf`

 # read -p "Enter Query: " query

 # if grep -qs "$selected" ~/.config/tmux/.tmux-cht-languages; then
 #     query=`echo $query | tr ' ' '+'`
 #     tmux neww bash -c "curl cht.sh/$selected/$query & while [ : ]; do sleep 1; done"
 # else
 #     tmux neww bash -c "curl cht.sh/$selected~$query & while [ : ]; do sleep 1; done"
 # fi

 # Prerequisites:
 # - fuzzy finder: either fzf or sk

 fuzzy_finder=fzf  # use either fzf or sk

 # Pressing <esc> exits terminal mode and moves cursor to the middle of the screen
 # Pressing q quits nvim inside normal and terminal mode
 nvim_options="\
     -c \"nnoremap q :q!<CR>\" \
     -c \"tnoremap <esc> :<C-\\><C-n>M\" \
     -c \"tnoremap q :<C-\\><C-n>:q!<CR>\" \
     -c \"bufdo setfiletype markdown\" \
     -c \"autocmd BufEnter :setfiletype markdown\" \
     "

 less_options="-R"
 mkdir -p "$HOME"/.config/tmux/.cache "$HOME"/.config/tmux/.cache/menus_html "$HOME"/.config/tmux/.cache/menus "$HOME"/.config/tmux/.cache/pages_html "$HOME"/.config/tmux/.cache/pages

 selected=$(cat \
     "$HOME"/.config/tmux/.map \
     |awk -F ' ' '{print $1}'\
     | $fuzzy_finder)

 remote_path=$(cat \
      "$HOME"/.config/tmux/.map \
      |grep -w "^$selected" \
      |awk -F ' ' '{print $2}'
    )

 local_path=$(echo "$remote_path" | tr '/' '_')

 if [[ -z "$selected" ]]; then
     exit 0
 fi

 if ! [[ -f "$HOME/.config/tmux/.cache/menus_html/$remote_path" ]]; then
     curl -s "https://www.w3schools.com/$remote_path/" > "$HOME/.config/tmux/.cache/menus_html/$local_path"  
 fi

 if ! [[ -f "$HOME/.config/tmux/.cache/menus/$local_path" ]]; then
    cat "$HOME/.config/tmux/.cache/menus_html/$local_path"  \
    |xsltproc --html w3school-menu.xsl - 2>/dev/null \
    > "$HOME/.config/tmux/.cache/menus/$local_path" 
 fi

# selected=$(cat "$HOME/.config/tmux/.cache/parsed/$path"  \
#     # |awk -F ';' '{$NF="";sub(/[ \t]+$/,"")}1'\
#     |$fuzzy_finder \
#     # |awk -F ';' '{print $NF}'
# )
echo "$local_path"
end_path=$(cat "$HOME/.config/tmux/.cache/menus/$local_path"  \
    |$fuzzy_finder \
    |awk -F ';' '{print $NF}'
)
 if [[ -z "$end_path" ]]; then
     exit 0
 fi
url="https://www.w3schools.com/$remote_path/$end_path"
end_no_ext=$(echo "$end_path" |awk -F '.' '{print $1}')

# if ! [[ -f "$HOME/.config/tmux/.cache/pages/$end_no_ext.md" ]]; then
     curl -s "$url"\
       > "$HOME/.config/tmux/.cache/pages_html/$end_path" \
    && cat "$HOME/.config/tmux/.cache/pages_html/$end_path" \
    |xsltproc --html w3school-content.xsl - 2>/dev/null \
    > "$HOME/.config/tmux/.cache/pages/$end_no_ext.md" 
# fi


 # read -p "Enter Query: " query
 #
 # if grep -qs "$selected" ~/.config/tmux/.tmux-cht-languages; then
 #     query=$(echo "$query" | tr ' ' '+')
 #     url="cht.sh/$selected/$query"
 # else
 #     url="cht.sh/$selected~$query"
 # fi

 tmux neww -n "$path" bash -c "nvim $nvim_options \
     -- $HOME/.config/tmux/.cache/pages/$end_no_ext.md"
 # tmux neww -n "$path" bash -c "nvim $nvim_options \
 #     +'ter cat $HOME/.config/tmux/.cache/pages/$end_no_ext.md  | less $less_options'"  # +'call feedkeys(\"i\")'"
