# Git Ready Project Report

## Task 00: Setting Up the Repo

I cloned the starter repository from Gitea and created the required `work/`
subdirectory.

```bash
mkdir work
```


### Task 01: Setting Up Git

Git was already installed on my workstation. I recorded the identity and default-branch
configuration required on a fresh Zone01 installation in the Task 01 shell file.

### Task 02: Git commits to commit

```bash
mkdir hello
touch hello.sh
echo "Hello, World" > hello.sh
git init
```

At this point git informed me that it set up the initial branch as "master" and I decided I would
have to change it to main and also change my defaults.

```bash
git config --global init.defaultBranch main
git branch -m main
git branch --show-current
git status
```

Satisfied with the name change I move on to the next part of the exercise, making our hello world
script modular.

```bash
echo '#!/bin/bash' > hello.sh
echo 'echo "Hello, $1"' >> hello.sh
bash hello.sh everynyan
git add hello.sh
git commit -m "feat(hello): add a modular hello bash script"
```

I modified hello.sh in neovim so that it looked like:

```bash
#!/bin/bash

# Default is "World"
name=${1:-"World"}
echo "Hello, $name"
```

We are asked to stage the file, which means we can't make two separate modifications and commit
each one separately but we need to create two separate commits.

```bash
git add .
```

I tried partial staging with `git commit -p`, but the changes were still staged as a single hunk.
I used `git reset -p` to edit the staged patch instead:

```bash
git reset -p hello.sh
```

The changes were close enough that Git could not split the hunk automatically:

```text
Sorry, cannot split this hunk
```

We have to manually edit the code we want to unstage with e (edit) and replace the + at the start
of the lines we don't want to commit with ' ' (for context).

```bash
git commit -m "docs(hello): add comment for default name value"
git add hello.sh
git commit -m "refactor(hello): use named variable with default value fallback"
```

At this point I revisited the submission structure in the subject:

> To begin, create a work directory and organize all your tasks within it. Each exercise should
be encapsulated in its own file, named after the corresponding task for clarity and ease of
reference.

So far I had edited `hello.sh` and documented the work in this report. The audit clarified that
each stage also needed its own solution file:

> The student must provide you with a file containing the solutions for each task.

I therefore added the task-specific shell files. I had also omitted the initial snapshot containing
only `echo "Hello, World"`, so I repaired the exercise repository's history before continuing.

I will create a temporary branch with the first commit I was supposed to have and rebase main.

```bash
git switch --orphan temp-root
echo "Hello, World" > hello.sh
git add hello.sh
git commit -m "feat(hello): initial hello world script"
git switch main
git rebase temp-root
vim hello.sh
git branch -d temp-root
```


We change the file so that it keeps only the state we want at the second commit.

```bash
git add hello.sh
git rebase --continue
```

Because the subject requires a nested `work/hello` repository inside the submitted project, I
restructured the outer Gitea repository to preserve both the solution files and the inner exercise.

```bash
cd ..
vim 01_setting_up_git.sh
vim 02_git_commits_to_commit.sh
git add .
git commit -m "docs(work): add encapsulated solution scripts for tasks 1 and 2"
```

### Task 03: History

```bash
git log
git log --oneline
git log -n 2
git log --since="5 minutes ago"
git log --graph --pretty=format:'* %h %ad | %s%d [%an]' --date=short
```

We create a .sh file where these commands are saved.

```bash
vim 03_history.sh
git add .
git commit -m "docs(work): add encapsulated solution for history task"
git push
```

### Task 04: Check it out

```bash
cd work/hello
git reset HEAD~3
git reset --hard
cat hello.sh
```

This reset was not the requested approach: the exercise called for checking out earlier snapshots.
It became a useful recovery exercise, however, because the reflog allowed me to restore the commits.

```bash
git reset --hard f0cb236
git switch --detach HEAD~2
cat hello.sh
git switch main
cat hello.sh
```

### Task 05: TAG me

This task adds tags and checks out the snapshots they reference.

### Task 06: Changed your mind?

```bash
echo '#!/bin/bash

# This is a bad comment. We want to revert it.
name=${1:-"World"}

echo "Hello, $name"' > hello.sh
```
```bash
git restore hello.sh
```

Now for the staged unwanted change:

```bash
sed -i 's/# Default is "World"/# This is a bad comment/' hello.sh
git add hello.sh
git restore --staged hello.sh
git restore hello.sh
```

And for the committed change:

```bash
sed -i 's/# Default is "World"/# This is an unwanted but committed change/' hello.sh
git add hello.sh
git commit -m "bad(hello): unwanted change"
git revert --no-edit HEAD
```

The subject next asks for the unwanted commit to remain visible through an `oops` tag, followed by
resetting the branch to `v1`, inspecting the deleted history, and finally pruning the unreferenced
objects.

