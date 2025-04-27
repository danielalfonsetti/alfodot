#!/bin/bash

stow_overwrite_replace() {
    # adopted from
    # https://unix.stackexchange.com/questions/680413/opposite-of-adopt-option-for-gnu-stow
    echo "Will overwrite (with confirmation) any conflicting files with the version of the files from the last commit in this dotfile repo if they are conflicts."
    git stash # stash so that we only overwrite files with versions from the last commit of this repo.
    stow --adopt */ --target ~ # find what files would change.
    detected_conflicts=$(git status --porcelain | grep '^ M' | awk '{print $2}')
    if [[ -z "$detected_conflicts" ]]; then
        echo "No conflicts detected."
    else
        for file in $detected_conflicts; do
            read -p "Do you want to restore $file to the last committed version? (y/n): " restore_choice
            if [[ "$restore_choice" == "y" || "$restore_choice" == "Y" ]]; then
                git checkout -- "$file"
            fi
        done
        git reset --hard 
        stow */ --target ~
    fi
    git stash pop
}


PARENT_DIR="$(dirname "${BASH_SOURCE[0]}")"
pushd $PARENT_DIR 
echo "Current directory: $(pwd)"
git submodule init
git submodule update
read -p "Do you want stow to try to overwrite your existing files? We will ask for confirmation for each individual conflict. (y/n): " choice
# TODO: Could make this on a per file basis.
if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    stow_overwrite_replace
else
    stow */ --target ~
fi

popd