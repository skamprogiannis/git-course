#!/bin/bash
# Task 02: Git commits to commit

# 1. Initial Setup
mkdir -p hello && cd hello
echo "Hello, World" > hello.sh
git init

# 2. Branch Normalization (Fixing 'master' to 'main')
git config --global init.defaultBranch main
git branch -m main

# 3. First Logic Update (Modular Script)
echo '#!/bin/bash' > hello.sh
echo 'echo "Hello, $1"' >> hello.sh
git add hello.sh
git commit -m "feat(hello): add a modular hello bash script"

# 4. The "Hunk Edit" Challenge (Neovim modification)
# [Manual step: Modified hello.sh to include comment and variable fallback]
cat <<EOF > hello.sh
#!/bin/bash

# Default is "World"
name=\${1:-"World"}
echo "Hello, \$name"
EOF

# Attempting to split commits from a single staged file
git add .
# Using reset -p with manual 'e' (edit) to unstage logic while keeping comments
# git reset -p hello.sh (Interactive)
git commit -m "docs(hello): add comment for default name value"
git add hello.sh
git commit -m "refactor(hello): use named variable with default value fallback"

# 5. History Rewrite (The Orphan Rebase)
# Realized the initial "Hello, World" commit was missing from history
git switch --orphan temp-root
echo "Hello, World" > hello.sh
git add hello.sh
git commit -m "feat(hello): initial hello world script"

git switch main
# Rebase main onto the new initial commit
# git rebase temp-root (Conflict resolved manually in hello.sh)
git branch -d temp-root

# Clean up status
git add hello.sh
# git rebase --continue
