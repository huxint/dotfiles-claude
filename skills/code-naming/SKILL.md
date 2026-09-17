---
name: code-naming
description: "Naming pass: judge every function, variable, class, constant, and file name by the call-site test (does a reader know what it means where it appears, without opening the implementation) and rename safely across every reference. Catches filler (data/info/helper/manager/utils), action chains, implementation details in names, repeated context, vocabulary drift, misleading side effects, and over-abbreviation. Use when names are the subject: rename this, review the naming, 命名, 起名, 这个名字不好, 帮我改名, or when a task's deliverable is a rename."
argument-hint: "[path | --all] [--report-only]"
---

# Code Naming

A name passes the **call-site test** when a reader knows what it means where it appears, without opening the implementation. Pick the shortest name that passes. Every rule below is a way of failing that test.

## Boundaries

- A name that reveals mixed responsibilities is a design finding. Report it; a naming pass does not restructure.
- Public APIs, CLI flags, environment variables, wire fields, storage keys, and schema names are contracts with outside consumers. Propose the name and its impact; change it only when the task explicitly authorizes the contract change.

## Target

- A path, glob, or module: names defined there. `--all`: every tracked source file, skipping generated and vendored code.
- Otherwise the working tree: names introduced or changed in `git diff`, `git diff --cached`, and untracked files. Clean tree: compare the branch with the merge base of its base branch, and report if the base cannot be resolved or the comparison is empty.
- Invoked during a coding task: the names that task introduces or touches, including locals and filenames.

A review request, or `--report-only`, produces findings without editing. A rename or cleanup request, or an active coding task, applies the renames.

## Rules

- **Say the concept, not the container.** `data`, `info`, `item`, `helper`, `manager`, `utils`, `process`, `handle` name nothing. Replace with the actual concept unless the enclosing scope already supplies it (`for item in cart.items` is fine).
- **Say the intent, not the steps.** `applyDiscount` over `processItems`; `loadUserOrFail` over `fetchAndValidateAndReturnUser`. An action chain in a name usually marks a function doing two jobs.
- **Leave implementation out** unless callers choose by it. `userCache` is right when there is also `userStore`; `userHashMap` is not.
- **Do not repeat context.** `Order.status`, not `Order.orderStatus`; `user.email`, not `user.userEmail`.
- **One term per concept.** If the module says `fetch`, do not introduce `retrieve` for the same thing. Follow neighboring casing and verb conventions; names imposed by a framework or protocol stay as they are.
- **Name the current role.** `newParser`, `parserV2`, `fixedCalc`, `tmpResult` mean something only to whoever was there when the old one existed. Real protocol versions and compatibility aliases keep their numbers.
- **Abbreviate only inside a tight scope.** `i`, `ctx`, `req`, and established project shorthand are fine locally. A name that crosses a file or module boundary spells itself out.
- **Booleans state a positive fact.** `isActive`, `canEdit`, `hasChildren`; not `notDisabled`, not `flag`.
- **Functions name the action or the return value.** Make caller-visible side effects visible the way the project does (`save`, `emit`, `ensure`).
- **Variables carry cardinality and units.** `users` is a collection, `user` is one; `timeoutMs`, not `timeout`. Constants name the role: `MAX_RETRY_COUNT`, not `THREE`.
- **Types and files name their responsibility** and follow neighboring conventions.

## Workflow

1. **Learn the vocabulary.** Read the target definitions and representative call sites. Note the domain terms, casing, verb conventions, and names fixed by external contracts.
2. **Judge every target name at its call site.** Propose a replacement only when it reads better in context; a rename that is merely different is noise.
3. **Rename across every reference.** Prefer the language's symbol-aware rename. Then search with `rg` for what it misses: imports, reflective lookups, string keys, tests, config, docs. Read each string match before touching it; the same spelling may be a different symbol or a serialized contract. Check the new name for collisions in its scope.
4. **Verify.** Run the project's compile, type, lint, and test checks. Search once more for the old name, explain any retained occurrence, and read the diff for changes beyond the intended renames.

## Report

Scans: `File:Line | Name | Problem | Proposed | Contract impact | Outcome`, then a summary of what was renamed, what was only proposed, the checks that ran, and any unresolved references. A rename done inside a larger task is reported in that task's normal summary.
