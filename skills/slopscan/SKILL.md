---
name: slopscan
description: "Scan code for AI-generated anti-patterns (slop): silent error handling, fabricated defaults, band-aid patches, dead code and placeholder stubs, narration comments, speculative abstraction, forced consolidation, style drift, fragile duplication, hallucinated APIs, scope creep, test slop, security smells. Targets the working-tree diff by default, a path, or the whole project; uses parallel subagents for large targets; reports a severity-ranked table and fixes the findings at their cause. Use when asked to review, clean up, de-slop, or sanity-check code, especially code Claude just wrote, before a commit or PR."
argument-hint: "[path | --all] [--report-only]"
---

# Slopscan

AI-generated code fails in characteristic ways. It hides errors instead of raising them, invents defaults for missing data, patches a symptom where it shows up rather than at its cause, leaves the scaffolding of earlier attempts in place, abstracts for futures nobody asked for, and narrates itself in comments. Each pattern looks reasonable on its own line and is wrong in context. This skill finds those patterns and removes them at the cause.

Slop is judged against **the codebase's own conventions and the task's actual requirement**, never against an abstract style. Read the surrounding code before flagging anything.

## Checks

The full catalogue, with examples and the legitimate exceptions for each check, is in `references/checks.md` in this skill's directory. Read it before scanning and pass its absolute path to every subagent. Categories:

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
| nothing, "this change", "my changes" | Working tree: `git diff`, `git diff --cached`, untracked files from `git status --porcelain`. If the tree is clean, the commits on this branch that are not on the default branch. |
| a path, glob, or module | Those files. |
| "whole project", `--all` | Every source file tracked by git except vendored and generated code (`node_modules`, `vendor`, `dist`, `build`, lockfiles, generated migrations, minified assets). |

## Execution

1. **Collect the target.** For a diff, run `git diff`, `git diff --cached`, and `git status --porcelain` in one step and read new untracked files in full. For paths, list source files first, then read them.
2. **Read context, not hunks.** Open each changed file in full, and the callers or producers of changed code when a check needs them (band-aids, duplication, API mismatch). Existing conventions decide what counts as drift.
3. **Pick the mode.**
   - Up to about 15 files or 1500 lines: scan yourself.
   - Larger: split by top-level directory or module into chunks of about 15 files. Launch one subagent (type `general-purpose`, instructed to stay read-only) per chunk, all in one message, with the scan prompt below. Merge the tables, drop duplicates, and re-verify any row you cannot confirm by reading the cited lines yourself.
4. **Triage.** Report only autopilot patterns. Drop anything the codebase does deliberately and consistently, anything the task explicitly required, and anything the catalogue lists as a legitimate exception. When in doubt, read one more caller before deciding.

Scan subagent prompt:

```
Read-only task. Do not edit anything.
Read <absolute path to references/checks.md> first, then scan the files below for those
patterns. Read every file in full, and open callers or producers when a check needs context.
Judge against the surrounding code's own conventions. Report only autopilot patterns; skip
deliberate, consistent, or task-required choices and the exceptions the catalogue lists.
Files: <list>
Return one markdown table row per confirmed finding:
| severity (high/moderate/low) | file:line | check letter | issue in one sentence | concrete fix for this exact occurrence |
Return the single word "none" if nothing is confirmed.
```

## Report

Output the findings table before any fixing, so the user sees what will change:

```
| # | Severity | File:Line | Check | Issue | Fix |
```

Rules for rows:

- Sort high, then moderate, then low. Within a level, order by file.
- `Issue` names the pattern in this code, not the category. "Returns 0.0 when `amount` is missing, so a malformed record posts a zero payment" beats "fabricated default".
- `Fix` is the concrete change for this occurrence: the replacement code or the action, never generic advice.
- Severity: **high** hides a bug, silently changes behavior, fabricates data, calls an API that does not exist, or is a security smell. **moderate** damages maintainability or misleads the next reader. **low** is noise the reader must filter.

End with one line: `N high, M moderate, K low across L files.` If nothing was found: `No slop found in L files. Checked A–N.` No preamble.

## Fix

Fix when the target is code produced in this session, or when the user asked for fixes ("fix", "clean up", "修正", "清理"). Otherwise stop after the report and say fixes are available on request. `--report-only` always stops after the report.

- Work high to low. Each fix removes the pattern **at its cause**: a swallowed exception is raised or handled at the real boundary; a default on a required field becomes validation that fails loudly; a band-aid in the consumer becomes a fix in the producer; a hallucinated API is replaced after checking the real one in the installed package or its docs; dead code is deleted, not commented.
- Up to about 10 findings: edit yourself. Beyond that, hand each file to a `general-purpose` subagent with its rows, the checks file path, and this section. A fixing subagent edits only its assigned files.
- Do not create new slop while fixing: no comment explaining the fix, no compatibility alias for a removed name, no `# cleaned up` marker, no unrelated tidying of neighboring lines.
- Skip a finding rather than guess when the correct behavior is unknowable from the code (for example, what an error at a system boundary should do). Mark it skipped with the question the user must answer.

After fixing: run the project's formatter, linter, and tests if they exist and report the result verbatim on failure. Re-read every edited region on disk. Run `git diff` and confirm the changes are the fixes and nothing more. Re-issue the table with an `Outcome` column: `fixed`, or `skipped: <reason>`.
