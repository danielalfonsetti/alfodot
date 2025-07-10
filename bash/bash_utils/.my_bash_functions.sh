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

cleanbash() {
    env -i HOME="$HOME" USER="$USER" SHELL="$SHELL" TERM="$TERM" PATH="$PATH" $SHELL
}


list_tmux_session_processes() {
    SESSION_NAME=$1
    tmux list-panes -t "$SESSION_NAME" -F "#{pane_pid}" | xargs -I{} ps --ppid {} | grep -v 'bash'
}



run_command_in_tmux_session() {
    if [ "$#" -lt 2 ]; then
        echo "Usage: run_command_in_tmux_session <SESSION_NAME> <COMMAND>"
        return 1
    fi

    SESSION_NAME=$1
    COMMAND=$2

    # Check if the tmux session exists
    if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
        # Check if there are any processes running in the tmux session

        procs=$(list_tmux_session_processes "$SESSION_NAME")
        echo "$procs"
        if [ $(echo "$procs" | wc -l) -lt 2 ]; then
            # No processes running, run the command
            tmux send-keys -t "$SESSION_NAME" "$COMMAND" C-m
        fi
    else
        # Create a new tmux session and run the command
        tmux new-session -d -s "$SESSION_NAME" "$COMMAND"
        # tmux send-keys -t "$SESSION_NAME" "$COMMAND" C-m
    fi
    tmux attach-session -t "$SESSION_NAME"
    # Attach to the existing session
}