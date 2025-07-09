echo "Sourcing ~/.bashrc"

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

# export DIRENV_LOG_FORMAT=""

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/daniel/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/daniel/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/daniel/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/daniel/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# # <<< conda initialize <<<

####################
# My setup
####################
source ~/bash_utils/.my_bash_functions.sh

# export PATH=$PATH:~/.my_bins/


#  conda activate alfonsetti_base
# conda activate venv_alfonsetti_misc


# https://github.com/redhat-developer/vscode-java/wiki/JDK-Requirements#java.configuration.runtimes
# https://www.jenkins.io/doc/developer/tutorial/prepare/
# sudo apt-get install openjdk-11-jdk
JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
PATH="$JAVA_HOME/bin:$PATH"
# java --version

# Maven https://phoenixnap.com/kb/install-maven-on-ubuntu
# sudo apt install maven
# apt is the ubuntu installer.
# sudo apt-get purge maven


# wget https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.8.1/apache-maven-3.8.1-bin.tar.gz
# sudo mv apache-maven-3.8.1-bin.tar.gz /usr/share/
# tar -xvf apache-maven-3.8.1-bin.tar.gz
# mvn --version

MAVEN_DIR='/usr/share/apache-maven-3.8.1'
PATH="$MAVEN_DIR/bin:$PATH"


# conda init bash

# eval "$(conda shell.bash hook)"

# use_conda() {
#   echo "Hello world"
#   . /home/daniel/miniconda3/condabin/conda
#   conda activate "$1"
# }
# . "$HOME/.cargo/env"

# >>> >>>
# !! Contents within this block are managed by 'micromamba shell init' !!
export MAMBA_EXE='/home/alfonsetti/.local/bin/micromamba';
export MAMBA_ROOT_PREFIX='/home/alfonsetti/micromamba';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from micromamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<


if ! echo "$PATH" | grep -q ~/my_bins; then
    export PATH=~/my_bins:$PATH
fi

alias cwd='pwd'

# by default' the vscode rust analyzer plugin looks in ~/.cargo/bin/ for rustc and cargo.
# we want to redirect to rust-analyzer to use our micromamba managed versions of these rather than a system install.
# References:
# - https://github.com/rust-lang/rust-analyzer/issues/3154
# - https://stackoverflow.com/questions/72352691/cannot-connect-to-rust-kernel-from-a-jupyter-server-in-a-conda-env/76000140#76000140
# which micromamba # https://mamba.readthedocs.io/en/latest/installation/micromamba-installation.html#automatic-install
# micromamba create -p venv_rustsrc_env rust-src
# micromamba activate venv_rustsrc_env # activate environment containing rustc and cargo so that we can link to them.
# mkdir -p ~/.cargo/bin
# ln -s -T $(which rustc) ~/.cargo/bin/rustc
# ln -s -T $(which cargo) ~/.cargo/bin/cargo
# micromamba deactivate 

# https://github.com/FiloSottile/mkcert?tab=readme-ov-file#installing-the-ca-on-other-systems
export CAROOT='/home/daniel/mkcert'

# https://stackoverflow.com/questions/49919063/installing-npm-node-on-bash-on-ubuntu-on-windows-wsl-what-architecture-does-u
export NVM_DIR="/home/daniel/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm (node version manager?)


######################################################################
# Settings for interactive use.
# Enable the subsequent settings only in interactive sessions
######################################################################
case $- in
  *i*) ;;
    *) return;;
esac

# Path to your oh-my-bash installation.
export OSH=~/.oh-my-bash
# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-bash is loaded.
# OSH_THEME="font"
# OSH_THEME="powerline-light"
# OSH_THEME='minimal-gh'
# OSH_THEME='/home/daniel/.oh-my-bash/custom/themes/alfonsetti/alfonsetti.theme.sh' # BAD
OSH_THEME='alfonsetti' # GOOD.
# https://github.com/ohmybash/oh-my-bash/blob/master/README.md
PROMPT_DIRTRIM=0 # https://github.com/ohmybash/oh-my-bash/discussions/540
# Uncomment the following line to use case-sensitive completion.
# OMB_CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# OMB_HYPHEN_SENSITIVE="false"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_OSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.  One of the following values can

# be used to specify the timestamp format.
# * 'mm/dd/yyyy'     # mm/dd/yyyy + time
# * 'dd.mm.yyyy'     # dd.mm.yyyy + time
# * 'yyyy-mm-dd'     # yyyy-mm-dd + time
# * '[mm/dd/yyyy]'   # [mm/dd/yyyy] + [time] with colors
# * '[dd.mm.yyyy]'   # [dd.mm.yyyy] + [time] with colors
# * '[yyyy-mm-dd]'   # [yyyy-mm-dd] + [time] with colors
# If not set, the default value is 'yyyy-mm-dd'.
# HIST_STAMPS='yyyy-mm-dd'

# Uncomment the following line if you do not want OMB to overwrite the existing
# aliases by the default OMB aliases defined in lib/*.sh
# OMB_DEFAULT_ALIASES="check"

# Would you like to use another custom folder than $OSH/custom?
# OSH_CUSTOM=/path/to/new-custom-folder

