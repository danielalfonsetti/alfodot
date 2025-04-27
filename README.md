My dotfiles. 


# Quick Start
- You can install stow on WSL Ubuntu with `sudo apt install stow`.
- On Fedora, you can install stow with `sudo dnf install stow`.
- If you want all packages to be top level 'installed' in ~, then you can simple go to the root of this repo that you cloned and then run
- git submodule init
- git submodule update
- 
``stow */ --target ~` or even better ```stow --restow */ --target ~`
- Note that its safer to use `*/` rather than dot because we don't want to  also install top level files in this repo into the target.
- There are also some directories that we don't want stowed. So put those in `.stow-local-ignore`.
- Note that the nvim stow package is a submodule to my own fork of the nvchad nvim distribution.
- This dotfiles repo is our "stow" of our dotfiles. The term stow is a little misleading when yo go to use it, however, because we are actually basically 'installing' our stowed packages when we run something like `stow --stow nvim --target ~` on a new computer. It's also confusing because the `--target` in the stow command is the directory where the symlink will be made, is it _not_ referring to the target of the symlink (the target of the symlink is the file in this repo).

- `stow --stow <PACKAGE_NAME> --target <DIRETORY_ON_THE_COMPUTER_WHERE_YOU_WANT_THE_SYMLINK_PATH_TO_BE_MADE>
- <THIS_REPO_ROOT>/<PACAKGE_NAME>/<RELATIVE_PATH_TO_THE_SYMLINK_OF_WHATEVER_TARGET_DIRETORY_IS_SPECIFIED_IN_THE_STOW_COMMAND>

- Note that if your package contains subdirectories, then when you install to a target, a symlink will be created to those directories (rather than the directories being created in the target)

# Submodules

# References
- https://venthur.de/2021-12-19-managing-dotfiles-with-stow.html

#  Restowing (e.g. deleting dead symlinks etc.)
To refresh symlinks (e.g. in the case you deleted a file in this repo and the symlink stow previously created is now dead), you can run

```{bash}
stow --restow bash --target ~
```

# Example of deploying nvim config  on a new computer
dotfiles/nvim/.config/nvim	

```{bash}
cd dotfiles
stow --stow nvim --target ~ 
```

'nvim' is the 'package' in our dotfiles repository. It is a folder in this directory. Everything under this will have a symlink made.
The target is the directory where the symlinks will be made. If not specified, it defaults to the home directory.


# Example of stowing bash config
```{bash}   
<repo_root>/bash/.bashrc
cd dotfiles_git_repo_name
stow --stow bash --target ~
```

# Stowing wezterm config if cloning this repo in wsl and you are using wezterm on the windows host.
stow --stow wezterm --target /mnt/c/Users/daniel 

The windows folder is windows specific configs. It should be ignored by gnu stow / when using this repo on a linux box/wsl. Maybe we can use `https://github.com/ralish/PSDotFiles` instead. 

stow . --target ~

# VScode 
Wait, is this needed? Can't we use vscode sync? Do we actually need to stow?

Symlinks to the windows filesystem from wsl doesn't work right, so stowing the vscode settings from the /mnt/c into this dotfiles repo that is installed on wsl doesn't work right.
stow --stow vscode --target /mnt/c/Users/daniel/AppData/Roaming/Code/User/keybindings.json  
stow --stow vscode --target /mnt/c/Users/daniel/AppData/Roaming/Code/User/settings.json  
stow --stow vscode --target /mnt/c/Users/daniel/AppData/Roaming/Code/User/snippets  
stow --stow vscode --target /mnt/c/Users/daniel/AppData/Roaming/Code/User/ --ignore History --ignore globalStorage --ignore sync --ignore workspaceStorage


/mnt/c/Users/daniel/AppData/Roaming/Code/User/

/C:/Users/daniel/AppData/Roaming/Code/User/keybindings.json
/C:/Users/daniel/AppData/Roaming/Code/User/settings.json


References
- https://anhari.dev/blog/saving-vscode-settings-in-your-dotfiles


# Bonus: Boostrapping stow config from an existing file
If you want to stow something you already have and move it into our dotfiles repo here, you can use --adopt.
This will first move the file into this repo _AND_ then make the symlink file in the target directory.
Note that you have to create a dummy file in this repo first so stow knows what to adopt.

-- `stow -nv conda --adopt --target ~`

# Testing a command before running
-v verbose
-n: do _n_ot actually run the command
```{bash}
stow -nv
```

# Note on .stow-local-ignore
- File patterns in here will be ignored when you install (symlinks wont be created)
