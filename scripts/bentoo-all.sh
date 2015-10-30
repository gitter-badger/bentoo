#!/bin/sh

ROOT="$(portageq envvar ROOT)"
REPO_ROOT="$(portageq get_repo_path ${ROOT} bentoo)"

BROKEN="${REPO_ROOT}/sets/bentoo-broken"

for ebuild in $(find "${REPO_ROOT}" -name "*-9999.ebuild" | sed -r "s|^.*/([[:alnum:]_\.\-]+)/[^\/]+/([[:alnum:]_\.\-]+)-9999\.ebuild|\1/\2|"); do
	grep -q "${ebuild}" "${BROKEN}" && continue;

	test -f /etc/portage/bentoo.ignore &&
		grep -q "^${ebuild}$" /etc/portage/bentoo.ignore &&
		continue;

	echo ${ebuild};
done;
