# ~/.bash_profile: executed by bash(1) for login shells.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/login.defs
#umask 022

# include .bashrc if it exists
[[ -f ~/.bashrc ]] && . ~/.bashrc

# set PATH so it includes user's private bins if them exists
#dont use ~, otherwise /usr/bin/env (execve) won't find them
[[ -d ~/Scripts ]] && PATH+=":$HOME/Scripts"
[[ -d ~/.local/bin ]] && PATH+=":$HOME/.local/bin"

if which ruby >/dev/null && which gem >/dev/null; then
        PATH+=":$(ruby -rubygems -e 'puts Gem.user_dir')/bin"
fi

export PATH
export MANPATH=$HOME/.local/share/man:$(manpath -gq)

#Launch tmux if installed
hash tmux &> /dev/null && tmux -u2
