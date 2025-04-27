#!/bin/sh

echo "Saving VSCode extensions..."
script_path=$(dirname $(dirname "$0"))
echo "Script is running from: $script_path"
code --list-extensions > "${script_path}/code_extension"