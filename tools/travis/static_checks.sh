#!/bin/sh
set -e
# Has to use Python 2 instead of 3 because else it won't find colorama.
python tools/travis/check_map_files.py maps/
find -name '*.dme' -exec cat {} \; | awk '/maps\\test.*/ { exit 1 }'
python tools/changelog/ss13_genchangelog.py html/changelog.html html/changelogs --dry-run
