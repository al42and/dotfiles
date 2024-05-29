alias ds='du -ahxd1 | sort -h'
alias gd='git diff'
alias gl='git log'
alias gpom='git pull origin master'
alias gdc='git diff --cached'
alias gs='git status .'
alias cfi='clang-format-11 -i'

alias fd=fdfind

# I've got too non-linear hands...
alias cim='vim'
alias vi,='vim'
alias vum='vim'
alias vin='vim'
alias vun='vim'  # Okay, at this stage it miiiight be a better idea to take a break
alias gut='git'

if which rsync &> /dev/null; then
    alias scp="rsync -ahxAX --inplace --info=progress2"
fi

function ressh() {
    args_all_but_last="${@:1:$#-1}"
    arg_last="${@:${#@}}"
    if [ $arg_last == ls ]; then
      ssh ${args_all_but_last} tmux list-sessions
    else
      ssh ${args_all_but_last} -t tmux new-session -A -s "${arg_last}"
    fi
}

function m() {
    targets=""
    jproc="-j$(nproc)"
    for arg in $@; do
        case "$arg" in
            -j*) jproc="$arg";;
            *) targets="${targets} --target ${arg}";;
        esac
    done
    ionice -c 3 nice cmake --build . ${targets} -- "${jproc}"
}
