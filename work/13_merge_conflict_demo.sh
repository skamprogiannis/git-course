#!/bin/bash
# Run from within work/hello
# This supplemental task demonstrates a standalone merge-conflict workflow.

# Create a new branch and modify hello.sh one way
git switch -c conflict-demo

cat <<'EOF' > lib/hello.sh
#!/bin/bash

echo "What's your name"
read my_name

echo "Hello, $my_name"
echo "Goodbye, $my_name"
EOF

git add lib/hello.sh
git commit -m "feat: add goodbye message to hello.sh"

# On main, modify the same lines differently
git switch main

cat <<'EOF' > lib/hello.sh
#!/bin/bash

echo "What's your name"
read my_name

echo "Hello, $my_name"
echo "Have a nice day, $my_name"
EOF

git add lib/hello.sh
git commit -m "feat: add pleasant farewell to hello.sh"

# Merge conflict-demo into main - this WILL conflict on lib/hello.sh
git merge conflict-demo

# Resolve by accepting both farewell lines (manual edit removes conflict markers)
cat <<'EOF' > lib/hello.sh
#!/bin/bash

echo "What's your name"
read my_name

echo "Hello, $my_name"
echo "Have a nice day, $my_name"
echo "Goodbye, $my_name"
EOF

git add lib/hello.sh
git commit -m "fix: resolve merge conflict combining farewell messages"

git log --all --oneline --graph --decorate
