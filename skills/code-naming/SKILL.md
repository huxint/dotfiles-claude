---
name: code-naming
description: "Naming standards for new code, refactoring, and naming reviews; rename symbols consistently across their references."
argument-hint: "[path | --all] [--report-only]"
---

# Code Naming

A name passes the **call-site test** when a reader knows what it means where it appears, without opening its implementation. Choose the shortest name that passes.

## Scope and mode

- While writing code, apply the rules to introduced or changed names, including locals and filenames.
- A scan of a path, glob, or module covers names defined there. `--all` covers tracked source files, excluding generated and vendored code.
- Otherwise collect staged, unstaged, and untracked changes with `git diff`, `git diff --cached`, and `git status --short`. Review introduced or changed names.
- If the tree is clean, resolve the base branch from the task or repository metadata and compare from its merge base with HEAD. Report an unresolved base or an empty comparison.

Reviews produce findings unless fixes are also requested; `--report-only` always leaves target files unchanged. Otherwise fix code being written in the active task or cleanup the user requested.

## Workflow

1. **Establish vocabulary.** Read target definitions and representative call sites. Identify domain terms, casing, verb conventions, and names imposed by external contracts.
2. **Evaluate every target name.** Apply the call-site test and rules below. Propose a replacement only when it improves meaning in context. A name that exposes mixed responsibilities is a separate design finding; a naming review does not by itself authorize restructuring.
3. **Rename within scope.** For authorized fixes, follow the reference and compatibility rules below. Account for every use of the symbol and check destination names for collisions in the relevant scope.
4. **Verify.** Run applicable compilation, type, lint, and test checks. Search again for the old names, explain any retained occurrences, and inspect the diff for changes beyond the intended renames.

## Name by meaning

- **Vocabulary:** use one term per concept while preserving distinct domain roles. Follow neighboring casing and verbs such as `fetch`, `load`, and `get`.
- **Context:** `Order.status` is precise; a module-global `status` may need qualification. Judge the complete expression callers see.
- **Intent:** prefer `applyDiscount` to `processItems`. Source, format, and algorithm belong in the name when callers choose between them.
- **Specificity:** replace filler such as `data`, `info`, or `helper` with the actual concept when the surrounding scope does not supply it. Long action chains can signal multiple responsibilities.
- **Stable meaning:** name the current role. Session labels such as `newParser` or `fixedCalc` expire; real protocol versions and compatibility names carry lasting meaning.
- **Readable scope:** use established abbreviations and short loop variables locally; names crossing boundaries must stand alone.

By kind:

- Functions name the action or returned value. Make caller-visible side effects clear using the project's conventions.
- Predicates and booleans state a positive fact, such as `isActive` or `canEdit`.
- Variables use nouns with accurate cardinality and meaningful units. Constants name the role of a value, such as `MAX_RETRY_COUNT`.
- Classes, types, and files name their responsibility and follow neighboring conventions.

## References and compatibility

Prefer symbol-aware rename tools. Search with `rg` for imports, reflective lookups, tests, configuration, and documentation the tool may miss; read string matches before changing them. An identical spelling may refer to a different symbol or a serialized contract.

Public APIs, CLI flags, environment variables, wire fields, storage keys, and schema names have consumers beyond local references. Change them only when the active task authorizes the contract change and accounts for those consumers; otherwise report the proposed name and impact. Internal renames without compatibility obligations update callers directly.

## Report

For scans, use `File:Line | Name | Problem | Proposed | Contract impact | Outcome`. Summarize renamed and reported symbols, verification results, and unresolved references. Keep routine naming work within the surrounding task's normal report.
