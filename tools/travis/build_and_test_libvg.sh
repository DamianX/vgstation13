#!/bin/bash

cd libvg
# --jobs 1 to prevent threading problems with the BYOND crate.
RUST_BACKTRACE="1" RUST_TEST_THREADS=1 cargo test --jobs 1 --verbose
