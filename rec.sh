#!/bin/sh -ex

# The chaining of find and grep was deemded necessary due to find's lack of a
# proper regex implementation. Also note that on linux find does not support
# -E like on BSDs.

# This programs takes 3 arguments: the convert script, the regex and the 
# program used for the conversion.

find . -print0 | xargs -r -0 -I{} "$1" '{}' "$2" "$3"
