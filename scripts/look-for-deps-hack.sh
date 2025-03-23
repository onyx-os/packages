#!/bin/sh
package=$1

# Look for - lines in patches that suggest we hacked a dependency out
git grep -E -- "-(Requires|BuildRequires): .*$1.*"
