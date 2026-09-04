---
name: code-naming
description: "Naming standards and renames: function, variable, class, constant, and file names must tell the reader what the thing is at first glance, in context, without reading the implementation. Bans action chains, filler words (data/info/helper/manager/utils), implementation details in names, repeated context, session-relative names (newX, xV2, fixedY), vocabulary drift, and over-abbreviation. Scans the working-tree changes by default, a path, or the whole project, then renames safely across all references. Use when writing new code, refactoring, or reviewing names."
argument-hint: "[path | --all] [--report-only]"
---

# Code Naming

A good name passes one test: **the reader knows what it is and what it does at first glance, where they meet it, without reading the implementation.** A name is the most-read comment in the codebase, and every use repeats it.

## Principles

1. **Concise**: two to four words. Functions are verb plus object; variables are adjective plus noun. If the name cannot fit, the thing has more than one job. Split it; do not add words.
2. **Precise in context**: `status` inside `class Order` is precise; `orderStatus` there is noise; `status` as a module global is vague.
3. **Consistent with the project's vocabulary**: one concept, one word. If the codebase says `account`, new code does not say `user`, `member`, or `customer`. Reuse the neighbors' words, casing, and verb set (`fetch` vs `load` vs `get`).

## Anti-patterns

- **Action chains**: `validateAndProcessAndSaveUser`. Split into single-purpose functions.
- **Filler words**: `userData`, `userInfo`, `userHelper`, `userManager`, `userUtils`, `resultObj`, `tempValue`. Delete the filler; the name usually still works.
- **Repeated context**: `orderStatus` in `Order`, `paymentProcessor` in `payment.go`, `UserService.getUserById`.
- **Implementation in the name**: `getUserFromDatabaseById`, `loadConfigFromJsonFile`, `sortWithQuicksort`. Source, format, and algorithm are internal unless the caller's decision hinges on them.
- **Mechanism instead of intent**: `processItems`, `handleData`, `doWork`, `run`. Say what happens: `applyDiscount`, `dedupeOrders`.
- **Session-relative names**: `newParser`, `parserV2`, `oldHandler`, `fixedCalc`, `simpleVersion`, `betterX`, `tempFix`. They only mean something relative to a version the reader never saw.
- **Vague words**: `temp`, `data`, `stuff`, `thing`, `value`, `x1`/`x2`, `foo`.
- **Over-abbreviation**: `usrCnt`, `cfgPrms`, `mgr`. Established ones (`id`, `url`, `db`, `ctx`, loop `i`) are fine.
- **Misleading names**: `getUsers` that hits the network and caches, `isValid` that mutates, `list` holding a set, a plural for one item.
- **Double negatives**: `isNotUnavailable`, `disableFlagEnabled`.
- **Convention breaks**: camelCase in a snake_case module, `PascalCase` for a function, a file named unlike its siblings.

## By kind

- **Functions**: start with a verb (`get`, `create`, `parse`, `render`, `validate`). Booleans read as a question: `isExpired`, `canEdit`. Other returns say what comes back: `totalPrice()`. Side effects show in the name: `save` is not `validate`; a `get` does not write.
- **Variables**: nouns with accurate number (`items` vs `item`). Scope sets length: `i`, `n`, `buf` are fine inside five lines; anything crossing a function boundary stands alone. Booleans state a fact: `isActive`, never `flag` or `ok2`.
- **Constants**: name the meaning, not the literal: `MAX_RETRY_COUNT = 3`, never `THREE`.
- **Classes, types, files**: nouns answering "what is it": `PriceCalculator`, `RetryPolicy`. Files follow the project's pattern and are named for content, never history (`utils2.py`, `parser_new.py`).

## Scope

The user's words win. With no instruction, use the first row.

| User says | Target |
|---|---|
| nothing, "this change", "my changes" | Names introduced or changed in the working tree: `git diff`, `git diff --cached`, untracked files. If clean, the commits on this branch not on the default branch. |
| a path, glob, or module | All names defined in those files. |
| "whole project", `--all` | Every source file tracked by git except vendored and generated code. |

## Execution

1. **Learn the vocabulary first.** Skim the module and its neighbors for words, casing, and verbs already in use.
2. **List the names** defined in the target: functions, classes, constants, files, and variables that cross a scope boundary. Apply the test and the anti-pattern list to each. Large targets: work directory by directory.
3. **Fix** when the target is code produced in this session or the user asked; otherwise report and offer. `--report-only` always stops at the report.
4. **Rename safely.**
   - Grep the project to confirm the new name is free.
   - Update every reference: code, tests, log and error text, docs, config, CLI flags. Serialized keys only if not part of a wire or storage format. Use the language's rename tooling when available; otherwise grep with word boundaries and read each hit before editing.
   - **Public or exported names** (package API, HTTP fields, CLI flags, database columns, env vars, event names) break consumers. Report with the proposed name; rename only if the user asks.
   - No compatibility alias for the old name when nothing external uses it.
5. **Verify.** Compile or type-check, run linter and tests, grep once more for the old name including strings and docs, and `git diff` to confirm only renames changed.

## Report

```
| # | File:Line | Name | Problem | Proposed | Public? |
```

One summary line: `N names across L files, K of them public.` After fixing, add an `Outcome` column: `renamed`, `reported: public`, or `skipped: <reason>`.
