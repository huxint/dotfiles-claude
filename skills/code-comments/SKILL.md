---
name: code-comments
description: "Comment pass: keep, rewrite, or delete each comment by the deletion test (what would a reader misunderstand if it vanished). Keeps rationale, invariants, caller contracts, and owned TODOs; removes narration, restated signatures, banners, changelog lines, commented-out code, and session talk like 'as requested'. Also fixes comments and docstrings that a code change made stale. Use when comments or docstrings are the subject: add comments, review the comments, clean up the comments, 注释, 写注释, 注释太多了, docstring, or when the deliverable is documentation inside code. Not for READMEs or external docs."
argument-hint: "[path | --all] [--report-only]"
---

# Code Comments

A comment earns its place by saying what the code cannot. Apply the **deletion test** to each one: if it vanished, what would the reader misunderstand? Keep that information in the fewest words; delete everything else.

## Boundaries

- A comment that is stale because the code is wrong, not the comment: report the suspected bug; fix it only if it belongs to the active task.
- A comment that would be unnecessary with a better name: report it as a naming finding, or rename if the task allows.

## Target

- A path, glob, or module: comments and docstrings in those files. `--all`: every tracked source file, skipping generated and vendored code.
- Otherwise the working tree: comments added or affected by `git diff`, `git diff --cached`, and untracked files, including unchanged comments in changed functions and any docstring whose signature changed. Clean tree: compare the branch with the merge base of its base branch, and report if the base cannot be resolved or the comparison is empty.
- Invoked during a coding task: the comments that task adds or touches.

A review request, or `--report-only`, produces findings without editing. A cleanup or writing request, or an active coding task, applies the changes.

## Keep

- **Rationale.** The trade-off, workaround, or constraint that makes the obvious approach wrong. "Retry only on 429: the upstream returns 500 for validation errors."
- **Invariants.** What an algorithm, regex, state machine, or lock assumes. Number the steps only when the order itself is the point.
- **Contracts.** Units, call order, side effects, errors, and edge cases a caller needs. Public contracts go in docstrings in the project's convention.
- **Deferred work** with a concrete reason and a real owner, issue, or date. Never invent one; if the context is missing, say so in the report instead.
- **Legal notices, tool directives, and doc examples** that serve an actual requirement.

## Delete or rewrite

- **Narration.** The comment restates the next line, the signature, or the loop. Delete.
- **Banners and section headers** inside a function. Delete; split the function if it needs a map.
- **Changelog and session remarks.** "Changed in v3", "as requested", "fixed per review", author tags. Delete; version control has them.
- **Commented-out code.** Delete; version control has it.
- **Vague apologies.** "Hacky, sorry" becomes the concrete constraint, or a report of the unresolved problem.
- **Stale claims.** The comment describes behavior the code no longer has. Establish the current behavior first, then rewrite; never patch a stale comment by guessing.

## Form

Plain sentences, one thought per comment, no framing ("Note that", "This function"). Block comments sit directly above their code with a blank line before them. End-of-line comments attach only to their own statement. Follow the project's docstring style for public contracts.

## Workflow

1. **Read the code first.** For each target, read the file and establish what the code does before judging what a comment says about it.
2. **Classify every comment**: keep, rewrite, or delete. Mark stale claims explicitly.
3. **Edit within scope.** Comment changes only. A bug or a naming problem is reported separately unless its repair belongs to the active task.
4. **Verify.** Run the project's format, lint, and doc checks. Re-read the edited regions and read the diff for accidental code changes.

## Report

Scans: `File:Line | Action | Reason | Replacement | Outcome`, then counts of rewrites, deletions, and stale claims, the checks that ran, and any limits. Comment work done inside a larger task is reported in that task's normal summary.
