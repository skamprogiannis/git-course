#!/bin/bash
# Run from within work/

# Create a bare clone of hello to act as a shared remote
git clone --bare hello hello.git

# In the original repo, add the bare repo as a remote
cd hello
git remote add shared ../hello.git

# Make a change and push it to the shared bare repo
cat <<'EOF' > README.md
This is the Hello World example from the git project.
(Changed in the original and pushed to shared)
EOF

git add README.md && git commit -m "docs: update README for shared repo"
git push shared main

# From the clone, pull the new changes directly from the bare repo
cd ../cloned_hello
git pull ../hello.git main
