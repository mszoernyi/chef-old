# sane default output for bwm-ng
alias bwm-ng="bwm-ng -u bits -d 1 -T avg"

# ssh helper
alias sshlive='ssh -l root -o "StrictHostKeyChecking no" -o "UserKnownHostsFile /dev/null" -o "GlobalKnownHostsFile /dev/null"'

# easy port listing
alias ports="netstat -tulpen"

# show interrupt numbers
irqs() {
	tail -n +2 /proc/interrupts | awk '{ print $1 $NF }'
}

# pydf has nicer output
if hash pydf &>/dev/null; then
	alias df=pydf
fi

# diff helper
cdu() {
	colordiff -u "$@" | less
}

sl() {
	sort -u | less -S
}

# tmux helper
T() {
	tmux attach -t ${1:-default} || tmux new -s ${1:-default}
}

# simple webserver
serve() {
	python -m SimpleHTTPServer ${1:-8080}
}
