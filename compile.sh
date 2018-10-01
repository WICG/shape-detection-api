#!/bin/bash

# So we can see what we're doing
set -x

# Exit with nonzero exit code if anything fails
set -e

SPECS="index index-zh-cn text"

# Run bikeshed.  If there are errors, exit with a non-zero code
for SPEC in $SPECS; do
  bikeshed --print=plain -f spec ${SPEC}.bs
done

# The out directory should contain everything needed to produce the
# HTML version of the spec.  Copy things there if the directory exists.

if [ -d out ]; then
  for SPEC in $SPECS; do
    cp ${SPEC}.html out
  done
fi
