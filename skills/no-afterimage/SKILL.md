---
name: no-afterimage
description: "Remove afterimages: traces of the working session that leaked into the deliverable. The user says 'ramen, no cilantro' and the result must be a bowl of ramen, not NoCilantroRamen, not a comment 'no cilantro as requested', not a test asserting the absence of cilantro, and not a PR body narrating the back-and-forth. Covers exclusions turned into named features, superseded alternatives left beside the winner (newX, xV2, foo_old, 'instead of X'), commented-out earlier attempts, toggles between approaches, and commit, PR, or handoff text that retells the conversation. Use after the user corrects, excludes, or rejects something mid-task, before a commit, PR, or handoff that followed such a back-and-forth, or when the user says afterimage, 残影, 别把要求写进名字, 清掉会话痕迹. Not for real deprecations, migration notes, changelogs, or negative requirements users rely on."
argument-hint: "[path | --all] [--report-only]"
---

# No Afterimage

An **afterimage** is a piece of the conversation that survived into the artifact. The user asked for ramen without cilantro; the artifact is ramen. `NoCilantroRamen`, `// no cilantro as requested`, `test_has_no_cilantro`, and a PR body that says "originally added cilantro, removed after feedback" are all the instruction leaking into the product.

Every surface is generated from the accepted state alone. Apply the **reader test**: would someone who never saw this conversation need this to use, trust, or maintain the artifact?

## Boundaries

This skill removes structure that exists *because* an approach was tried and dropped, and text that only makes sense to someone who saw the conversation. It is not a general cleanup: dead code with no session origin, ordinary bad names, and ordinary narration comments are out of scope. Real deprecations, migration guides, changelogs, and interface-required names are history readers rely on; leave them.

## Constraint or requirement

The one decision that matters: is a negative statement an **implementation preference** or a **lasting requirement**?

- "Don't use a regex here" shaped the solution. The code uses a parser; nothing names the regex that was not used.
- "Never send analytics offline" is a property users rely on. It deserves a name, a comment, and a test, even though it arrived as a "don't".

Decide which one a candidate is before touching it. Privacy guarantees, offline operation, and nonblocking requirements are valid negative contracts. Existing uncommitted user work is baseline, not an abandoned attempt.

## Target

- A path, glob, or module: those files. `--all`: every tracked file, skipping generated and vendored content; residue from earlier sessions counts.
- Otherwise the working tree: `git diff`, `git diff --cached`, and untracked files. Clean tree: compare the branch with the merge base of its base branch, and report if the base cannot be resolved or the comparison is empty.
- Always: the pending commit message, PR text, docs, and the handoff message of the current task.

A review request, or `--report-only`, produces findings without editing. Otherwise repair the artifacts of the active task, or the cleanup the user requested.

## Surfaces

| Surface | Afterimage | Repair |
|---|---|---|
| Comments and prose | "as requested", "instead of the earlier X", exclusions announced as features | State the lasting rationale, or delete |
| Identifiers and paths | `new`, `old`, `v2`, `fixed`, `without`, `simple` meaning something only relative to the draft | Name the domain role; update every reference, string, test, and doc |
| Tests and fixtures | An assertion whose only job is to prove the rejected approach is gone | Keep coverage of the real contract; delete the memorial |
| Code and config | The losing alternative kept beside the winner, commented-out attempts, a flag that always takes one value, a key nothing reads | Confirm no consumer, including dynamic ones, then remove |
| Commit and PR text | A transcript of attempts and feedback | Describe the problem, the resulting behavior, and the validation; never rewrite published history |
| Handoff | Narration about what was excluded and why | Describe what was delivered and verified; answer questions about constraints when asked |

## Workflow

1. **Recover intent.** From the conversation and the repository, list what was accepted, what was excluded, what was corrected, and what was proposed and dropped. Without history, judge by the reader test alone; a suspicious word is a search clue, not evidence.
2. **Inspect every surface.** Read the target files in context. Search with `rg` for the candidates above, then read each hit for meaning. A search with no matches says nothing about semantic residue.
3. **Decide** per candidate: constraint or requirement, then reader test.
4. **Repair within scope.** Trace references before renaming or deleting. External contracts stay unless the task authorizes the change.
5. **Verify.** Re-read the edited surfaces, read the diff, and run the project's checks after any code rename or deletion. Every finding is repaired or reported with a reason.

## Report

Scans: `File:Line | Residue | Replacement | Outcome`. Handoffs: the delivered behavior and its verification. Any comparison or exclusion that remains must pass the reader test, and the report says why it stays.