```bash
git reflog
git tag oops
git reset --hard v1
git log --all --oneline
git tag -d oops
git reflog expire --expire=now --all
git gc --prune=now
```

We add the "Author: Jim Weirich" comment and commit.

```bash
git add hello.sh
git commit -m "docs(hello): add author information"
```
```bash
#!/bin/bash

# Default is World
# Author: Jim Weirich (jim@edgecase.com)
name=${1:-"World"}

echo "Hello, $name"
```
```bash
git add hello.sh
git commit --amend --no-edit
```

### Task 07: Move it

Working inside `work/hello`, we create the `lib/` directory and use `git mv` so the rename is tracked:

```bash
mkdir lib
git mv hello.sh lib/
git commit -m "chore: move hello.sh to lib directory"
```

We then create a `Makefile` with a `run` target:

```makefile
TARGET="lib/hello.sh"

run:
	bash ${TARGET}
```

```bash
git add Makefile
git commit -m "feat: add Makefile to run hello script from lib"
```

We verify it works. Since `make` is not installed on this NixOS machine, we drop into a temporary shell:

```bash
nix-shell -p gnumake
```
- `make run`  → outputs `Hello, World`

Back in the repo root we stage the script file and amend the parent commit to give it a proper message:

```bash
git add .
```
- `git commit --amend` → `docs(work): add encapsulated solution for move it task`
```bash
git push
```

### Task 08: blobs, trees and commits

This task explores Git's internal object model using `git cat-file`.

First we inspect the commit object itself:

```bash
git cat-file -p HEAD
```

This shows the tree hash, parent, author, and committer. We then look at the tree it points to:

```bash
git cat-file -p HEAD^{tree}
```

Output shows two entries — the `Makefile` blob and the `lib/` subtree. We can read the Makefile blob directly by its hash:

```bash
git cat-file -p 407082da4bc68dba41102de9599b0a7c9def931b
```

We encapsulate the pattern for exploring the lib subtree and the `hello.sh` blob into a script:

```bash
# Identify the current tree
git cat-file -p 'HEAD^{tree}'

# Explore the 'lib' subdirectory tree
LIB_TREE=$(git ls-tree -d HEAD -- lib | awk '{print $3}')
git cat-file -p "$LIB_TREE"

# Read the content of hello.sh via its blob hash
HELLO_BLOB=$(git ls-tree -r HEAD -- lib/hello.sh | awk '{print $3}')
git cat-file -p "$HELLO_BLOB"
```

```bash
git add 08_blobs_trees_and_commits.sh
git commit -m "docs(work): add encapsulated solution for blobs, trees and commits task"
```

### Task 09: Branching and Merging

We create and switch to the `greet` feature branch:

```bash
git switch -c greet
```

We add a `greeter.sh` library to `lib/` with a `Greeter()` function:

```bash
#!/bin/bash

Greeter() {
    who="$1"
    echo "Hello, $who"
}
```

```bash
git add lib/greeter.sh
git commit -m "feat: add greeter script"
```

We then refactor `hello.sh` to source and use the greeter function instead of inlining the logic:

```bash
git add lib/hello.sh
git commit -m "refactor(hello): refactor hello.sh to use greeter.sh"
```

We add the explanatory comment required by the exercise to the Makefile:

```bash
sed -i '1i# Ensure it runs the updated lib/hello.sh file' Makefile
git add Makefile
git commit -m "docs: explain Makefile target"
```

We return to `main` and compare the three exercise files across the diverged branches:

```bash
git switch main
git diff main..greet -- Makefile lib/hello.sh lib/greeter.sh
```

Finally, we add the requested README on `main` and inspect the full graph:

```bash
echo "This is the Hello World example from the git project." > README.md
git add README.md
git commit -m "docs: add README.md"
git log --all --oneline --graph --decorate
```

### Task 10: Conflicts, Merging and Rebasing

#### Merge Main into Greet Branch

We record the current `greet` tip so it can be restored for the later rebase demonstration, then
merge `main` into it. Both branches have unique commits, so Git creates a merge commit.

```bash
git switch greet
greet_before_merge=$(git rev-parse HEAD)
git merge main
```

#### Merging Main into Greet Branch (Conflict)

Back on `main`, we overwrite `hello.sh` with an interactive version:

```bash
git switch main
cat <<'EOF' > lib/hello.sh
#!/bin/bash

echo "What's your name"
read my_name

echo "Hello, $my_name"
EOF
```

```bash
git add . && git commit -m "feat: make hello.sh interactive"
```

We then switch back to `greet` and merge `main`:

```bash
git switch greet
git merge main
```

This produces the expected conflict: `greet` changed `hello.sh` to use the greeter library while
`main` replaced it with the interactive implementation. During a merge of `main` into `greet`,
`main` is the `theirs` side, so accepting the required `main` version and committing the resolution
looks like this:

