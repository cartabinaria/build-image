#!/bin/sh

# SPDX-FileCopyrightText: 2024 Samuele Musiani <samu@teapot.ovh>
# SPDX-FileCopyrightText: 2025 Eyad Issa <eyadlorenzo@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-only

# This script is called by ./rec and is used to actually check and convert a
# file. It takes 3 arguments: the file path, the regex that needs to match the
# file and the program used for the conversion.

set -u # Treat unset variables as an error

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <file_path> <regex> <conversion_program>" >&2
  exit 1
fi

echo "Processing $1..."
echo "$1" | grep -E "$2"
MATCH=$?

if [ $MATCH -eq 0 ]; then
  cd "$(dirname "$1")" || exit 1

  set -x # Print commands
  $3 "$(basename "$1")"
  set +x # Stop printing commands

elif [ $MATCH -ne 1 ]; then
  echo "Skipping $1: grep returned an error" >&2
  exit 1
fi
