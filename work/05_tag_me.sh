#!/bin/bash

git tag v1
git tag v1-beta main~1
git checkout v1-beta
cat hello.sh
git checkout v1
cat hello.sh
git switch main
git tag

