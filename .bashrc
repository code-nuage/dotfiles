# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='\[\033[0;100m\] \w \[\033[0m\]\n > '

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# luaenv
export PATH="$HOME/.luaenv/versions/5.1.5/:$HOME/.luaenv/bin:$PATH"
eval "$(luaenv init -)"

export PATH="$HOME/.local/bin:$PATH"
