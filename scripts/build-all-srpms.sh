#!/bin/sh
set -e
mkdir -p tmp/

for dir in *; do
	pkg=$(basename $dir)
	if ! test -f $dir/source; then
		echo "Dir $dir not a package"
		continue
	fi

	echo $pkg $(realpath tmp/$pkg)
	./scripts/checkout.sh $pkg $(realpath tmp/$pkg)
	cd tmp/$pkg
	cp -r * $HOME/rpmbuild/SOURCES/
	rpmbuild -bs --undefine=_disable_source_fetch $pkg.spec
	cd ../..
done

