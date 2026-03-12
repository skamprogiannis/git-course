# Git Project Report

## Task 00: Setting Up the Repo

First of all we clone this mostly empty repository from Gitea. We then create the work
subdirectory as requested.

- `mkdir work`


### Task 01: Setting Up Git

No actions were taken as git was already installed on my machine. I later added a task01 bash
file with what would be expected I did on a fresh reboot on a Zone01 computer.

### Task 02: Git commits to commit

- `mkdir hello`
- `touch hello.sh`
- `echo "Hello, World" > hello.sh`
- `git init`

At this point git informed me that it set up the initial branch as "master" and I decided I would
have to change it to main and also change my defaults.

- `git config --global init.defaultBranch main`
- `git branch -m main`
- `git branch --show-current`
- `git status`

Satisfied with the name change I move on to the next part of the exercise, making our hello world
script modular.

- `echo '#!/bin/bash' > hello.sh`
- `echo 'Hello, $1' >> hello.sh`
- `bash hello.sh everynyan`
- `git commit -m "feat(hello): add a modular hello bash script`

I modified hello.sh in neovim so that it looked like:

```bash
#!/bin/bash

# Default is "World"
name=${1:-"World"}
echo "Hello, $name"
```

We are asked to stage the file, which means we can't make two separate modifications and commit
each one separately but we need to create two separate commits.

- `git add .`

I tried partially commiting with git commit -p but it did not work as I hoped. It appears there is
no escaping having to reset.

- `git reset -p hello.sh`

It's all one hunk and s (for split) does not work as the changes are too close together.
*Sorry, cannot split this hunk*

We have to manually edit the code we want to unstage with e (edit) and replace the + at the start
of the lines we don't want to commit with ' ' (for context).

- `git commit -m "docs(hello): add comment for default name value"`
- `git add hello.sh`
- `git commit -m "refactor(hello): use named variable with default value fallback"`

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

- `git switch --orphan temp-root`
- `echo "Hello, World" > hello.sh`
- `git add hello.sh`
- `git commit -m "feat(hello): initial hello world script"`
- `git switch main`
- `git rebase temp-root`
- `vim hello.sh`
- `git branch -d temp-root`


We change the file so that it keeps only the state we want at the second commit.

- `git add hello.sh`
- `git rebase --continue`

As I had originally created a repository on Gitea called git, (as we usually do with projects for
zone01) I had to restructure the directories to follow the expected format. The instructions to
initialize git inside the hello directory but submit a directory called git/ seem needlessly
confusing.

- `cd ..`
- `vim 01_setting_up_git.sh`
- `vim 02_git_commits_to_commit.sh`
- `git add .`
- `git commit -m "docs(work): add encapsulated solution scripts for tasks 1 and 2"`

### Task 03: History

- `git log`
- `git log --oneline`
- `git log -n 2`
- `git log --since="5 minutes ago"`
- `git log --graph --pretty=format:'* %h %ad | %s%d [%an]' --date=short`

We create a .sh file where these commands are saved.

- `vim 03_history.sh`
- `git add .`
- `git commit -m "docs(work): add encapsulated solution for history task"`
- `git push`

### Task 04: Check it out

- `cd ~/repositories/zone01/git/work/hello`
- `git reset HEAD~3`
- `git reset --hard`
- `cat hello.sh`

Well, this is obviously not what we were meant to do. I should have done checkout or switch
instead. Nevertheless, this can be a learning exercise. We will use the git reflog to get
our commits back.

- `git reset --hard f0cb236`
- `git checkout HEAD~2`
- `cat hello.sh`
- `get switch main`
- `cat hello.sh`
- `git add . && git commit -m "docs(work): add encapsulated solution for check it out task"`

### Task 05: TAG me

This one is pretty straight-forward. We just add tags and switch to the tags like they were commit
hashes.

### Task 06: Changed your mind?

```bash
echo '#!/bin/bash

# This is a bad comment. We want to revert it.
name=${1:-"World"}

echo "Hello, $name"' > hello.sh
```
- `git restore hello.sh`

Now for the staged unwanted change:

- `sed -i 's/# Default is "World"/# This is a bad comment/' hello.sh`
- `git add hello.sh`
- `git restore --staged hello.sh`
- `git restore hello.sh`

And for the commited change:

- `sed -i 's/# Default is "World"/# This is an unwanted but commited change/' hello.sh`
- `git reset --hard HEAD~1`

When I tried to move on to the next part of the exercise I realized that I couldn't complete it
properly as the exercise stupidly does not expect anyone to reset --hard but only to ever git 
revert. I am going to get creative.

- `git reflog`
- `git cherry-pick 085f094`
- `git tag oops`
- `git checkout v1`
- `git log --all --oneline`
- `git tag -d oops`
- `git reflog expire --expire=now --all`
- `git gc --prune=now`

We add the "Author: Jim Weirich" comment and commit.

- `git add hello.sh`
- `git commit -m "docs(hello): add author information"`
```bash
#!/bin/bash

# Default is World
# Author: Jim Weirich (jim@edgecase.com)
name=${1:-"World"}

echo "Hello, $name"
```
- `git add hello.sh`
- `git commit --amend --no-edit`

### Task 07: Move it

Working inside `work/hello`, we create the `lib/` directory and use `git mv` so the rename is tracked:

