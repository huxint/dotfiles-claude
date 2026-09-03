---
name: code-naming
description: "Naming standards and renames: function, variable, class, constant, and file names must tell the reader what the thing is at first glance, in their current context, without reading the implementation. Bans action chains, filler words (data/info/helper/manager/utils), implementation details in names, repeated context, session-relative names (newX, xV2, fixedY), vocabulary drift, and over-abbreviation. Scans the working-tree changes by default, a path, or the whole project, then renames safely across all references. Use when writing new code, refactoring, or reviewing names."
argument-hint: "[path | --all] [--report-only]"
---

# Code Naming

A good name passes one test: **the reader knows what it is and what it does at first glance, in the place they meet it, without reading the implementation.** A name is the most-read comment in the codebase and the only one that cannot go stale silently, because every use repeats it.

## Three principles

1. **Concise**: two to four words. Functions are verb plus object; variables are adjective plus noun. If the name cannot fit, the thing has more than one job. Splitting it is the fix, not adding words.
2. **Precise in context**: it says exactly what it means where it is used. `status` inside `class Order` is precise; `orderStatus` there is noise; `status` as a module-level global is vague.
3. **Consistent with the project's vocabulary**: one concept, one word. If the codebase says `account`, new code does not say `user`, `member`, or `customer` for the same thing. Read the neighbors and reuse their words, their casing convention, and their verb set (`fetch` vs `load` vs `get`).

## Anti-patterns

- **Action chains**: `validateAndProcessAndSaveUser`. Split into single-purpose functions and name each.
- **Filler words**: `userData`, `userInfo`, `userHelper`, `userManager`, `userUtils`, `resultObj`, `tempValue`. Delete the filler and see if the name still works; it usually does.
- **Repeated context**: `orderStatus` in `Order`, `paymentProcessor` in `payment.go`, `UserService.getUserById`.
- **Implementation in the name**: `getUserFromDatabaseById`, `loadConfigFromJsonFile`, `sortWithQuicksort`. The source, format, or algorithm is internal unless the caller's decision hinges on it.
- **Mechanism instead of intent**: `processItems`, `handleData`, `doWork`, `run`. The name must say what happens: `applyDiscount`, `dedupeOrders`.
- **Session-relative names**: `newParser`, `parserV2`, `oldHandler`, `fixedCalc`, `simpleVersion`, `betterX`, `tempFix`. They only mean something relative to a version the reader never saw. See the no-afterimage skill.
- **Vague words**: `temp`, `data`, `stuff`, `thing`, `value`, `x1`/`x2`, `foo`.
- **Over-abbreviation**: `usrCnt`, `cfgPrms`, `mgr`. An abbreviation must be instantly clear to every reader or it is spelled out. Established ones (`id`, `url`, `db`, `ctx`, `i` in a loop) are fine.
- **Misleading names**: `getUsers` that hits the network and caches, `isValid` that mutates, `list` holding a set, `count` holding a boolean, a plural for one item.
- **Double negatives**: `isNotUnavailable`, `disableFlagEnabled`.
- **Convention breaks**: camelCase in a snake_case module, `PascalCase` for a function, a file named unlike its siblings.

## By kind

**Functions and methods**
- Start with a verb that says what happens: `get`, `create`, `update`, `delete`, `send`, `parse`, `render`, `validate`.
- Booleans read as a question: `isExpired`, `hasPermission`, `canEdit`, `shouldRetry`.
- Other returns say what comes back: `totalPrice()`, `parseTimestamp()`.
- Side effects show in the name: `save` is not `validate`; `remove` is not `check`; a `get` does not write.

**Variables**
- Nouns with accurate number: `items` is a collection, `item` is one.
- Scope sets length: `i`, `n`, `buf` are fine inside five lines. Anything crossing a function or module boundary stands alone.
- Booleans state a fact: `isActive`, `hasChildren`, never `flag`, `mark`, `ok2`.

**Constants and enums**
- Name the meaning, not the literal: `MAX_RETRY_COUNT = 3`, never `THREE` or `NUMBER_3`.

**Classes, types, modules, files**
- Nouns that answer "what is it": `PriceCalculator`, `RetryPolicy`. If you cannot name it, it has more than one responsibility.
- A file is named for what it contains, following the project's pattern (`user_repository.py`, `UserRepository.ts`), never for its history (`utils2.py`, `parser_new.py`).

## Scope

The user's words win. With no instruction, use the first row.

| User says | Target |
|---|---|
| nothing, "this change", "my changes" | Names introduced or changed in the working tree: `git diff`, `git diff --cached`, untracked files. If the tree is clean, the commits on this branch not on the default branch. |
| a path, glob, or module | All names defined in those files. |
| "whole project", `--all` | Every source file tracked by git except vendored and generated code. |

## Execution

1. **Learn the vocabulary first.** Skim the module and its neighbors for the words, casing, and verbs already in use. A name is judged against them.
2. **List the names** defined in the target: functions, methods, classes, variables that cross a scope boundary, constants, files. Apply the test and the anti-pattern list to each.
3. **Mode.** Up to about 15 files: do it yourself. Larger: split by directory into chunks of about 15 files and launch one subagent (type `general-purpose`, instructed to stay read-only) per chunk, all in one message, with the prompt below. Merge, dedupe, and re-verify.
4. **Fix** when the target is code produced in this session or the user asked; otherwise report and offer. `--report-only` always stops at the report.
5. **Rename safely.**
   - Confirm the new name is free: grep the project for it first.
   - Update every reference: code, tests, strings that carry the name (log messages, error text, serialized keys only if not part of a wire or storage format), docs, config, CLI flags. Use the language's rename tooling when available; otherwise grep with word boundaries and read each hit before editing.
   - **Public or exported names** (package API, HTTP fields, CLI flags, database columns, env vars, event names) break consumers. Report them with the proposed name and do not rename unless the user asks.
   - No compatibility alias for the old name in code that has no external users.
   - Up to about 10 renames: do them yourself. Beyond that, hand each file group to a `general-purpose` subagent with its rows, and run the full test suite once at the end rather than per agent.
6. **Verify.** Compile or type-check, run linter and tests, grep once more for the old name including in strings and docs, re-read edited regions, and `git diff` to confirm only renames changed.

Scan subagent prompt:

```
Read-only task. Do not edit anything.
Learn the module's existing vocabulary and casing from the files below, then evaluate every
function, method, class, constant, file name, and any variable that crosses a scope boundary
against these rules: <paste the Three principles, Anti-patterns, and By-kind sections>.
Files: <list>
Return one markdown table row per name that fails:
| file:line | current name | kind | anti-pattern | proposed name | public/exported? (yes/no) |
Return the single word "none" if all names pass.
```

## Report

```
| # | File:Line | Name | Problem | Proposed | Public? |
```

One summary line: `N names across L files, K of them public.` After fixing, add an `Outcome` column: `renamed`, or `reported: public`, or `skipped: <reason>`.
