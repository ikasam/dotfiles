# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

[[ -s "/home/ikasamak/.gvm/scripts/gvm" ]] && source "/home/ikasamak/.gvm/scripts/gvm"

alias mxit 'pkill -SIGUSR1 mosh-server'

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
