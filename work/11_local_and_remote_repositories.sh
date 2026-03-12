#!/bin/bash
# Run from within work/

# Clone the local hello repo
git clone hello cloned_hello
cd cloned_hello

# Inspect the clone
git log --oneline
git remote -v
git branch -a

# Make a change in the original repo
cd ../hello
echo "(changed in the original)" >> README.md
git add README.md && git commit -m "docs: update README"

# Back in the clone: fetch, inspect, then merge
cd ../cloned_hello
git fetch
git log --all --oneline --graph
git merge origin/main

# Track the remote greet branch locally
git switch --track origin/greet

# Add a backup remote and push both branches to it
git remote add backup /home/stefan/repositories/zone01/git/work/hello
git push backup main
git push backup greet
