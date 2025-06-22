#!/bin/sh

# SPDX-FileCopyrightText: 2024 Samuele Musiani <samu@teapot.ovh>
#
# SPDX-License-Identifier: AGPL-3.0-only

set -e # Exit on error
set -u # Treat unset variables as an error

if [ "$#" -ne 1 ]; then
  echo "This script converts a Jupyter notebook to HTML." >&2
  echo "Usage: $0 <notebook.ipynb>" >&2
  exit 1
fi

set -x # Print commands
/opt/venv/bin/jupyter nbconvert --to html "$1" --HTMLExporter.theme=dark
