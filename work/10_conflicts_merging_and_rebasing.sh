#!/bin/bash
# Run from within work/hello

# Merge main into greet
git switch greet
greet_before_merge=$(git rev-parse HEAD)
git merge main

# Switch to main and make hello.sh interactive
git switch main
cat <<'EOF' > lib/hello.sh
#!/bin/bash

echo "What's your name"
read my_name

echo "Hello, $my_name"
EOF

git add . && git commit -m "feat: make hello.sh interactive"

# Merge main into greet, then resolve the expected hello.sh conflict
git switch greet
git merge main

# During this merge, main is "theirs". Accept its interactive hello.sh.
git checkout --theirs lib/hello.sh
git add lib/hello.sh
git commit -m "fix: resolve hello script merge conflict"

# Rebase: return to greet's pre-merge tip, then replay it onto main.
git reset --hard "$greet_before_merge"
git rebase main

# During a rebase, "theirs" is the feature commit being replayed.
git checkout --theirs lib/hello.sh
git add lib/hello.sh
GIT_EDITOR=true git rebase --continue

# Merge greet into main
git switch main
git merge greet
