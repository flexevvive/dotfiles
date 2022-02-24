export EDITOR='/bin/nvim'
export DENO_INSTALL="/home/evvive/.deno"
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/evvive/.local/bin/:/home/evvive/.deno/bin"
export PATH="$PATH:$DENO_INSTALL/bin"


alias ll='ls -l --color=auto --time-style=locale -p --width=80 --block-size=MB'
alias ls='ls --color=auto --time-style=locale -p --width=80 --format=comma'
alias grep='grep --color=auto'

alias vi='nvim'
alias code='cd $HOME/Code'

PS1="\[\033[33;1m\]\W\[\033[0m\]: "

clear
cat $HOME/winnie
