ppath() {
    # n.b. tr stands for 'TRanslate'
    tr ':' '\n' <<< "$PATH"
}

clip() {
    if command -v xclip >/dev/null 2>&1; then
        xclip -selection clipboard
    else
        echo "Error: xclip is not installed." >&2
        return 1
    fi
}

rebash() {
    source ~/.bashrc
}