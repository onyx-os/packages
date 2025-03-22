==========
Onyx package repository
==========

Welcome to the Onyx package repository. This repository hosts all files required to build rpms for core Onyx packages.

Package structure
=================

Each package consists of a directory (with a same-named repository), inside of it:
 * source, which very trivially defines which repo you need to clone to get the files
 * .patch files, in lexicographic order (as git format-patch would generate them). A package may have no patches.

Using
=====

If you want to add a new package, use scripts/package_to_patches.sh (requires git and a git repo it may fetch from):
``./scripts/package_to_patches.sh ../gcc``

This command should create a "gcc" directory with a source (the git repo's origin upstream url + base commit) and any
patches it figured out it needs in order for origin/base-branch to match the local base-branch.

Then, if you want to check a package out:
``./scripts/checkout.sh <package path> <optional output directory>``

if you don't pass it an output directory, it will clone the build files to the current directory, with the same name as the package. You may then build it using regular rpmbuild machinery.