- `mkdir lib`
- `git mv hello.sh lib/`
- `git commit -m "chore: move hello.sh to lib directory"`

We then create a `Makefile` with a `run` target:

```makefile
TARGET="lib/hello.sh"

run:
	bash ${TARGET}
```

- `git add Makefile`
- `git commit -m "feat: add Makefile to run hello script from lib"`

We verify it works. Since `make` is not installed on this NixOS machine, we drop into a temporary shell:

- `nix-shell -p gnumake`
- `make run`  → outputs `Hello, World`

Back in the repo root we stage the script file and amend the parent commit to give it a proper message:

- `git add .`
- `git commit --amend` → `docs(work): add encapsulated solution for move it task`
- `git push`

### Task 08: blobs, trees and commits

This task explores git's internal object model using `git cat-file`.

First we inspect the commit object itself:

- `git cat-file -p HEAD`

This shows the tree hash, parent, author, and committer. We then look at the tree it points to:

- `git cat-file -p HEAD^{tree}`

Output shows two entries — the `Makefile` blob and the `lib/` subtree. We can read the Makefile blob directly by its hash:

- `git cat-file -p 407082da4bc68dba41102de9599b0a7c9def931b`

We encapsulate the pattern for exploring the lib subtree and the `hello.sh` blob into a script:

```bash
# Identify the current tree
git cat-file -p HEAD^{tree}

# Explore the 'lib' subdirectory tree
LIB_TREE=$(git ls-tree HEAD | grep 'lib' | awk '{print $3}')
git cat-file -p $LIB_TREE

# Read the content of hello.sh via its blob hash
HELLO_BLOB=$(git ls-tree -r HEAD | grep 'hello.sh' | awk '{print $3}')
git cat-file -p $HELLO_BLOB
```

- `git add 08_blobs_trees_and_commits.sh`
- `git commit -m "docs(work): add encapsulated solution for blobs, trees and commits task"`

### Task 09: Branching and Merging

We create a `greet` branch as a reference point, then do all the work on `main`.

- `git branch -c greet`

We add a `greeter.sh` library to `lib/` with a `Greeter()` function:

```bash
#!/bin/bash

Greeter() {
    who="$1"
    echo "Hello, $who"
}
```

- `git add lib/greeter.sh`
- `git commit -m "feat: add greeter script"`

We then refactor `hello.sh` to source and use the greeter function instead of inlining the logic:

- `git add lib/hello.sh`
- `git commit -m "refactor(hello): refactor hello.sh to use greeter.sh"`

We add an intentionally useless comment to the Makefile as required by the exercise:

- `sed -i '1i# Ensure it runs the updated lib/hello.sh file' Makefile`
- `git add . && git commit -m "docs: add useless comment to Makefile"`

We use `git diff greet` to review all changes made on `main` since the branch point.

Finally we add a README and check the full graph:

- `echo "This is the Hello World example from the git project." > README.md`
- `git add . && git commit -m "docs: add README.md"`
- `git log --all --oneline --graph --decorate`

### Task 10: Conflicts, Merging and Rebasing

#### Merge Main into Greet Branch

We switch to `greet` and merge `main` into it. Since `greet` had not diverged,
this is a fast-forward — git simply advances the branch pointer.

- `git switch greet`
- `git merge main`

#### Merging Main into Greet Branch (Conflict)

Back on `main`, we overwrite `hello.sh` with an interactive version:

```bash
#!/bin/bash

echo "What's your name"
read my_name

echo "Hello, $my_name"
```

- `git add . && git commit -m "feat: make hello.sh interactive"`

We then switch back to `greet` and attempt to merge `main`:

- `git switch greet`
- `git merge main`

No conflict arises. This is a flaw in the exercise: the instruction to merge
`main` into `greet` at the start of this task eliminated any divergence. Since
`greet` had no independent changes to `lib/hello.sh` after that first merge,
the second merge was yet another fast-forward. A conflict requires both branches
to have independently modified the same file since their common ancestor.

#### Rebasing Greet Branch

We go back to the point before the initial merge, resetting `greet` to where it
was before the task began:

- `git switch greet`
- `git reset --hard 6b6187a`
- `git rebase main`

This replays any commits unique to `greet` on top of `main`'s latest commit,
resulting in a linear history.

#### Merging Greet into Main

With `greet` rebased, we switch to `main` and merge:

- `git switch main`
- `git merge greet`

Because `greet` is now a direct descendant of `main`'s HEAD (thanks to the
rebase), this merge is a fast-forward and produces no merge commit.

#### Understanding Fast-Forwarding and the Difference Between Merging and Rebasing

**Fast-forwarding** happens when the branch you are merging into has not
diverged from the branch being merged. Git does not need to reconcile two
histories — it simply moves the branch pointer forward to the new commit. No
merge commit is created and the history stays linear.

**Merging** combines two diverged histories by creating a new merge commit that
has two parents. The history of both branches is fully preserved, making it
clear where the lines of development split and rejoined. This is safer for
shared/public branches since it never rewrites existing commits.

**Rebasing** moves (replays) the commits of one branch on top of another,
rewriting their hashes in the process. The result is a clean linear history
with no merge commits, as if the work had always been done on top of the latest
changes. The trade-off is that rebasing rewrites history, which can cause
problems if the branch has already been pushed and shared with others.
