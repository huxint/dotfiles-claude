---
name: code-comments
description: "Comment standards for writing code, reviewing comments, or cleaning up stale and redundant comments."
argument-hint: "[path | --all] [--report-only]"
---

# Code Comments

A comment earns its place by explaining something the code cannot. Apply the **deletion test**: what would the reader misunderstand if this comment disappeared? Keep that information; remove the rest.

## Scope and mode

While writing code, apply the rules to comments you add or affect. For a scan:

- A requested path, glob, or module selects those files. `--all` selects tracked source files, excluding generated and vendored code.
- Otherwise collect staged, unstaged, and untracked changes with `git diff`, `git diff --cached`, and `git status --short`.
- If the tree is clean, resolve the base branch from the task or repository metadata and compare from its merge base with HEAD. Report an unresolved base or an empty comparison.

Reviews produce findings unless fixes are also requested; `--report-only` always leaves target files unchanged. Otherwise fix code being written in the active task or cleanup the user requested.

## Workflow

1. **Read context.** Read each target file. For changed code, include unchanged comments in affected functions and API documentation. Establish the behavior each comment describes.
2. **Classify.** Apply the deletion test and rules below to every target comment: keep, rewrite, or delete. Mark stale claims explicitly; establish the correct behavior before rewriting them.
3. **Edit within scope.** Apply authorized comment changes. Report a suspected code bug or a naming problem separately unless its repair belongs to the active task.
4. **Verify.** Run applicable formatting, lint, or documentation checks. Re-read edited regions on disk and inspect the diff for unintended code changes. Every finding must be fixed or reported with a reason.

## Content and form

Keep these meanings beside the code they explain:

- **Rationale:** a trade-off, workaround, or constraint that makes the obvious approach unsuitable.
- **Invariants:** intent behind an algorithm, regex, state machine, or concurrency assumption. Explain ordered steps only when their order is itself significant.
- **Contracts:** units, call order, side effects, errors, and edge cases callers need. Put public contracts in docstrings using the project's convention.
- **Deferred work:** a concrete reason plus a real owner, issue, or date. Flag missing context rather than inventing it.

Delete narration, repeated signatures, decorative banners, changelog entries, session remarks, and abandoned code. Preserve legal notices, tool directives, and documentation examples that serve an actual requirement. Replace vague apologies with the concrete constraint, or report the unresolved issue.

Use plain, unframed text with one thought per comment. Place block comments directly above their code, separated from preceding code by a blank line; attach end-of-line comments only to their own statement.

## Report

For scans, list actionable findings as `File:Line | Action | Reason | Replacement | Outcome`. Count rewrites, deletions, and stale claims; state which checks ran and any limits. Keep routine comment work within the surrounding task's normal report.
