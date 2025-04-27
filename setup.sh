#!/bin/bash

stow_overwrite_replace() {
    # adopted from
    # https://unix.stackexchange.com/questions/680413/opposite-of-adopt-option-for-gnu-stow
    echo "Will replace with last committed  version. Stashing current working directory."
    git stash
    stow --adopt */ --target ~
    changes=$(git status --porcelain | grep '^ M' | awk '{print $2}')
    for file in $changes; do
        read -p "Do you want to restore $file to the last committed version? (y/n): " restore_choice
        if [[ "$restore_choice" == "y" || "$restore_choice" == "Y" ]]; then
            git checkout -- "$file"
        fi
    done
    git reset --hard 
    stow */ --target ~
    git stash pop
}


PARENT_DIR="$(dirname "${BASH_SOURCE[0]}")"
pushd $PARENT_DIR 
echo "Current directory: $(pwd)"
git submodule init
git submodule update
read -p "Do you want stow to overwrite your existing files? (y/n): " choice
# TODO: Could make this on a per file basis.
if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    echo "Attempting to overwrite."
    stow_overwrite_replace
else
    stow */ --target ~
fi

popd