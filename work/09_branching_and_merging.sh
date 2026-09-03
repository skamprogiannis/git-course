#!/bin/bash
# Run from within work/hello.

git switch -c greet

cat <<'EOF' > lib/greeter.sh
#!/bin/bash

Greeter() {
    who="$1"
    echo "Hello, $who"
}
EOF

git add lib/greeter.sh
git commit -m "feat: add greeter script"

cat <<'EOF' > lib/hello.sh
source lib/greeter.sh

name="$1"
if [ -z "$name" ]; then
    name="World"
fi

Greeter "$name"
EOF

git add lib/hello.sh
git commit -m "refactor(hello): refactor hello.sh to use greeter.sh"

sed -i '1i# Ensure it runs the updated lib/hello.sh file' Makefile
git add Makefile
git commit -m "docs: explain Makefile target"

git switch main
git diff main..greet -- Makefile lib/hello.sh lib/greeter.sh

echo "This is the Hello World example from the git project." > README.md
git add README.md
git commit -m "docs: add README.md"

git log --all --oneline --graph --decorate
