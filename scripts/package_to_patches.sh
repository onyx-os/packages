#!/bin/sh
# SPDX-License-Identifer: GPL-2.0-only
# Copyright (c) Pedro Falcato
set -e
packagerepo=$1
package=$(basename "$packagerepo")

# Given a package repo, create a package subdirectory locally,
# output a bunch of information, and generate git patches.

mkdir -p $package

echo $packagerepo
alias rgit='git -C "$packagerepo"'
branch=$(rgit symbolic-ref --short HEAD)
pkgorigin=$(rgit remote get-url origin)
base=$(rgit rev-parse origin/$branch)

# Replace git@github.com:<repo> ssh links with an https accessible link
pkgorigin=$(echo $pkgorigin | sed 's/git@github\.com:/https:\/\/github\.com\//g')
echo "Package origin: $pkgorigin $branch $base"
echo "origin: $pkgorigin" > $package/source
echo "base-commit: $base" >> $package/source

rgit format-patch -o $PWD/$package --base=auto origin/$branch
