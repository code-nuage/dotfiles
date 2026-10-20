# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='\u@\h \W > '

if [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
fi

for f in ~/.bash/*.sh; do
  source "$f"
done

# opencode
export PATH=/home/eloi/.opencode/bin:$PATH
