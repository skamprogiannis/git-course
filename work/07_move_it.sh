#!/bin/bash
mkdir lib
git mv hello.sh lib/
git commit -m "chore: move hello.sh to lib directory"

cat <<EOF > Makefile
TARGET="lib/hello.sh"

run:
	bash ${TARGET}
