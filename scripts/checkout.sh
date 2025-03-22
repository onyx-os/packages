#!/bin/sh
package=$1
dest=$2

origin=$(awk '$1 ~ /origin:/ { print $2 }' $1/source)
base=$(awk '$1 ~ /base-commit:/ { print $2}' $1/source)

if [ "$dest" = "" ]; then
	dest=$1
fi

echo "Checking out $origin commit $base to $dest"

git clone $origin $dest
git -C $dest checkout $base

if ls $package/*.patch 2>/dev/null; then
	echo "Applying patches..."
	git -C $dest am $PWD/$package/*.patch
	echo "Patches applied."
fi
