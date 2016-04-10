#!/bin/bash

repository_name="${1}"
repository_path="${3}"

[[ ${repository_name} == "<%= node[:portage][:repo] %>" ]] || exit 0

source /lib/gentoo/functions.sh

GLSADIR="${repository_path}"/metadata/glsa
ebegin "Updating GLSAs"
if [[ -e ${GLSADIR} ]]; then
	git -C "${GLSADIR}" pull -q --ff-only
else
	git clone -q https://anongit.gentoo.org/git/data/glsa.git "${GLSADIR}"
fi
eend "$?"
