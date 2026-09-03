---
name: code-comments
description: "Comment standards and cleanup: a comment exists only to say what the code cannot: the why, the constraint, the trap. It never restates the what. Bans narration comments, section banners, numbered step headers, aligned columns, corner-bracket quotes, changelog lines, commented-out code, and session talk like 'as requested'. Scans the working-tree changes by default, a path, or the whole project, then keeps, rewrites, or deletes each comment and fixes comments the code change made stale. Use when writing code, reviewing comments, or cleaning up existing comments."
argument-hint: "[path | --all] [--report-only]"
---

# Code Comments

A comment is for the maintainer, not for decorating the code. Its value is the understanding it saves minus the cost of keeping it true. Before writing or keeping one, ask: **what does the reader lose if this comment is deleted?** If the answer is nothing, delete it. If the answer is "they would misread the code", keep it and make it say exactly that.

## Comment when

1. **The why is not obvious**: a workaround, a historical constraint, a performance trade-off, why the simpler approach fails.
2. **The code cannot explain itself**: a dense algorithm, a regex, bit manipulation, a state machine. State the intent and the invariant, not the steps.
3. **A constraint is implicit**: calling order, concurrency assumptions, immutability, units, an external fact the code depends on (an API quirk, a file format detail).
4. **A public API has behavior callers must know**: edge cases, side effects, error conditions, return contracts. This is the docstring's job; follow the project's docstring convention (Google, NumPy, JSDoc, rustdoc, godoc).
5. **Work is deliberately left**: `TODO`/`FIXME` with a reason and an owner, issue number, or date. Never a bare `TODO`.

## Do not comment when

- **The code says it**: `// sum the items` above `sum(items)`.
- **The name says it**: `// compute the total price` above `computeTotalPrice()`. If the name does not say it, fix the name (see the code-naming skill).
- **It is a banner or a step header**: `// ===== helpers =====`, `// ----- part 2 -----`, `// 1. validate input`, `// Step 3`. Structure comes from functions and names, not from banners. Numbered steps are allowed only inside one algorithm where the order is the point.
- **It is a changelog**: `// 2024-01-01 fixed the bug`, `// added by X`. Git holds history.
- **It narrates**: `i++  // increment i`, `# import libraries`, `# return result`, `# end of loop`.
- **It talks to the reviewer or the user**: `// as requested`, `// fixed per review`, `// changed from map to loop`, `// now uses X`. These are afterimages of the session; see the no-afterimage skill.
- **It excuses**: `// hacky`, `// not sure this is right`. Fix it or ask; do not annotate it.
- **It is code**: commented-out code is deleted, always.

## Format

- No numbered headers, no corner-bracket quotes around identifiers (`「cache」` becomes `cache`), no tab- or equals-aligned columns, no asterisk, pipe, dash, or tilde frames, no emoji.
- A block comment sits directly above the code it explains with a blank line before it. An end-of-line comment attaches to its own statement only.
- One comment says one thing, directly: `// binary search: items are sorted and can reach tens of thousands`.
- Docstrings tell callers what it is and how to use it. Inline comments tell maintainers why it is written this way. Do not mix the jobs.
- When you change code, re-read every comment in the function and fix anything that no longer holds. A stale comment is worse than none.

## Scope

The user's words win. With no instruction, use the first row.

| User says | Target |
|---|---|
| nothing, "this change", "my changes" | Working tree: `git diff`, `git diff --cached`, untracked files from `git status --porcelain`. If the tree is clean, the commits on this branch that are not on the default branch. Include unchanged comments in the changed functions, since the change may have made them stale. |
| a path, glob, or module | Those files. |
| "whole project", `--all` | Every source file tracked by git except vendored and generated code. |

## Execution

1. **Read the files in full.** A comment is judged against the code beside it and the names around it.
2. **Classify every comment** in the target as one of: keep, rewrite (say the why, drop the what), delete, or stale (the code changed under it). Use the sections above; when unsure, apply the deletion test.
3. **Mode.** Up to about 15 files: do it yourself. Larger: split by directory into chunks of about 15 files and launch one subagent (type `general-purpose`, instructed to stay read-only) per chunk, all in one message, with the prompt below. Merge, dedupe, and re-verify any row you cannot confirm yourself.
4. **Fix** when the target is code produced in this session or the user asked for fixes; otherwise report and offer. `--report-only` always stops at the report. Up to about 10 findings, edit yourself; beyond that, hand each file to a `general-purpose` subagent with its rows and this skill's rules.
5. **Verify.** Run the formatter and linter if present (some lint rules require docstrings). Re-read edited regions on disk. `git diff` to confirm only comments changed, unless a stale comment revealed a real code bug, which you report separately rather than fixing silently.

Scan subagent prompt:

```
Read-only task. Do not edit anything.
Read each file below in full and classify every comment and docstring as keep / rewrite /
delete / stale, using these rules: <paste the Comment-when, Do-not-comment-when, and Format
sections>. Report only rewrite, delete, and stale.
Files: <list>
Return one markdown table row per finding:
| file:line | classification | quoted comment | replacement text, or "delete" |
Return the single word "none" if nothing is found.
```

## Report

```
| # | File:Line | Action | Comment | Replacement |
```

One summary line: `N to rewrite, M to delete, K stale across L files.` After fixing, add an `Outcome` column.
