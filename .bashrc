# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Activate autocompletion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Source every shell configuration script
for f in ~/.bash/*.sh; do
  source "$f"
done
