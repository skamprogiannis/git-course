#!/bin/bash

git log --oneline
git log -n 2
git log --since="5 minutes ago"
git log --graph --pretty=format:'* %h %ad | %s%d [%an]' --date=short
