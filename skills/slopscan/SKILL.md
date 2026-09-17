---
name: slopscan
description: "Review a diff, path, or whole project for AI-generated anti-patterns: swallowed errors, fabricated defaults, band-aid patches, dead code and stubs, narration comments, speculative abstraction, forced consolidation, style drift, fragile duplication, hallucinated APIs, scope creep, test slop, naming slop, security and correctness smells. Reports a severity-ranked table and fixes findings at their cause when asked. Use when the user says slopscan, de-slop, review this code, 审查一下, 检查有没有 slop, 看看 AI 味, or wants a sanity check of code before a commit or PR."
argument-hint: "[path | --all] [--report-only]"
---

# Slopscan

Slop is code whose shape comes from the generator instead of the requirement. Looking generated is only a search clue. A finding needs three things: a location, the requirement or convention it violates, and a concrete consequence. Judge every candidate against the task's requirements, the actual behavior, and the local conventions.

Read the [check catalogue](references/checks.md) before triage; it lists the evidence to look for and the legitimate exceptions for each category.

## Target

- A path, glob, or module selects those files. `--all` selects every tracked source file, skipping generated and vendored code.
- Otherwise the working tree: `git diff`, `git diff --cached`, and untracked files from `git status --short`. If the tree is clean, compare the branch with the merge base of its base branch; report it when the base cannot be resolved or the comparison is empty.

A review request, or `--report-only`, produces the table without editing. A fix or cleanup request, or an active coding task, fixes the findings after showing the table.

## Checks

One line per category; evidence and exceptions live in the catalogue.

- **A. Silent failure and fabricated data.** Swallowed exceptions, catch-log-and-succeed, required fields defaulted (`amount or 0`, `timestamp or now()`), error sentinels nobody checks.
- **B. Band-aid patches.** Consumer-side cleanup for a producer's bug, input-specific branches, magic offsets, tests adjusted to a defect.
- **C. Dead code and stubs.** Unreachable branches, unused imports and config, abandoned duplicate implementations, commented-out attempts, `pass  # TODO` on a required path.
- **D. Narration comments.** Comments that restate the next line or the signature, banners, changelog lines, commented-out code, "as requested".
- **E. Speculative abstraction.** One-entry registries, one-strategy factories, pass-through wrappers, options nobody passes, utilities that duplicate a dependency.
- **F. Forced consolidation.** Mode flags selecting unrelated operations, kitchen-sink modules, one generic processor coupling independent features.
- **G. Style drift.** A second HTTP client, a different error idiom, deprecated APIs, formatting sweeps outside the task.
- **H. Fragile duplication.** Parallel lists, repeated counts and magic strings, copied logic that must change together and will not.
- **I. Hallucinated or misused APIs.** Symbols, arguments, or versions absent from the lockfile; `strip` used as prefix removal, an in-place sort's return value, an unawaited coroutine.
- **J. Scope creep.** Changes the task did not ask for and does not need.
- **K. Test slop.** Vacuous or presence-only asserts, expectations copied from the implementation, mocks replacing the subject, expectations bent to a defect, `sleep` as synchronization.
- **L. Naming slop.** `data`, `info`, `helper`, `utils`, `manager` naming nothing; `newX`, `xV2`, `fixedY`; a name that contradicts what the function does.
- **M. Security and correctness.** Untrusted input reaching SQL, shell, HTML, or eval; embedded credentials, disabled TLS checks; mutable defaults, races, blocking calls in async paths, float equality, string comparison of versions.
- **N. Verbosity.** Redundant boolean branches, needless nesting, `# type: ignore` hiding a real mismatch, decorative output.

## Workflow

1. **Collect context.** List the target files and read each in full. Trace producers, callers, tests, and contracts for anything suspicious; read the lockfile when a dependency's behavior matters. On a large target, finish one module before starting the next and keep a coverage list.
2. **Triage every category against every target.** Read around each candidate and apply the catalogue's exceptions. An established local style does not excuse a correctness defect.
3. **Report** in the table below. When fixes are authorized, show the table first, then fix.
4. **Fix at the cause**, highest severity first. Trace the symptom to the code that owns the violated contract and make the smallest complete repair. When the intended behavior is unclear, decide from the evidence and record the decision; when it cannot be decided, report the exact question.
5. **Verify.** Format, lint, build, and test the way the project does. Re-read the edited regions and check the diff for unrelated edits. Every finding gets an outcome; every claim of verification names its evidence.

## Report

`Severity | File:Line | Check | Evidence and consequence | Fix | Outcome`

Sort by severity, then file. Severity comes from the consequence, not from how generated the code looks:

- **High:** wrong behavior, hidden failure, fabricated required data, an invalid API call, or a demonstrated security risk.
- **Moderate:** complexity, duplication, or misleading structure with a concrete maintenance risk.
- **Low:** noise or inconsistent style with no behavioral defect.

Write the consequence as an occurrence: "Missing `amount` becomes 0.0, so malformed input posts a zero payment." Give the repair for that occurrence.

Close with counts, the scope inspected, the categories checked, and the limits (files skipped, APIs that could not be verified). No findings is a valid result; state what was inspected. An incomplete scan says it is incomplete.
