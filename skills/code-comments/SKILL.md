---
name: code-comments
description: "Write, review, or clean up code comments and docstrings. Use when documentation inside code is the requested deliverable or the focus of a review. Not for READMEs, external documentation, or routine code edits that merely touch comments."
argument-hint: "[path | --all] [--report-only]"
---

# Code Comments

A comment earns its place by explaining something the code cannot. Apply the **deletion test**: what would a reader misunderstand if this comment vanished? Keep that information in the fewest words.

## Scope

- Use the requested paths, globs, or modules. `--all` covers tracked source files, excluding generated and vendored code.
- When invoked within a larger task, cover comments and docstrings added or affected by that task, including those whose code or signatures changed.
- Otherwise review staged, unstaged, and untracked changes. In a clean tree, compare the branch with the merge base of its known base branch. If the base is unknown or the diff is empty, report that limit.

Reviews and `--report-only` produce findings. Writing and cleanup requests authorize edits.

## Keep

- **Rationale:** constraints, tradeoffs, and reasons for a workaround.
- **Invariants:** assumptions an algorithm, state machine, or synchronization scheme relies on.
- **Caller contracts:** units, ordering, side effects, errors, and edge cases callers need to know. Use the project's docstring convention.
- **Actionable TODOs:** the remaining work and why it is deferred. Preserve real issue links or ownership; never invent them.
- **Required material:** legal notices, tool directives, and useful documentation examples.

## Delete or rewrite

- Narration that repeats a statement, signature, or loop.
- Decorative banners, empty section labels, and vague apologies.
- Draft history and session remarks such as "as requested" or "fixed per review". Keep history only when it explains a current constraint.
- Commented-out implementations that belong in version control.
- Claims that no longer match the intended behavior.

Write direct sentences close to the code they explain. Avoid framing such as "Note that" or "This function". Follow the surrounding comment and docstring style.

## Workflow

1. Read the code before judging the comments. Establish the behavior and the information readers need.
2. Keep, rewrite, or remove each comment using the deletion test. A conflict between code and comment may reveal a bug; establish the intended contract before rewriting either.
3. Keep edits within scope. Report naming, design, or behavior problems separately unless the task includes their repair.
4. Review the diff for accidental code changes. Run relevant formatting, lint, documentation, or doctest checks; prose-only edits do not require the application test suite.

For reviews, give the location, problem, and proposed wording or deletion. For edits, summarize meaningful changes, verification, and any unresolved claims.
