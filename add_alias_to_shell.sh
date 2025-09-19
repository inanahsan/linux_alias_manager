ALIAS_MANAGER_DIR="$HOME/alias_manager"
if [[ -f "$ALIAS_MANAGER_DIR/aliases" ]]
then
    while IFS= read -r line
    do
        read alias_input command_input <<< "$line"
        if [[ -n "$alias_input" ]]
        then
            if grep -q '$1' <<< "$command_input"
            then
                eval "$alias_input(){ $command_input }"
            else
                eval "alias $alias_input='$command_input'"
            fi
        fi
    done < "$ALIAS_MANAGER_DIR/aliases"
fi