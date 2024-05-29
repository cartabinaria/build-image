#!/bin/sh
set -x

# This script is called by ./rec and is used to actually check and convert a 
# file. It takes 3 arguments: the file path, the regex that needs to match the 
# file and the program used for the conversion.

echo "$1" | grep -E "$2" > /dev/null 
MATCH=$?

if [ $MATCH -eq 0 ]; then
  cd "$(dirname "$1")" || exit 1
  "$3" "$(basename "$1")"
elif [ $MATCH -ne 1 ]; then
  exit 1
fi
