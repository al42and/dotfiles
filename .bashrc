# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# Set lang
LANG=en_US.UTF8

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

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

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

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

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'

    alias pgrepl='pgrep -l'
fi

alias myctags='ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --langmap=c:+.cu --langmap=c:+.cuh --exclude=".pc"'
alias svngrep='grep -IR --exclude-dir="*/CMakeFiles/*" --exclude-dir="*/.svn/*" --exclude="*.*~"'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias du1='du --max-depth=1'

# Start ssh-agent on logon
if [ -f ~/.agent.env ] ; then
    . ~/.agent.env > /dev/null
if ! kill -0 $SSH_AGENT_PID > /dev/null 2>&1; then
    echo "Stale agent file found. Spawning new agent… "
    eval `ssh-agent | tee ~/.agent.env`
    ssh-add
fi 
else
    echo "Starting ssh-agent"
    eval `ssh-agent | tee ~/.agent.env`
    ssh-add
fi

# Update default editor
if which vim &>/dev/null; then 
    export EDITOR=vim
fi
# I've got too non-linear hands...
alias cim='vim'
alias vum='vim'

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
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Autoexpand !!, !* and !$
bind Space:magic-space

# Enable undistract-me
if which notify-send &>/dev/null; then
    UNDISTRACTDIR="$HOME/local/undistract-me"
    LONG_RUNNING_PREEXEC_LOCATION="$UNDISTRACTDIR/preexec.bash"
    if [ -f "$LONG_RUNNING_PREEXEC_LOCATION" ]; then
        source "$UNDISTRACTDIR/long-running.bash"
        notify_when_long_running_commands_finish_install
    fi
fi

# Set up $PATH &c
export CUDA_HOME=/usr/local/cuda

export PATH=$HOME/local/bin:$PATH:$CUDA_HOME/bin
export LD_LIBRARY_PATH=$HOME/local/lib64:$HOME/local/lib:$CUDA_HOME/lib64:$LD_LIBRARY_PATH
export PYTHONPATH=$HOME/local/lib/python2.7/site-packages/

