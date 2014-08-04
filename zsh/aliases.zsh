alias reload!='. ~/.zshrc'

# ls aliases
alias ls='ls -F'
alias ll='ls -lh'
alias la='ls -A'
alias lal='ls -lhA'

# enable color support of ls and redefine aliases if able
if [[ -x /usr/bin/dircolors ]]; then
    alias ls='ls -F --color=auto'
    # alias ll='ls -lh'
    # alias la='ls -A'
    # alias lal='ls -lhA'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias ack='ack-grep'
alias c=clear
alias ud='cd ~/.dotfiles && git pull'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias 'ssh-gp'='ssh -L 8009:localhost:8009 gp -t "ssh -L 8009:localhost:8009 nari.housing.wwu.edu -t tmux attach -d"'
alias 'ssh-alvis'='ssh alvis -t tmux attach -d'
alias 'ssh-nari'='ssh -L 8009:localhost:8009 nari.housing.wwu.edu -t tmux attach -d'
alias 'ssh-irc'='ssh nari -t startirc'

alias 'git-clch'='(cd ./$(git rev-parse --show-cdup) && git checkout -- $(git status --porcelain | sed s/^...//))'
alias 'nodebin'='export PATH=$PATH:$(npm bin)'