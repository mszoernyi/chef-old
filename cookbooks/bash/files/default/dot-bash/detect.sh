# detect system and sanitize env
case $(uname -s) in
	(Darwin)
		_SYSNAME="darwin"
		_FQDN=$(hostname)
		_NODENAME=${_FQDN%%.*}
		_DOMAINNAME=${_FQDN#*.}
		;;

	(Linux)
		_SYSNAME="linux"
		_FQDN=$(hostname --fqdn)
		_NODENAME=${_FQDN%%.*}
		_DOMAINNAME=${_FQDN#*.}
		;;

	(SunOS)
		_SYSNAME="solaris"
		_FQDN="$(hostname).$(domainname)"
		_NODENAME=${_FQDN%%.*}
		_DOMAINNAME=${_FQDN#*.}
		;;

	(*)
		echo "error: unable to get system name"
		;;
esac

# get distribution specific data
_DISTNAME="unknown"

if [[ -f /etc/gentoo-release ]]; then
	_DISTNAME="gentoo"
elif [[ -f /etc/debian_version ]]; then
	_DISTNAME="debian"
elif [[ -d /Applications ]]; then
	_DISTNAME="macos"

	if [[ -z ${EPREFIX} && -d ${HOME}/Gentoo ]]; then
		export EPREFIX=${HOME}/Gentoo
	fi
fi

if [[ $- != *i* ]]; then
	_INTERACTIVE=false
else
	_INTERACTIVE=true
fi

interactive() {
	[[ "${_INTERACTIVE}" == "true" ]]
}
