---
name: no-afterimage
description: "Prevent afterimages: produce final artifacts — labels, comments, metadata, commits, PRs, handoffs — from the accepted state alone, with no lingering trace of rejected session-only alternatives. Use after corrections or discarded proposals, not for ordinary deletion, deprecation, migration, or mentions required for safety, accuracy, compatibility, audit, quotation, or requested comparison."
---

# No Afterimage

Write every outward-facing surface — filenames, code comments, labels, metadata, commit text, PR text, handoffs — as if the audience never saw the working session. Rejected proposals and corrections are control data, not part of the result's identity.

Generate each surface from the accepted final state, and never mention, explain, or justify what was not chosen. Say what is: "uses SQLite" — never "uses SQLite (not Postgres)" or "SQLite was chosen over Postgres". If a rejected option doesn't belong, omit it outright — not as a parenthetical, synonym, or euphemism.

## What belongs

Mention an exclusion only when a reader without session history needs it: omission would make the artifact unsafe, inaccurate, misleading, incompatible, or noncompliant; a real change from the approved baseline must be explained; or the user asked for a comparison, audit, changelog, or migration notes. Prior appearance is not a reason. "Don't mention X" doesn't make X publishable.

Quoted source material stays data unless adopted as instruction. Preserve pre-existing user changes and executed events; uncommitted work is not rejected work. Don't hide real removals or erase required names, diagnostics, tests, safety facts, or audit history.

## Before delivery

Read the actual surfaces back and recheck — a zero-match grep is not proof — including after a tool or hook alters one. Then close with the positive result and verification status. No slogan claiming the output is clean: that claim is itself residue.
