---
name: code-comments
description: "Comment standards and cleanup: a comment exists only to say what the code cannot (the why, the constraint, the trap), never to restate the what. Bans narration, section banners, numbered step headers, aligned columns, changelog lines, commented-out code, and session talk like 'as requested'. Scans the working-tree changes by default, a path, or the whole project; keeps, rewrites, or deletes each comment and fixes comments the code change made stale. Use when writing code, reviewing comments, or cleaning up existing comments."
argument-hint: "[path | --all] [--report-only]"
---

# Code Comments

A comment is for the maintainer. Its value is the understanding it saves minus the cost of keeping it true. The test for every comment: **what does the reader lose if it is deleted?** Nothing: delete it. A misreading of the code: keep it and make it say exactly that.

## Comment when

- **The why is not obvious**: a workaround, a historical constraint, a trade-off, why the simpler approach fails.
- **The code cannot explain itself**: a dense algorithm, a regex, bit manipulation, a state machine. State the intent and the invariant, not the steps.
- **A constraint is implicit**: call order, concurrency assumptions, units, an external quirk the code depends on.
- **A public API has behavior callers must know**: edge cases, side effects, errors, return contracts. That is the docstring's job; follow the project's docstring convention.
- **Work is deliberately left**: `TODO`/`FIXME` with a reason and an owner, issue, or date. Never a bare `TODO`.

## Do not comment when

- **The code or the name already says it**: `// sum the items` above `sum(items)`. If the name does not say it, fix the name.
- **It is a banner or step header**: `// ===== helpers =====`, `// Step 3`, `// 1. validate`. Structure comes from functions and names. Numbered steps are allowed only inside one algorithm where order is the point.
- **It is a changelog**: `// 2024-01-01 fixed`, `// added by X`. Git holds history.
- **It narrates**: `i++ // increment i`, `# import libraries`, `# return result`.
- **It talks to the reviewer**: `// as requested`, `// fixed per review`, `// changed from map to loop`, `// now uses X`.
- **It excuses**: `// hacky`, `// not sure this is right`. Fix it or ask.
- **It is code**: commented-out code is deleted, always.

## Format

- No numbered headers, no bracket quotes around identifiers, no aligned columns, no asterisk, pipe, dash, or tilde frames, no emoji.
- A block comment sits directly above its code with a blank line before it. An end-of-line comment attaches to its own statement only.
- One comment says one thing, directly: `// binary search: items are sorted and can reach tens of thousands`.
- Docstrings tell callers what it is and how to use it. Inline comments tell maintainers why it is written this way.
- After changing code, re-read every comment in the function and fix anything that no longer holds. A stale comment is worse than none.

## Scope

The user's words win. With no instruction, use the first row.

| User says | Target |
|---|---|
| nothing, "this change", "my changes" | Working tree: `git diff`, `git diff --cached`, untracked files. If clean, the commits on this branch not on the default branch. Include unchanged comments in changed functions, since the change may have made them stale. |
| a path, glob, or module | Those files. |
| "whole project", `--all` | Every source file tracked by git except vendored and generated code. |

## Execution

1. **Read each file in full.** A comment is judged against the code beside it and the names around it. Large targets: work directory by directory.
2. **Classify every comment**: keep, rewrite (say the why, drop the what), delete, or stale. When unsure, apply the deletion test.
3. **Fix** when the target is code produced in this session or the user asked for fixes; otherwise report and offer. `--report-only` always stops at the report.
4. **Verify.** Run the formatter and linter if present. Re-read edited regions on disk. `git diff` to confirm only comments changed. A stale comment that reveals a real code bug is reported separately, not fixed silently.

## Report

```
| # | File:Line | Action | Comment | Replacement |
```

One summary line: `N to rewrite, M to delete, K stale across L files.` After fixing, add an `Outcome` column.
