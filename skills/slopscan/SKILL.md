---
name: slopscan
description: "Scan code for AI-generated anti-patterns (slop): silent error handling, fabricated defaults, band-aid patches, dead code and placeholder stubs, narration comments, speculative abstraction, forced consolidation, style drift, fragile duplication, hallucinated APIs, scope creep, test slop, security smells. Targets the working-tree diff by default, a path, or the whole project; reports a severity-ranked table and fixes findings at their cause. Use when asked to review, clean up, de-slop, or sanity-check code, especially code Claude just wrote, before a commit or PR."
argument-hint: "[path | --all] [--report-only]"
---

# Slopscan

AI-generated code fails in characteristic ways: it hides errors instead of raising them, invents defaults for missing data, patches a symptom where it shows up rather than at its cause, leaves scaffolding from earlier attempts, abstracts for futures nobody asked for, and narrates itself in comments. Each looks reasonable on its own line and is wrong in context.

Slop is judged against **the codebase's own conventions and the task's actual requirement**, never an abstract style. Read the surrounding code before flagging anything.

## Checks

The full catalogue, with examples and legitimate exceptions per check, is in `references/checks.md` in this skill's directory. Read it before scanning.

| | Category | Typical severity |
|---|---|---|
| A | Silent failure and fabricated data | high |
| B | Band-aid patches | moderate to high |
| C | Dead code, leftovers, placeholder stubs | moderate |
| D | Narration comments and doc slop | low |
| E | Speculative abstraction and over-engineering | moderate |
| F | Forced consolidation | moderate |
| G | Consistency and style drift | low |
| H | Fragile duplication | moderate |
| I | Hallucinated or misused APIs | high |
| J | Scope creep | moderate |
| K | Test slop | moderate |
| L | Naming slop | low |
| M | Security and correctness smells | high |
| N | Verbosity and unidiomatic code | low |

## Scope

The user's words win. With no instruction, use the first row.

| User says | Target |
|---|---|
| nothing, "this change", "my changes" | Working tree: `git diff`, `git diff --cached`, untracked files. If clean, the commits on this branch not on the default branch. |
| a path, glob, or module | Those files. |
| "whole project", `--all` | Every source file tracked by git except vendored and generated code (`node_modules`, `vendor`, `dist`, `build`, lockfiles, generated migrations, minified assets). |

## Execution

1. **Collect the target.** For a diff, run `git diff`, `git diff --cached`, and `git status --porcelain` together and read new untracked files in full. For paths, list source files, then read them.
2. **Read context, not hunks.** Open each changed file in full, and the callers or producers of changed code when a check needs them (band-aids, duplication, API mismatch). Existing conventions decide what counts as drift. Large targets: work directory by directory.
3. **Triage.** Report only autopilot patterns. Drop anything the codebase does deliberately and consistently, anything the task required, and anything the catalogue lists as an exception. When in doubt, read one more caller.

## Report

Output the table before any fixing, so the user sees what will change:

```
| # | Severity | File:Line | Check | Issue | Fix |
```

- Sort high, moderate, low; within a level, by file.
- `Issue` names the pattern in this code, not the category. "Returns 0.0 when `amount` is missing, so a malformed record posts a zero payment" beats "fabricated default".
- `Fix` is the concrete change for this occurrence, never generic advice.
- **high** hides a bug, changes behavior silently, fabricates data, calls a nonexistent API, or is a security smell. **moderate** damages maintainability or misleads the next reader. **low** is noise.

End with one line: `N high, M moderate, K low across L files.` If nothing was found: `No slop found in L files. Checked A–N.` No preamble.

## Fix

Fix when the target is code produced in this session or the user asked for fixes. Otherwise stop after the report and say fixes are available on request. `--report-only` always stops after the report.

- Work high to low. Each fix removes the pattern **at its cause**: a swallowed exception is raised or handled at the real boundary; a default on a required field becomes validation that fails loudly; a band-aid in the consumer becomes a fix in the producer; a hallucinated API is replaced after checking the real one in the installed package; dead code is deleted, not commented.
- Create no new slop while fixing: no comment explaining the fix, no compatibility alias for a removed name, no `# cleaned up` marker, no tidying of neighboring lines.
- Skip rather than guess when the correct behavior is unknowable from the code (for example, what an error at a system boundary should do). Mark it skipped with the question the user must answer.

After fixing: run the formatter, linter, and tests if present and report failures verbatim. Re-read every edited region on disk. `git diff` to confirm the changes are the fixes and nothing more. Re-issue the table with an `Outcome` column: `fixed`, or `skipped: <reason>`.
