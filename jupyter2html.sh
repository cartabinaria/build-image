#!/bin/sh -ex

/opt/venv/bin/jupyter nbconvert --to html "$1" --HTMLExporter.theme=dark
