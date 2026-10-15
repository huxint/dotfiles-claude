---
name: no-afterimage
description: "Remove remnants of rejected drafts from code, tests, docs, and handoffs. Use when asked to remove conversation residue or when a deliverable still carries abandoned choices. A correction, exclusion, commit, or handoff alone is not a trigger. Preserve lasting requirements and useful project history."
argument-hint: "[path | --all] [--report-only]"
---

# No Afterimage

An **afterimage** is draft history preserved as if it were part of the product. Express the accepted solution in terms readers can understand without seeing the conversation.

Apply the **reader test**: does someone need this information to use, trust, or maintain the result?

## Distinguish preferences from requirements

An implementation preference shapes the solution. A lasting requirement defines behavior users depend on.

- Choosing a parser over a regex does not require names, comments, or tests about the rejected regex.
- A guarantee that credentials never enter logs is a real contract worth documenting and testing.

Preserve real deprecations, migration notes, changelogs, and interface requirements. Existing user edits are baseline work, not evidence of an abandoned attempt. Ordinary dead code, weak names, and redundant comments without a connection to discarded work are outside this skill's scope.

## Scope

- Use the requested paths, globs, or modules. `--all` covers tracked files, excluding generated and vendored content; residue from earlier sessions also counts.
- When invoked within a larger task, limit cleanup to that task's artifacts, including pending docs, commit or PR drafts, and handoff text. Leave published history intact.
- Otherwise review staged, unstaged, and untracked changes. In a clean tree, compare the branch with the merge base of its known base branch. If the base is unknown or the diff is empty, report that limit.

Reviews and `--report-only` produce findings. Cleanup requests authorize edits within scope.

## Surfaces

| Surface | Residue | Repair |
|---|---|---|
| Comments and prose | Session remarks, discarded alternatives, exclusions presented as features | State the lasting rationale or remove the text |
| Names and paths | Draft labels such as `new`, `old`, `fixed`, or `v2` with no current domain meaning | Name the role and update references |
| Tests and fixtures | Assertions whose only purpose is to memorialize a rejected approach | Keep coverage of lasting behavior; remove draft-specific assertions |
| Code and configuration | Abandoned implementations, temporary switches, unused options from earlier attempts | Trace consumers, then remove what the accepted solution no longer needs |
| Commit, PR, and handoff drafts | A transcript of attempts and feedback | Describe the problem, delivered behavior, and verification |

## Workflow

1. Recover the accepted outcome and discarded choices from the conversation and repository. Without that history, use the reader test; suspicious words alone are not evidence.
2. Read candidate residue in context. Search terms help locate it but cannot establish whether it should remain.
3. Separate implementation preferences from lasting requirements, then repair within scope. Trace references before renaming or deleting; preserve external contracts unless the task includes changing them.
4. Re-read the result as a reader unfamiliar with the session. Review the diff and run relevant checks after code changes.

For reviews, give the location, residue, and proposed repair. For edits, report the delivered result and verification. Explain retained history only when its relevance needs clarification.
