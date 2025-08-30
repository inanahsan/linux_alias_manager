if [ -n "$ZSH_VERSION" ]
then
    file_path="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]
then
    file_path="$HOME/.bashrc"
else
    echo "Unsupported shell. Please run in bash or zsh"
fi
if [ -n "$file_path" ]
then
    ALIAS_MANAGER_DIR="$HOME/alias_manager"
    if [[ ! -f "$ALIAS_MANAGER_DIR/add_alias_to_shell.sh" ]]
    then
        mkdir -p "$ALIAS_MANAGER_DIR"
        cp ./add_alias_to_shell.sh "$ALIAS_MANAGER_DIR/add_alias_to_shell.sh"
    fi
    flag=0
    while IFS= read -r line
    do
        if [[ "$line" == *alias_manager* ]]
        then
            flag=1
        fi
    done < "$file_path"
    if [[ $flag == 0 ]]
    then
        echo "source \"$ALIAS_MANAGER_DIR/add_alias_to_shell.sh\"">>"$file_path"
    else
        echo "alias manager already installed. please source alias manager to get started"
    fi
fi