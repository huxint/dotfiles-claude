# Loop protocol

Mechanics for `afk-grill`. SKILL.md gives the round shape and the pass conditions; this file gives the rules applied inside a round.

Contents: 1 State files · 2 Tree and IDs · 3 Frontier rule · 4 Merging answers · 5 Confirm list ranking · 6 Acceptance cases · 7 Final audit · 8 Grill log format · 9 Resume · 10 Inline mode

## 1. State files

- `PRD.md`: claims and tags only, rewritten after every round. It is what the griller attacks and what the human reviews.
- `grill-log.md`: append-only. Launch card, every round's questions, answers, evidence and state changes, audit results, re-align change sets. Reasoning lives here.

Default directory `docs/prd/<slug>/`, slug at most 5 ASCII words. If the repo already has a home for design docs (`docs/design`, `docs/rfcs`, `adr/`), use it and say so in the launch card. `--out DIR` overrides.

## 2. Tree and IDs

Root R0 is the requirement plus the chosen interpretation. The first level is fixed:

| ID | Dimension | Typical children |
|---|---|---|
| R1 | Goal and success signal | the metric or observable that says it worked |
| R2 | Users and triggers | actors, entry points, frequency |
| R3 | Scope and non-goals | in, out, deferred |
| R4 | Behavior | happy path, edge cases, failures, limits |
| R5 | Data | model, storage, migration, retention, privacy |
| R6 | Interfaces and compatibility | API, UI, CLI, events; what must not break |
| R7 | Non-functional | performance, security, i18n, accessibility, as applicable |
| R8 | Dependencies and integrations | services, libraries, teams |
| R9 | Rollout and rollback | flags, migration order, monitoring, kill switch |
| R10 | Acceptance and verification | which T-cases gate release, manual checks |

Children are `R4.1`, `R4.1.2` and so on, append only. A pruned node keeps its ID and is listed as retired in the log.

Each node carries: id, statement (one or two sentences), tag, children, and `depends-on` (IDs whose change would invalidate it). Fill `depends-on` as you merge; it is what makes re-align cheap.

## 3. Frontier rule

A question belongs in this round only if its prerequisites are settled, the same rule `/grilling` uses: "how are offline conflicts merged?" waits until "is there offline write at all?" is settled. Questions downstream of an open `[D]` are researched under its recommended default, and the resulting nodes get `depends-on` that D, so a different decision reopens exactly those nodes.

## 4. Merging answers

For each answer:

- Open the citation. It must exist and say what is claimed; otherwise reject, re-ask next round, and log the rejection. A researcher that fabricates once gets its whole batch spot-checked.
- Apply the state. States move up (A to E) or down (E to A when the griller shows the citation does not support the claim). Log every transition.
- Add the children the answer unlocks: the researcher's `raises:` line and the griller's follow-ups.
- Keep the PRD statement to what the evidence supports; nuance goes to the log.
- Two patterns in the repo for the same thing: prefer the newer or dominant one, cite both under `[C]`, and register an assumption if the split is even.

## 5. Confirm list ranking

Score every node that is not `[E]` or `[H]`:

```
uncertainty = evidence weight × blast radius
evidence weight:  [C] 1 · [A] 2 · [N/A] 2 if the griller challenged it · [D] 3
blast radius:     1 local wording · 2 changes this subtree or several T-cases · 3 changes the design across dimensions or the interpretation
```

Take the top 5, and at least 3 whenever any node scores 2 or more. Ties: `[D]` first, then the node with more dependents. Everything else stays in the register with its default and a T-case.

Each confirm item: the question in one line, the default taken, why it is uncertain (what evidence was missing), and what changes if wrong (IDs). A yes, a no, or one phrase must be a complete answer.

More than 5 nodes scoring 6 or above means the requirement is underspecified for an unattended loop: stop with Status `escalated` and name the overflow nodes.

## 6. Acceptance cases

T-cases turn understanding into something that fails loudly at implementation time.

- At least one per behavior node (R4.*, R6.*, R9 guards, any checkable R7 limit). Every assumption outside the confirm list gets a T-case encoding its default: a wrong default then shows up as a concrete example the reviewer spots in seconds, and as a failing test later.
- Given / When / Then with concrete values, one behavior per case, covered IDs named: `T7 [R4.3, A2]`.
- Written in the project's test style from preflight: framework, fixtures, naming, location. Mirror existing e2e or acceptance tests so implementation can drop them in.
- An untestable statement is sharpened until testable or moved to non-goals. The griller treats an untestable behavior node as major.

## 7. Final audit

Run it yourself and log the result. Pass means all five are clean:

- **Citations.** Open the 5 highest-blast-radius `[E]` and `[C]` citations. Each must say what the node claims; a failure downgrades the node to `[A]` and re-ranks.
- **Tags.** Every statement in R1 to R10 carries a tag. Untagged becomes `[A]` and is registered.
- **Coverage.** Every behavior node and every registered assumption has a T-case; every T-case names a node.
- **Confirm list.** 3 to 5 items, each answerable in one line, IDs valid.
- **Scope.** Nothing in R4 to R6 the requirement did not ask for and no source justifies; nothing the requirement implied is missing.

## 8. Grill log format

```
## Round 2  (frontier 9 · researchers 3)
### Asked
Q1 [R4.2] blocking — <question> — why: <what breaks if guessed>
### Answered
Q1 → RESOLVED [E: src/sync/queue.py:88-104] <answer, ≤3 sentences>   (researcher B)
Q2 → ASSUMED A4 — <default> — project silent on <x>; confirm by <y>
Q3 → REJECTED: src/x.py:40 does not mention retries → re-ask
### Tree changes
+R4.2.1 +R4.2.2 · R5.1 A→E · R7.2 E→A (citation failed)
### Verdict
griller: CONTINUE (2 major open) · changed 7 · new 2 → continue
```

## 9. Resume

`PRD.md` has the marker and `Status: in-progress`: read the last round in the log, rebuild the frozen list and the open frontier from it, and continue with the next round's griller. Never restart from the seed; the log is the state.

## 10. Inline mode (`--inline`)

When subagents are unavailable or the user asks for a cheap run, play both roles yourself. Keep the separation by discipline: write the griller's questions to the log before researching any of them, run all nine attack patterns from `griller-prompt.md` against the PRD file rather than your memory of it, and hold every answer to the citation standard. State `mode: inline` in the launch card and the summary. An agent questioning its own draft finds fewer gaps than a fresh one, so lower the diminishing-returns threshold to "changed fewer than 1 node" and keep the confirm list at 5.
