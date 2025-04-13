#!/bin/sh
# SPDX-License-Identifer: GPL-2.0-only
# Copyright (c) Pedro Falcato
set -e
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
trap "rm -rf $dest" EXIT
git -C $dest log --oneline $base..HEAD
