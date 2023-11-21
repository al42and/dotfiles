# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# Set lang
LANG=en_US.UTF8

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Disable XON/XOFF control (a.k.a. Ctrl-S and Ctrl-Q)
stty -ixon

# Ignore and erase duplicates, ignor ecommands starting with space
HISTCONTROL=ignoredups:ignorespace:erasedups

# append to the history file, don't overwrite it; also, store multiline commands as singleline
shopt -s histappend
shopt -s cmdhist

# Save and reload the history on command
hsync(){
    builtin history -a
    builtin history -n
}

# Sensible history size
HISTSIZE=128000
HISTFILESIZE=1280000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
# shopt -s globstar

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

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias pgrepl='pgrep -l'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alFh'
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

# Start ssh-agent on logon
SSH_AGENT_FLAG="${HOME}/.ssh/agent.$(hostname).env"
if [ -f "${SSH_AGENT_FLAG}" ]; then
    . "${SSH_AGENT_FLAG}" > /dev/null
    if [ ! -S "${SSH_AUTH_SOCK}" ]; then
        echo "Stale agent file found. Spawning new agent…"
        eval $(ssh-agent | tee "${SSH_AGENT_FLAG}")
        ssh-add
    fi 
else
    if [ -z "$container" ]; then  # Don't even bother inside a containerized environment
        echo "Starting ssh-agent"
        eval $(ssh-agent | tee "${SSH_AGENT_FLAG}")
        ssh-add
    fi
fi

# Update default editor
if [ "$(command -v vim)" ]; then 
    export EDITOR=vim
fi

# Conda
alias conda2="source $HOME/anaconda2/bin/activate"
alias conda3="source $HOME/anaconda3/bin/activate"

# Autoexpand !!, !* and !$
bind Space:magic-space

# Enable fzf
if "$HOME/local/bin/fzf" --version &>/dev/null; then
    FZF_CTRL_R_OPTS="--border sharp --no-mouse --exact"
    [[ $- == *i* ]] && source "$HOME/.fzf/completion.bash" 2> /dev/null
    source "$HOME/.fzf/key-bindings.bash"
    source "$HOME/.fzf/history-exec.bash"
fi


# Set up $PATH &c
export CUDA_HOME=/usr/local/cuda

export PATH=$HOME/local/bin:$CUDA_HOME/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=$HOME/local/lib64:$HOME/local/lib:$CUDA_HOME/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
export PKG_CONFIG_PATH=$HOME/local/lib/pkgconfig:$HOME/local/share/pkgconfig${PKG_CONFIG_PATH:+:${PKG_CONFIG_PATH}}

if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

