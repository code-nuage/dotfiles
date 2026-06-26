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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH=$PATH:~/.local/bin