# To disable the uses of "sudo" by oh-my-bash, please set "false" to
# this variable.  The default behavior for the empty value is "true".
OMB_USE_SUDO=true

# To enable/disable display of Python virtualenv and condaenv
# OMB_PROMPT_SHOW_PYTHON_VENV=true  # enable
# OMB_PROMPT_SHOW_PYTHON_VENV=false # disable

# Which completions would you like to load? (completions can be found in ~/.oh-my-bash/completions/*)
# Custom completions may be added to ~/.oh-my-bash/custom/completions/
# Example format: completions=(ssh git bundler gem pip pip3)
# Add wisely, as too many completions slow down shell startup.
completions=(
  git
  composer
  ssh
)

# Which aliases would you like to load? (aliases can be found in ~/.oh-my-bash/aliases/*)
# Custom aliases may be added to ~/.oh-my-bash/custom/aliases/
# Example format: aliases=(vagrant composer git-avh)
# Add wisely, as too many aliases slow down shell startup.
aliases=(
  general
)

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-bash/plugins/*)
# Custom plugins may be added to ~/.oh-my-bash/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  bashmarks
)

# Which plugins would you like to conditionally load? (plugins can be found in ~/.oh-my-bash/plugins/*)
# Custom plugins may be added to ~/.oh-my-bash/custom/plugins/
# Example format: 
#  if [ "$DISPLAY" ] || [ "$SSH" ]; then
#      plugins+=(tmux-autoattach)
#  fi

source "$OSH"/oh-my-bash.sh

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-bash libs,
# plugins, and themes. Aliases can be placed here, though oh-my-bash
# users are encouraged to define aliases within the OSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias bashconfig="mate ~/.bashrc"
# alias ohmybash="mate ~/.oh-my-bash"


# Everything above is from Oh my bash

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# if [ "$color_prompt" = yes ]; then
#     PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# else
#     PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
# fi
# unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi



lsenv() {
  echo "You can activate the environment with source <path to activate>"
  for env in ~/.virtualenvs/*; do
    if [ -d "$env/bin" ]; then
      echo "source $env/bin/activate"
    fi
  done
}
alias lsenvs='lsenv'
alias lsvenvs='lsenv'
alias lsvenv='lsenv'
######################################################################
# End of settings for interactive use.
######################################################################

# source ~/tools/z.sh

# eval "$(micromamba shell hook --shell bash)"
# eval "$(direnv hook bash)"

# # cd ~


# _direnv_hook() {
#   local previous_exit_status=$?;
#   trap -- '' SIGINT;
#   eval "$("/usr/bin/direnv" export bash)";
#   trap - SIGINT;
#   return $previous_exit_status;
# };
# if ! [[ "${PROMPT_COMMAND:-}" =~ _direnv_hook ]]; then
#   PROMPT_COMMAND="_direnv_hook${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
# fi

# https://stackoverflow.com/questions/56836530/auto-activate-conda-env-when-changing-directory
# .direnv doesn't work well for activating and deactivating the env, so I just use this instead.

# Override cd command
cd_graceful_not_dir() {
    if [ -d "$1" ]; then
        _omb_directories_cd "$1"
        # builtin cd "$1"
    elif [ -f "$1" ]; then
        _omb_directories_cd  "$(dirname "$1")"
        # builtin cd "$(dirname "$1")"
    else
        echo "bash: cd: $1: No such file or directory"
        return 1
    fi
}


# cd_graceful_not_dir() {
#     if ! builtin cd "$1" 2>/dev/null; then
#         if [ -f "$1" ]; then
#             builtin cd "$(dirname "$1")" || return 1
#         else
#             return 1
#         fi
#     fi
# }

cd_wrapper() { cd_graceful_not_dir "$@" && 
if [ -f $PWD/.conda_config ]; then
    export CONDACONFIGDIR=$PWD
    micromamba activate $(cat .conda_config)
elif [ "$CONDACONFIGDIR" ]; then
    if [[ $PWD != *"$CONDACONFIGDIR"* ]]; then
        export CONDACONFIGDIR=""
        micromamba deactivate
    fi
fi }
alias cd=cd_wrapper



export XLA_FLAGS=--xla_gpu_cuda_data_dir=/home/daniel/miniconda3/nvvm


memory_fix() {
    # https://github.com/microsoft/WSL/issues/4166#issuecomment-2488420716
    sync
    echo 3 | sudo tee /proc/sys/mamba initialize vm/drop_caches
    # https://devblogs.microsoft.com/commandline/memory-reclaim-in-the-windows-subsystem-for-linux-2/
    echo 1 | sudo tee /proc/sys/vm/compact_memory
}


# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"


# Add path containing the nvidia cuda comiler (nvcc)
export PATH=/usr/local/cuda/bin:$PATH

# the LD_LIBRARY_PATH environment variable is not specific to C++. 
# It is used by the dynamic linker on Linux systems to locate shared libraries (.so files)
# for any dynamically linked application, regardless of the programming language.
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH


DOLPHIN_SPAGHETTI_ROOT=/home/alfonsetti/code/github/dolphin_spaghetti
export PYTHONPATH=${PYTHONPATH}:${DOLPHIN_SPAGHETTI_ROOT}export PATH="/home/alfonsetti/.pixi/bin:$PATH"
