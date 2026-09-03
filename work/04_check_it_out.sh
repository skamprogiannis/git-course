#!/bin/bash
# Run from within work/hello.

first_snapshot=$(git rev-list --max-parents=0 HEAD)
git switch --detach "$first_snapshot"
cat hello.sh
git switch --detach main~1
cat hello.sh
git switch main
cat hello.sh
