#!/bin/bash

source $HOME/BYOND-${BYOND_MAJOR}.${BYOND_MINOR}/byond/bin/byondsetup
DM_UNIT_TESTS="1" python tools/travis/build.py
cp tools/travis/config/config.txt config/
tools/travis/run_dm_tests.py
