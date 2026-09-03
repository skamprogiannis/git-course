# Git Ready — Version Control Coursework

A documented, hands-on tour of Git fundamentals completed at Zone01 Athens. The
repository records the commands, mistakes, recovery techniques, and repository
history used to progress from a single shell script to branching, rebasing,
conflict resolution, remotes, and bare repositories.

## What this demonstrates

- focused commits and partial staging;
- history inspection, tags, detached `HEAD`, reflog recovery, and object
  inspection;
- branches, fast-forward and three-way merges, conflict resolution, and rebasing;
- local remotes, tracking branches, fetch/merge/pull, and bare repositories;
- practical recovery after destructive commands in an isolated exercise repo.

The exercises follow the official
[01 Edu Git subject](https://github.com/01-edu/public/tree/master/subjects/git).

## Repository guide

| Path | Purpose |
| --- | --- |
| [`report.md`](report.md) | Detailed exercise journal, explanations, and audit answers |
| [`work/`](work/) | One command record per subject task |
| `exercise/main` | Preserved final history of the nested `hello` exercise repository |
| `exercise/greet` | Preserved feature-branch tip from the branching exercise |
| `exercise/conflict-demo` | Preserved two-parent merge-conflict demonstration |

The `exercise/*` branches retain the real commit graph created inside the nested
training repository. They are intentionally separate from this documentation
branch so both layers of history remain reviewable.

## Safety

The files under `work/` are coursework records, not general-purpose automation.
Several deliberately create commits, move branch pointers, expire reflogs, or
change remotes. Read them first and run them only inside a disposable clone of
the exercise repository. In particular, `01_setting_up_git.sh` records the
machine-wide identity configuration required by the subject.

## Verification

The repository's CI checks every exercise file with Bash's parser and ShellCheck:

```bash
bash -n work/*.sh
shellcheck -S warning work/*.sh
git diff --check
```

The full reasoning behind each command—including the corrected branching path
and a standalone conflict demonstration—is in the [project report](report.md).
