#!/bin/sh
# SPDX-License-Identifer: GPL-2.0-only
# # Copyright (c) Pedro Falcato
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
git -C $dest checkout $base

if ls $package/*.patch 2>/dev/null; then
	echo "Applying patches..."
	git -C $dest am $(realpath $package)/*.patch
	echo "Patches applied."
fi
