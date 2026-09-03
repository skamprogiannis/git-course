#!/bin/bash
# Run from within work/hello.

mkdir -p lib
git mv hello.sh lib/
git commit -m "chore: move hello.sh to lib directory"

cat <<'EOF' > Makefile
TARGET="lib/hello.sh"

run:
	bash ${TARGET}
EOF

git add Makefile
git commit -m "feat: add Makefile runner"
