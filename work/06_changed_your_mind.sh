#!/bin/bash

echo "# This is a bad comment." >> hello.sh
git restore hello.sh

sed -i 's/# Default is "World"/# This is a bad comment/' hello.sh
git add hello.sh
git restore --staged hello.sh
git restore hello.sh

sed -i 's/# Default is "World"/# This is an unwanted but committed change/' hello.sh
git add hello.sh
git commit -m "bad(hello): unwanted change"
git revert --no-edit HEAD
git tag oops
git reset --hard v1

git log --all --oneline
git tag -d oops
git reflog expire --expire=now --all
git gc --prune=now
git log --all --oneline

sed -i '/#!/a \
\
# Default is World\
# Author: Jim Weirich' hello.sh
git add hello.sh
git commit -m "docs(hello): add author information"

sed -i 's/Jim Weirich/Jim Weirich (jim@edgecase.com)/' hello.sh
git add hello.sh
git commit --amend --no-edit
