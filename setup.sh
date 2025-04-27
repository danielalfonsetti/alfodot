#!/bin/bash
cd "$(dirname "$0")" || exit
git submodule init
git submodule update
stow */ --target ~