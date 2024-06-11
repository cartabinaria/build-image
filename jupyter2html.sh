#!/bin/sh -ex

jupyter nbconvert --to html "$1" --HTMLExporter.theme=dark
