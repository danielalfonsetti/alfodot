ppath() {
    # n.b. tr stands for 'TRanslate'
    tr ':' '\n' <<< "$PATH"
}