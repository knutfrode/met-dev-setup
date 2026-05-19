echo "Running KFD additional bashrc commands"

alias ..='cd ..'
alias 'l=ls -lrth --hide="*.pyc"'
alias python=python3
alias pip=pip3

export MAMBA_ROOT_PREFIX=$HOME/.mconda3

mamba activate opendrift
