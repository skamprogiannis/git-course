# Report of Process

## Setting Up Git

No actions were taken as git was already installed on my machine.

## Git commits to commit

- mkdir hello
- touch hello.sh
- echo "Hello, World" > hello.sh
- git init"Hello, World" hello.sh

At this point git informed me that it set up the initial branch as "master" and I decided I would
have to change it to main and also change my defaults.

- git config --global init.defaultBranch main
- git branch -m main
- git branch --show-current

Satisfied with the name change I move on to the next part of the exercise, making our hello world
script modular.

- echo '#!/bin/bash' > hello.sh
- echo 'Hello, $1' >> hello.sh
- bash hello.sh everynyan
- git commit -m "feat(hello): add a modular hello bash script

I modified hello.sh in neovim so that it looked like:

```bash
#!/bin/bash

# Default is "World"
name=${1:-"World"}
echo "Hello, $name"


