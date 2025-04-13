#!/bin/sh
# SPDX-License-Identifer: GPL-2.0-only
# Copyright (c) Pedro Falcato
set -e

TEMP=$(getopt -o 'uh' --long 'upstream,help' -n 'checkout' -- "$@")

print_help()
{
	echo "Usage: checkout.sh [OPTIONS] [package name] [optional target directory]"
	echo "Checkout an Onyx rpm package, based on the upstream variant plus in-repo packages"
	echo "Options:"
	echo " -u, --upstream         Check out the most recent commit and attempt to apply patches."
	echo " -h, --help             Show this help message."
}

eval set -- "$TEMP"

unset TEMP

while true; do
	case "$1" in
		'-u'|'--upstream')
			upstream=1
			shift
			continue
		;;
		'-h'|'--help')
			print_help
			exit 0
		;;
		'--')
			shift
			break
		;;
	esac
done

package=$1
dest=$2

origin=$(awk '$1 ~ /origin:/ { print $2 }' $1/source)
base=$(awk '$1 ~ /base-commit:/ { print $2}' $1/source)

if [ "$dest" = "" ]; then
	dest=$(basename $1)
fi

dest=$(realpath "$dest")

echo "Checking out $origin commit $base to $dest"

git clone $origin $dest

if [ "$upstream" != "1" ]; then
	git -C $dest checkout $base
fi

if ls $package/*.patch 2>/dev/null; then
	echo "Applying patches..."
	git -C $dest am $(realpath $package)/*.patch
	echo "Patches applied."
fi
