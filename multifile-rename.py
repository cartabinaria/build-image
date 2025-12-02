#!/usr/bin/env python3

# This script solve the problem of multi-file latex projects. When they compile
# only the main file is compiled, but it remains inside the directory of the
# project. We move the main file to the parent directory and rename it to the
# name of the project folder.

import os
import sys
import re
import shutil
import subprocess


def rename_files(regex, target):
    for root, dirs, files in os.walk(target):
        dirs[:] = [d for d in dirs if not d.startswith(".")]

        if depth(target, root) < 1:
            continue

        matched_files = [f for f in files if regex.search(f)]
        if len(matched_files) != 1:
            continue

        result = subprocess.run(
            ['git', 'status', '--short'], stdout=subprocess.PIPE, cwd=root)

        if f'?? {matched_files[0]}' not in result.stdout.decode('utf-8').splitlines():
            print("File", matched_files[0],
                  "is tracked by git, skipping...")
            continue

        print("Current directory:", root)
        print("Matched files:", matched_files)
        print("depth:", depth(target, root))

        p1 = os.path.join(root, matched_files[0])
        p2 = os.path.join(os.path.dirname(root), os.path.basename(
            root) + os.path.splitext(matched_files[0])[1])
        print("Renaming", p1, "to", p2)
        shutil.move(p1, p2)


def depth(root, path):
    rel = os.path.relpath(path, root)
    return 0 if rel == "." else rel.count(os.sep)


def main():
    regex = sys.argv[1]
    target = sys.argv[2]

    regex_compiled = re.compile(regex)
    rename_files(regex_compiled, target)


if __name__ == "__main__":
    main()
