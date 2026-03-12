#!/bin/bash
# Run from within work/hello

# Merge main into greet
git switch greet
git merge main

# Switch to main and make hello.sh interactive
cat <<'EOF' > lib/hello.sh
#!/bin/bash

echo "What's your name"
read my_name

echo "Hello, $my_name"
EOF

git add . && git commit -m "feat: make hello.sh interactive"

# Attempt to merge main into greet (no conflict - exercise flaw, see report)
git switch greet
git merge main

# Rebase: reset greet to before the initial merge, then rebase onto main
git reset --hard 6b6187a
git rebase main

# Merge greet into main
git switch main
git merge greet
