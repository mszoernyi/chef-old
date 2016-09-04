# set proper unicode locale with fast C sorting
eval unset ${!LC_*} LANG
export LANG="en_US.UTF-8"
export LC_COLLATE="C"

# pager options
if hash less; then
	export PAGER=less
	export MANPAGER=less
	export LESS="-R --ignore-case --long-prompt"
fi

# keep size of history small ...
export HISTCONTROL="ignoreboth:erasedups"

# ... but keep a lot of history
export HISTFILESIZE=5000
export HISTSIZE=5000

# save timestamp in history
export HISTTIMEFORMAT="%Y-%m-%d [%T] "

# check window size after each command
shopt -s checkwinsize

# save multi-line command as one line
shopt -s cmdhist

# append history
shopt -s histappend

# enable recursive globbing
shopt -s globstar

# PgUp PgDn Hack
bind '"\e[5~": history-search-backward'
bind '"\e[6~": history-search-forward'

# stty - turn off that @!#$&!@# ctrl-s/q shell-freeze-stuff
stty -ixon -ixoff

# Ctrl-Q does a Ctrl-W w/ slashes
bind -r "\C-q"
bind '"\C-q": unix-filename-rubout'

# ls helpers
alias l="ls -lh"
alias ll="ls -lh"
alias la="ls -la"
alias lt="ls -lrt"

# cd helpers
# dirty hack since you cannot define a function called '..'
dotdot() {
	local cdpath=""
	local num=${1:-1}

	while [[ ${num} -gt 0 ]]; do
		cdpath="${cdpath}../"
		num=$((num - 1))
	done

	cdpath="${cdpath}${2}"
	cd ${cdpath}
}

alias ..="dotdot 1"
alias ...="dotdot 2"
alias ....="dotdot 3"

# mkdir + chdir
mkcd() {
	mkdir -p "$1" && cd "$1"
}

# make default what should be default
alias sudo="sudo -H"
alias root="sudo -i"

