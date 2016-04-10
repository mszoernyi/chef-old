#!/bin/bash

repository_name="${1}"
repository_path="${3}"

[[ ${repository_name} == "<%= node[:portage][:repo] %>" ]] || exit 0

source /lib/gentoo/functions.sh

DTDDIR="${repository_path}"/metadata/dtd
ebegin "Updating DTDs"
if [[ -e ${DTDDIR} ]]; then
	git -C "${DTDDIR}" pull -q --ff-only
else
	git clone -q https://anongit.gentoo.org/git/data/dtd.git "${DTDDIR}"
fi
eend "$?"
