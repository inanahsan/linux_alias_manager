echo "to add alias use command 'add alias_string command_to_execute'"
echo "to remove alias use command 'rm alias_string'"
echo "to list alias use command 'list'"
echo "to close alias manager use command 'shoo'"
ALIAS_MANAGER_DIR="$HOME/alias_manager"
while true
do
    read type alias command
    if [[ -z "$type" ]]
    then
        echo "task type is mandatory"
    elif [[ "$type" != "add" && "$type" != "rm" && "$type" != "list" && "$type" != "shoo" ]]
    then
        echo "Invalid task type"
    elif [[ "$type" == "add" && ( ( -z "$alias") || ( -z "$command" ) ) ]]
    then
        echo "alias and command are both necessary for add command"
    elif [[ "$type" == "rm" && ( -z "$alias" ) ]]
    then
        echo "alias is necessary for rm command"
    elif [[ ( ( "$type" == "list" || "$type" == "shoo" ) && ( -n "$alias" ) ) || ( "$type" == "rm" ) && ( -n "$command" ) ]]
    then
        echo "too many arguments for command $type"
    elif [[ ( "$type" == "add" || "$type" == "rm" ) && ( "$alias" == *[[:space:]]* || "$alias" == *[!a-zA-Z0-9_] ) ]]
    then
        echo "alias must be alpha numeric"
    elif [[ ( "$type" == "add" || "$type" == "rm" ) && ( "$alias" == [0-9]* ) ]]
    then
        echo "alias cannot start with a number"
    elif [[ "$type" == "add" ]]
    then
        flag=0
        if [[ -f "$ALIAS_MANAGER_DIR/aliases" ]]
        then
            while IFS= read -r line
            do
                read alias_input command_input <<< "$line"
                if [[ $alias_input == $alias ]]
                then
                    flag=1
                    break
                fi
            done < "$ALIAS_MANAGER_DIR/aliases"
        fi
        if [[ $flag == 0 ]]
        then
            eval "alias $alias='$command'"
            echo "$alias $command">>"$ALIAS_MANAGER_DIR/aliases"
        else
            echo "alias already exists"
        fi
    elif [[ $type == "rm" ]]
    then
        mv "$ALIAS_MANAGER_DIR/aliases" "$ALIAS_MANAGER_DIR/backup_aliases"
        flag=0
        while IFS= read -r line
        do
            read alias_input command_input <<< "$line"
            if [[ $alias_input != $alias ]]
            then
                echo "$alias_input $command_input">>"$ALIAS_MANAGER_DIR/aliases"
            else
                flag=1
                unalias $alias
            fi
        done < "$ALIAS_MANAGER_DIR/backup_aliases"
        rm "$ALIAS_MANAGER_DIR/backup_aliases"
        if [[ $flag == 0 ]]
        then
            echo "alias not found"
        fi
    elif [[ $type == "list" ]]
    then
        if [[ -f "$ALIAS_MANAGER_DIR/aliases" ]]
        then
            less "$ALIAS_MANAGER_DIR/aliases"
        else
            echo "no aliases found"
        fi
    elif [[ $type == "shoo" ]]
    then
        break
    else
        echo "something went wrong"
    fi
done
