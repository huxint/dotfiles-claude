---
name: no-afterimage
description: "Remove afterimages after exclusions, corrections, or discarded approaches, and before commits, PRs, or handoffs. Preserve real requirements and compatibility history."
argument-hint: "[path | --all] [--report-only]"
---

# No Afterimage

An **afterimage** is a session instruction or abandoned attempt leaking into an artifact that must stand on its own. A request for ramen without cilantro produces ramen; naming it `NoCilantroRamen` turns the instruction into a feature.

Generate every surface from the accepted state. Apply the **reader test**: would someone without the session history need this to use, trust, or maintain the artifact?

## Scope and mode

- A requested path, glob, or module selects those files. `--all` selects tracked files, excluding generated and vendored content; residue from earlier sessions counts too.
- Otherwise collect staged, unstaged, and untracked changes with `git diff`, `git diff --cached`, and `git status --short`.
- If the tree is clean, resolve the base branch from the task or repository metadata and compare from its merge base with HEAD. Report an unresolved base or an empty comparison.
- Include pending commit messages, PR text, documentation, and the handoff within the task.

Reviews produce findings unless fixes are also requested; `--report-only` always leaves target files unchanged. Otherwise fix artifacts being produced in the active task or cleanup the user requested. Existing uncommitted user work is part of the baseline, not evidence of an abandoned attempt.

## Workflow

1. **Recover intent.** Identify accepted behavior, exclusions, corrections, and discarded proposals from the available conversation and repository evidence. When history is unavailable, judge the artifact by the reader test; a suspicious word alone cannot establish its origin.
2. **Inspect every surface.** Read target files in context and review the surfaces below. Search with `rg` to locate candidates, then inspect their meaning and usage. A search with no matches does not cover semantic residue.
3. **Decide.** For each candidate, apply the reader test and preservation rules. Establish why the material exists before removing it.
4. **Repair within scope.** Apply the relevant transformation below. Trace references and consumers before renames or deletions; retain external contracts unless the task authorizes changing them.
5. **Verify.** Re-read edited surfaces on disk, inspect the diff, and run applicable checks for code renames or deletions. Account for every finding as repaired or reported with a reason.

## Surfaces and repairs

| Surface | Candidate | Repair |
|---|---|---|
| Comments and prose | Draft comparisons, exclusions announced as features, remarks such as “as requested” | State the lasting behavior or rationale; remove text with no remaining reader value. |
| Identifiers and paths | `new`, `old`, `v2`, `fixed`, `without` carrying only session-relative meaning | Name the domain role; check collisions and update code, imports, strings, tests, and docs that refer to it. |
| Tests, fixtures, lint, and CI | Assertions guarding a discarded implementation choice | Preserve meaningful contract coverage; remove a check whose only purpose is to memorialize the session. |
| Code and configuration | Unused alternatives, commented-out attempts, constant-choice flags, unread keys, or unreachable cleanup branches | Confirm actual usage, including dynamic consumers, then remove abandoned structure and keep the accepted behavior. |
| Commit and PR drafts | A transcript of attempts or feedback | Describe the problem, resulting behavior, and validation. Report issues in published history without rewriting it. |
| Handoffs | Narration about exclusions and discarded attempts | Describe what was delivered and verified; answer constraint questions when asked. |

## Preserve lasting meaning

- **Requirements:** a user-visible property or system invariant deserves documentation and tests even if introduced this session. Privacy guarantees, offline operation, and required nonblocking behavior are valid negative contracts.
- **Compatibility and history:** retain real deprecations, migration instructions, changelogs, and names required by interfaces.
- **Rationale:** keep the reason a maintainer needs to avoid a tempting mistake. Explain the constraint that justifies binary search; omit a comparison to the session's discarded draft.
- **Evidence:** preserve safety, accuracy, and audit facts, quoted sources, and comparisons or history the user requested.

An implementation preference shapes the solution; a lasting requirement defines behavior others rely on. Determine which one a candidate expresses before deleting a negative assertion.

## Report

For a scan, list the location, residue, replacement, and outcome. For a handoff, state the delivered behavior and verification. Every retained comparison or exclusion should serve the reader test.
