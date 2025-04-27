
PARENT_DIR="$(dirname "$0")"
pushd $PARENT_DIR 
echo "Current directory: $(pwd)"
git submodule init
git submodule update
stow */ --target ~
popd