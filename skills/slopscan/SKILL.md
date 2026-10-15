---
name: slopscan
description: "Review code for unnecessary defenses, layers, special cases, and AI-generated clutter, with concrete improvements. Use for a review or cleanup focused on slop, overengineering, or code simplicity. Not for routine implementation, a generic bug review, or merely preparing a commit or PR."
argument-hint: "[path | --all] [--report-only]"
---

# Slopscan

Find code that adds reading or maintenance cost without serving the requirements. Judge it against the project's contracts and idioms. Prefer a clear representation that makes routine cases follow the same path; keep branches that express real domain differences.

Every finding needs a location, a concrete replacement, and a specific benefit: a removed branch, layer, duplication, misleading claim, or defect. For a redundant guard, cite the guarantee that rules out the guarded condition. A style preference or suspicious pattern alone is not a finding.

Keep simplifications behavior-preserving. For defect repairs, show how current behavior violates the intended contract and how the replacement restores it.

## Scope

- Use the requested paths, globs, or modules. `--all` covers tracked source files, excluding generated and vendored code.
- When invoked within a larger task, review that task's changes and the context needed to judge them.
- Otherwise review staged, unstaged, and untracked changes. In a clean tree, compare the branch with the merge base of its known base branch. If the base is unknown or the diff is empty, report that limit.

Reviews and `--report-only` produce findings. Fix and cleanup requests authorize edits within scope.

## Review

Read the [check catalogue](references/checks.md) before reviewing. It covers unnecessary defenses, needless wrappers, awkward forms, misplaced abstractions, padding, leftovers, hidden failures, API misuse, and weak tests. Its patterns are search clues; apply their evidence requirements and exceptions.

1. **Establish context.** Read the targets and relevant callers, producers, and tests. Trace each candidate to the contract that supports it. For large scans, work module by module and track the scope inspected.
2. **Find the better form.** Write the smallest clear improvement and explain what it removes or repairs. Respect intentional project conventions; they do not excuse a demonstrated defect.
3. **Apply authorized repairs.** Fix defects first, then structure, then local clutter. Trace references before deleting or inlining. Preserve public contracts and useful dependency or test boundaries. Repair defects where the violated contract is owned.
4. **Verify proportionally.** Run required project checks and checks relevant to the edits. Use existing tests for behavior-preserving cleanup; add tests when they protect meaningful behavior. Review the diff for unrelated changes.

## Report

For a review, use a compact table:

`Level | Location | Finding | Better form | Outcome`

- **Defect:** demonstrated wrong behavior, hidden failure, invalid data, API misuse, or a security flaw.
- **Structure:** misplaced responsibilities, unnecessary layers, or a shared rule duplicated across locations.
- **Local:** a redundant guard, needless wrapper, unclear name, or needlessly complex expression.

Sort by level, then location. Put replacements that need more space in short code blocks below the table. For authorized cleanup, summarize repairs and unresolved findings without requiring a separate approval round.

State the scope inspected, verification performed, and material limits. No findings is a valid result. Identify incomplete coverage or unresolved evidence instead of implying a complete review.
