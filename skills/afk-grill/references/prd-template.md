# PRD template

Use this exact skeleton. The marker comment on line 1 is how the skill detects the mode on re-runs; keep it. Write prose in the requirement's language; IDs, tags and states stay ASCII. The PRD holds claims and tags only; reasoning goes to `grill-log.md`.

## ID scheme

- `C#` confirm items (3 to 5) · `R#` / `R#.#` tree nodes (append only, never renumber) · `T#` acceptance cases · `A#` assumptions · `D#` decisions. A `D` that made the confirm list appears there; the rest sit in the register with the default taken.
- Fixed first level: R1 Goal and success signal · R2 Users and triggers · R3 Scope and non-goals · R4 Behaviour · R5 Data · R6 Interfaces and compatibility · R7 Non-functional · R8 Dependencies and integrations · R9 Rollout and rollback · R10 Acceptance and verification.

## Provenance tags

`[E: path:12-30]` evidence · `[E: docs/x.md#section]` evidence in a doc · `[C: path, path]` convention, at least two examples · `[A3]` assumption 3 · `[D2]` follows the default of decision 2 · `[H]` human-provided · `[N/A: reason]` not applicable

## Skeleton

```markdown
<!-- afk-grill: prd -->
# PRD: <title>

| | |
|---|---|
| Requirement | <verbatim, as given> |
| Interpretation | <chosen> · rejected: <others, one clause each> |
| Version | v1 |
| Status | in-progress / converged / budget-exhausted / escalated / approved |
| Rounds | 3 of 5 |
| Sources | CLAUDE.md, docs/architecture.md, adr/ (12), tests/e2e (pytest) |
| Log | ./grill-log.md |

## 1. Confirm these (about 5 minutes)
Answer after the arrow, or in chat. Everything not listed here has a default and an acceptance case.

- **C1** [R0] Does "offline" mean a read-only cache, or queued writes? →
  default taken: queued writes (R4.2–R4.5) · why uncertain: requirement says "works offline", the project has only a read cache `[E: src/cache.py:1-40]` · if wrong: R4.2–R4.5, R5.2, T4–T9 retire
- **C2** [D1] Conflict policy: (a) last-write-wins (b) server wins (c) manual merge →
  default taken: (b) · why uncertain: no precedent in the repo · if wrong: R4.4, T6–T7
- **C3** [A2] … →

## 2. Requirements tree
Read only what you want; every line carries its evidence.

### R1 Goal and success signal
- **R1.1** <statement> `[E: docs/roadmap.md#q3]`
- **R1.2** <statement> `[A1]`
### R2 Users and triggers
- **R2.1** …
### R3 Scope and non-goals
- **R3.1** In: …
- **R3.2** Out: … `[H]`
### R4 Behaviour
- **R4.1** <happy path> `[E: …]`
  - **R4.1.1** <edge case> `[C: src/a.py:10, src/b.py:22]`
### R5 Data
### R6 Interfaces and compatibility
### R7 Non-functional
### R8 Dependencies and integrations
### R9 Rollout and rollback
### R10 Acceptance and verification
- **R10.1** <how success is verified; which T-cases gate release>

## 3. Acceptance cases (the safety net)
Style: <framework> as in `<tests/e2e/…>`; one behaviour per case; concrete values.

- **T1** [R4.1] Given <state> · When <action> · Then <observable result>
- **T2** [R4.1.1, A2] Given … · When … · Then …

## 4. Assumptions register
Defaults the loop took without evidence, outside the confirm list. Each is pinned by a T-case.

- **A1** [risk: low] <assumption> · why: project silent on … · if wrong: <IDs> · pinned by T3
- **D3** [taken: (b)] <decision not surfaced for confirmation> · options: (a) … (b) … · why (b): …

## 5. Sources consulted
- docs/architecture.md, adr/0007-sync.md, src/sync/*, tests/e2e/test_sync.py, git log -S"offline"

<!-- legend: [E] evidence · [C] convention (≥2 examples) · [A#] assumption · [D#] decision default · [H] human · [N/A] not applicable -->
```

## Review marks the user may add

Details in `prune-and-realign.md`. `✂️` or `[PRUNE]` removes a node and its subtree · `❌` or `[WRONG] note` re-grills with the note as truth · `✏️` or `[EDIT]` marks a line the user rewrote · `✅` or `[OK]` freezes · `C1 → answer` confirms.
