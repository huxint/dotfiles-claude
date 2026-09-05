---
name: slopscan
description: "Review code for AI-generated anti-patterns and fix their causes when requested. Use for code reviews, cleanup, de-slopping, or checks before a commit or PR."
argument-hint: "[path | --all] [--report-only]"
---

# Slopscan

Judge a pattern against the **task's requirements, actual behavior, and local conventions**. A finding needs a concrete consequence; resemblance to generated code is only a search clue.

For every scan, read the [check catalogue](references/checks.md) before triage. It contains the categories, evidence to seek, and legitimate exceptions. Apply every category to the target; record any coverage limits.

## Scope and mode

- A requested path, glob, or module selects those files. `--all` selects tracked source files, excluding generated and vendored code.
- Otherwise collect staged, unstaged, and untracked changes with `git diff`, `git diff --cached`, and `git status --short`.
- If the tree is clean, resolve the base branch from the task or repository metadata and compare from its merge base with HEAD. Report an unresolved base or an empty comparison.

Reviews produce findings unless fixes are also requested; `--report-only` always leaves target files unchanged. Otherwise fix code being written in the active task or cleanup the user requested.

## Workflow

1. **Collect context.** List target files, read each in full, and trace relevant producers, callers, tests, and contracts. Read manifests and lockfiles when dependency behavior matters. For large targets, finish one module at a time and track coverage.
2. **Triage every category.** Apply the catalogue to each target. Read each candidate's surrounding behavior and applicable exceptions. Retain findings supported by evidence; an established style is not evidence that a correctness defect is acceptable.
3. **Report concrete findings.** Use the format below. For authorized cleanup, show the findings and proceed with fixes.
4. **Fix causes.** Work from highest consequence downward. Trace a symptom to the code that owns the violated contract and make the smallest complete repair. Resolve uncertain behavior from available evidence; report remaining ambiguity with the specific decision needed.
5. **Verify.** Run formatting, lint, build, and test checks appropriate to the changes. Re-read edited regions on disk and inspect the diff for unrelated edits. Every finding must have an outcome and every validation claim must name its evidence or limitation.

## Report

Use a table with these columns:

`Severity | File:Line | Check | Evidence and consequence | Fix | Outcome`

Sort by severity, then file. Assign severity from the actual consequence:

- **High:** incorrect behavior, hidden failures, fabricated required data, an invalid API call, or a demonstrated security risk.
- **Moderate:** complexity, duplication, or misleading structure that creates a concrete maintenance risk.
- **Low:** avoidable noise or inconsistent style without a demonstrated behavioral defect.

State the occurrence precisely: “Missing `amount` becomes 0.0, so malformed input posts a zero payment.” Give a repair for that occurrence.

Outcomes distinguish reported findings, completed fixes, and unresolved items with their reasons. Summarize counts, scope, checks run, and limitations. With no findings, state the inspected scope and catalogue coverage; an incomplete scan remains incomplete.
