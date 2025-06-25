#!/bin/sh

# SPDX-FileCopyrightText: 2022 Luca Tagliavini <luca@teapot.ovh>
#
# SPDX-License-Identifier: AGPL-3.0-only

# This programs takes 3 arguments: the convert script, the regex and the
# program used for the conversion.

set -e # Exit on error
set -u # Treat unset variables as an error

# check the number of arguments
if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <convert_script> <regex> <program>"
  exit 1
fi

find . -print0 | xargs -r -0 -I{} "$1" '{}' "$2" "$3"
