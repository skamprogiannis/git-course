# Git Project Report

## Task 00: Setting Up the Repo

First of all we clone this mostly empty repository from Gitea. We then create the work
subdirectory as requested.

- mkdir work


### Task 01: Setting Up Git

No actions were taken as git was already installed on my machine. I later added a task01 bash
file with what would be expected I did on a fresh reboot on a Zone01 computer.

### Task 02: Git commits to commit

- mkdir hello
- touch hello.sh
- echo "Hello, World" > hello.sh
- git init

At this point git informed me that it set up the initial branch as "master" and I decided I would
have to change it to main and also change my defaults.

- git config --global init.defaultBranch main
- git branch -m main
- git branch --show-current
- git status

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
```

We are asked to stage the file, which means we can't make two separate modifications and commit
each one separately but we need to create two separate commits.

- git add .

I tried partially commiting with git commit -p but it did not work as I hoped. It appears there is
no escaping having to reset.

- git reset -p hello.sh

It's all one hunk and s (for split) does not work as the changes are too close together.
*Sorry, cannot split this hunk*

We have to manually edit the code we want to unstage with e (edit) and replace the + at the start
of the lines we don't want to commit with ' ' (for context).

- git commit -m "docs(hello): add comment for default name value"
- git add hello.sh
- git commit -m "refactor(hello): use named variable with default value fallback"

At this point I re-read the incredibly confusing:

> To begin, create a work directory and organize all your tasks within it. Each exercise should
be encapsulated in its own file, named after the corresponding task for clarity and ease of
reference.

So far I was just editing the hello.sh and reporting my work in this report.md file in the root
directory. These instructions seem to want a separate bash file for every stage of the project.
It's unfortunate but I consult the audit questions found online.

> The student must provide you with a file containing the solutions for each task.

It appears I will indeed have to create several different .sh files. It also seems like I was
expected to commit the very first bash file with the simple "Hello, World" echo. Time to re-write
history and change the directory structure.

I will create a temporary branch with the first commit I was supposed to have and rebase main.

- git switch --orphan temp-root
- echo "Hello, World" > hello.sh
- git add hello.sh
- git commit -m "feat(hello): initial hello world script"
- git switch main
- git rebase temp-root
- vim hello.sh
- git branch -d temp-root


We change the file so that it keeps only the state we want at the second commit.

- git add hello.sh
- git rebase --continue

As I had originally created a repository on Gitea called git, (as we usually do with projects for
zone01) I had to restructure the directories to follow the expected format. The instructions to
initialize git inside the hello directory but submit a directory called git/ seem needlessly
confusing.

- cd ..
- vim 01_setting_up_git.sh
- vim 02_git_commits_to_commit.sh
- git add .
- git commit -m "docs(work): add encapsulated solution scripts for tasks 1 and 2"

### Task 03: History

- git log
- git log --oneline
- git log -n 2
- git log --since="5 minutes ago"
- git log --graph --pretty=format:'* %h %ad | %s%d [%an]' --date=short

We create a .sh file where these commands are saved.

- vim 03_history.sh
- git add .
- git commit -m "docs(work): add encapsulated solution for history task"
- git push

### Task 04: Check it out

- cd ~/repositories/zone01/git/work/hello
- git reset HEAD~3
- git reset --hard
- cat hello.sh

Well, this is obviously what we were meant to do. I should have done checkout or switch instead.
Nevertheless, this can be a learning exercise. We will use the git reflog to get our commits back.

- git reset --hard f0cb236
- git checkout HEAD~2
- cat hello.sh
- get switch main
- cat hello.sh
- git add . && git commit -m "docs(work): add encapsulated solution for check it out task"

### Task 05: TAG me


