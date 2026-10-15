---
name: code-naming
description: "Review and improve code names for clarity at their call sites. Use when naming is the task: a naming review, a requested rename, or choosing identifiers. Do not invoke merely because ordinary coding introduces or changes names."
argument-hint: "[path | --all] [--report-only]"
---

# Code Naming

Choose identifiers and file names that reveal their role in context. A reader should understand a name where it appears without opening the implementation. Prefer the shortest name that stays clear.

## Scope

- Use the requested paths, globs, or modules. `--all` covers tracked source files, excluding generated and vendored code.
- When invoked within a larger task, cover names that task introduces or changes.
- Otherwise review staged, unstaged, and untracked changes. In a clean tree, compare the branch with the merge base of its known base branch. If the base is unknown or the diff is empty, report that limit.

Reviews and `--report-only` produce findings. Rename and cleanup requests authorize edits.

## Naming rules

- **Name the domain concept.** Words such as `data`, `helper`, and `manager` are filler when they hide a more precise role. They are fine when the local context supplies the meaning.
- **Name intent.** Describe the operation or result. A chain of verbs often exposes mixed responsibilities; a longer name will not fix that design.
- **Remove redundant detail.** Prefer `Order.status` to `Order.orderStatus`. Include implementation details only when callers need the distinction.
- **Name the current role.** Avoid draft labels such as `newParser` or `fixedResult`. Keep versions that identify a real protocol or compatibility requirement.
- **Use consistent vocabulary.** Follow the project's domain terms, casing, and verb conventions. Preserve names imposed by frameworks and protocols.
- **Use familiar abbreviations.** Reserve temporary shorthand for small scopes; use names the intended readers recognize across module boundaries.
- **Make facts and effects clear.** Avoid double negatives in booleans. Expose caller-visible actions, cardinality, and units where they matter.

Public APIs, CLI flags, environment variables, serialized fields, and storage keys are external contracts. Change them only when the task includes that contract change; otherwise propose the rename and explain its impact. Report design problems outside the task instead of expanding a naming pass into a refactor.

## Workflow

1. Read definitions and representative call sites to learn the vocabulary and contracts. Rename only when the replacement improves clarity.
2. Update every reference, preferably with a symbol-aware rename. Search imports, tests, configuration, docs, and dynamic string references; inspect each match before changing it. Check for collisions.
3. Run relevant type, build, lint, or existing test checks. Search for the old name, account for retained uses, and review the diff for unrelated changes. Do not add tests solely for a rename.

For reviews, give the location, current name, proposed name, and reason. Mention contract impact where relevant. For edits, summarize the renames, verification, and any unresolved references.
