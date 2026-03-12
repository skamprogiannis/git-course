#!/bin/bash
# Identify the current tree
git cat-file -p HEAD^{tree}

# Explore the 'lib' subdirectory tree
LIB_TREE=$(git ls-tree HEAD | grep 'lib' | awk '{print $3}')
git cat-file -p $LIB_TREE

# Read the content of hello.sh via its blob hash
HELLO_BLOB=$(git ls-tree -r HEAD | grep 'hello.sh' | awk '{print $3}')
git cat-file -p $HELLO_BLOB