```bash
git checkout --theirs lib/hello.sh
git add lib/hello.sh
git commit -m "fix: resolve hello script merge conflict"
```

#### Rebasing Greet Branch

We return `greet` to the tip recorded before the initial merge, then replay its commits on top of
the latest `main`:

```bash
git switch greet
git reset --hard "$greet_before_merge"
git rebase main
```

The `hello.sh` change conflicts again during the rebase. Here, `theirs` refers to the feature commit
being replayed, so we retain the greeter-based implementation and continue:

```bash
git checkout --theirs lib/hello.sh
git add lib/hello.sh
GIT_EDITOR=true git rebase --continue
```

This replays the commits unique to `greet` on top of `main`, resulting in a linear history.

#### Merging Greet into Main

With `greet` rebased, we switch to `main` and merge:

```bash
git switch main
git merge greet
```

Because `greet` is now a direct descendant of `main`'s `HEAD`, this merge is a fast-forward and
produces no merge commit.

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

### Task 11: Local and Remote Repositories

We clone the `hello` repo locally to simulate a remote workflow:

```bash
git clone hello cloned_hello
cd cloned_hello
```

We inspect the clone to understand what was brought over:

```bash
git log --oneline
```
- `git remote -v` — origin points to the local `hello` directory
- `git branch -a` — shows local `main` and remote-tracking `origin/main`, `origin/greet`

We then go back to the original `hello` repo and make a change:

```bash
echo "(changed in the original)" >> README.md
git add README.md && git commit -m "docs: update README"
```

Back in `cloned_hello` we fetch the new commit without merging it yet:

```bash
git fetch
git log --all --oneline --graph
```

The graph shows `origin/main` is now one commit ahead of our local `main`. We
merge it in:

```bash
git merge origin/main
```

We also set up a local tracking branch for the remote `greet` branch:

```bash
git switch --track origin/greet
```

Finally we add a second remote called `backup` and push both branches to it:

```bash
git remote add backup ../hello
git push backup main
git push backup greet
```

#### Audit Question: Single command equivalent to fetch + merge

The single command is `git pull`. It is a shorthand that combines `git fetch`
(downloads new data from the remote) followed immediately by `git merge`
(integrates those changes into the current branch).

### Task 12: Bare Repositories

A bare repository contains only the git object store with no working tree. It
is the standard format for a shared remote that multiple developers push to and
pull from.

From `work/` we create a bare clone of `hello`:

```bash
git clone --bare hello hello.git
```

We add it as a remote inside the original `hello` repo:

```bash
git remote add shared ../hello.git
```

We update the README and push the commit to the shared bare repo:

```bash
git add README.md && git commit -m "docs: update README for shared repo"
git push shared main
```

Finally, from `cloned_hello` we pull the new commit directly from the bare repo:

```bash
git pull ../hello.git main
```

This demonstrates the typical workflow: a bare repo sits in the middle acting
as the authoritative remote while working repos on either side push to and pull
from it.

### Task 13: Merge Conflict Demo

This supplemental task constructs a small, standalone merge conflict. It keeps a compact example in
the preserved exercise history alongside the complete merge-and-rebase sequence from Task 10.

We create a new branch `conflict-demo` and modify `lib/hello.sh` to add a
goodbye line:

```bash
git switch -c conflict-demo
```
- edit `lib/hello.sh` → add `echo "Goodbye, $my_name"`
```bash
git add lib/hello.sh && git commit -m "feat: add goodbye message to hello.sh"
```

Back on `main` we make a **different** change to the same line:

```bash
git switch main
```
- edit `lib/hello.sh` → add `echo "Have a nice day, $my_name"`
```bash
git add lib/hello.sh && git commit -m "feat: add pleasant farewell to hello.sh"
```

Now both branches have diverged on the same part of the file. Merging triggers
a conflict:

```bash
git merge conflict-demo
```

```
CONFLICT (content): Merge conflict in lib/hello.sh
Automatic merge failed; fix conflicts and then commit the result.
```

Git inserts conflict markers into the file:

```
<<<<<<< HEAD
echo "Have a nice day, $my_name"
=======
echo "Goodbye, $my_name"
>>>>>>> conflict-demo
```

We resolve manually by keeping both lines (accepting changes from both sides),
removing the markers, then staging and committing:

```bash
git add lib/hello.sh
git commit -m "fix: resolve merge conflict combining farewell messages"
```

The resulting graph shows a true merge commit with two parents:

```
*   1067c1b (HEAD -> main) fix: resolve merge conflict combining farewell messages
|\
| * 4deeb4b (conflict-demo) feat: add goodbye message to hello.sh
* | 08349e3 feat: add pleasant farewell to hello.sh
|/
```
