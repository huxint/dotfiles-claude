# Loop protocol

Mechanics for Phases 1 to 3 of `afk-grill`. SKILL.md gives the shape; this file gives the rules you apply every round.

Contents: 1 State files · 2 Tree and IDs · 3 Round procedure · 4 Frontier rule · 5 Merging answers · 6 Uncertainty ranking (confirm list) · 7 Acceptance cases · 8 Pass conditions and budgets · 9 Final audit · 10 Grill log format · 11 Resume · 12 Inline mode

## 1. State files

- `PRD.md` is the clean artifact: claims and tags only, rewritten after every round. It is what the griller attacks and what the human reviews.
- `grill-log.md` is append-only: launch card, every round's questions, answers, evidence and state changes, audit results, re-align change sets. Reasoning lives here and never in the PRD.

Default directory `docs/prd/<slug>/`, slug = at most 5 ASCII words naming the requirement. If the repo already has a home for design docs (`docs/design`, `docs/rfcs`, `adr/`), use it and say so in the launch card. `--out DIR` overrides.

## 2. Tree and IDs

Root R0 = requirement plus chosen interpretation. First level is fixed:

| ID | Dimension | Typical children |
|---|---|---|
| R1 | Goal and success signal | the metric or observable that says it worked |
| R2 | Users and triggers | actors, entry points, frequency |
| R3 | Scope and non-goals | in, out, deferred |
| R4 | Behaviour | happy path, edge cases, failures, limits |
| R5 | Data | model, storage, migration, retention, privacy |
| R6 | Interfaces and compatibility | API, UI, CLI, events; what must not break |
| R7 | Non-functional | performance, security, i18n, accessibility, as applicable |
| R8 | Dependencies and integrations | services, libraries, teams |
| R9 | Rollout and rollback | flags, migration order, monitoring, kill switch |
| R10 | Acceptance and verification | which T-cases gate release, manual checks |

Children are `R4.1`, `R4.1.2` and so on, append only. A pruned node keeps its ID and is listed as retired in the log; never reuse it.

Each node carries: id, statement (one or two sentences), state and tag, children, and `depends-on` (IDs whose change would invalidate this node). Fill `depends-on` as you merge; it is what makes re-align cheap.

## 3. Round procedure

1. Spawn the griller with the verbatim prompt in `griller-prompt.md`. Inputs: requirement, interpretation, PRD path, project root, frozen IDs, round number. Fresh agent every round.
2. Build the batch: the griller's questions, plus open nodes you know it missed (a node still `[A]` that nobody has asked about). Dedupe against the log: don't re-ask an answered question unless new evidence contradicts it. Order blocking, major, minor; within a level, higher blast radius first. Cap at 12.
3. Group the batch by area (data, behaviour, interfaces, ops) and spawn 2 to 4 researchers in one message with the verbatim prompt in `researcher-prompt.md`. Give each its questions, the PRD path, the project root and the preflight source inventory.
4. Merge (§5). Rewrite `PRD.md`. Append the round to `grill-log.md` (§10).
5. Evaluate the pass conditions (§8).

Round 0 (Phase 1) is steps 3 to 4 only: no griller, and the questions are "what exists today that this touches, and which conventions apply" for each dimension.

## 4. Frontier rule

A question belongs in this round only if its prerequisites are settled, the same rule `/grilling` uses. "How are offline conflicts merged?" waits until "is there offline write at all?" is settled. Questions downstream of an unresolved `[D]` node are researched under the recommended default, and the resulting nodes get `depends-on` that D, so a different decision reopens exactly those nodes and nothing else.

## 5. Merging answers

For each answer:

- Open the citation. It must exist and say what is claimed. Otherwise reject, re-ask next round, and log the rejection. A researcher that fabricates once gets its whole batch spot-checked.
- Apply the state. States move up (A to E) or down (E to A when the griller shows the citation doesn't support the claim). Log every transition.
- Add the children the answer unlocks: the researcher's `raises:` line and the griller's follow-ups.
- Keep the PRD statement to what the evidence supports; nuance goes to the log.
- Two patterns in the repo for the same thing: prefer the newer or dominant one, cite both under `[C]`, and if the split is even, register an assumption for the choice.

## 6. Uncertainty ranking: the confirm list

Score every node that is not `[E]` or `[H]`:

```
uncertainty = evidence weight × blast radius
evidence weight:  [C] 1 · [A] 2 · [N/A] 2 if the griller challenged it · [D] 3
blast radius:     1 local wording · 2 changes this subtree or several T-cases · 3 changes the design across dimensions or the interpretation
```

Take the top 5, and at least 3 whenever any node scores 2 or more. Ties: `[D]` first (only the human can settle it), then the node with more dependents. Everything else stays in the register with its default and a T-case.

Each confirm item: the question in one line, the default taken, why it is uncertain (what evidence was missing), and what changes if wrong (IDs). Write it so a yes, a no, or one phrase is a complete answer.

If more than 5 nodes score 6 or above, the requirement is underspecified for an unattended loop: stop with Status `escalated` and name the overflow nodes. The human is better served by ten minutes of `/grilling` on those than by a PRD built on five stacked guesses.

## 7. Acceptance cases

T-cases turn understanding into something that fails loudly at implementation time. Rules:

- At least one per behaviour node (R4.*, R6.*, R9 guards, and any R7 limit that is checkable). Every assumption outside the confirm list gets a T-case that encodes its default: a wrong default then shows up as a concrete example the reviewer can spot in seconds, and as a failing test later.
- Given / When / Then with concrete values, one behaviour per case. Name the covered IDs: `T7 [R4.3, A2]`.
- Write them in the project's test style found in preflight: framework, fixtures, naming, where they would live. If the repo has e2e or acceptance tests, mirror their structure so implementation can drop them in.
- An untestable statement is either sharpened until it is testable or moved to non-goals. The griller treats an untestable behaviour node as major.

## 8. Pass conditions and budgets

Evaluate after every merge, in this order:

1. **Escalated**: more than 5 high-uncertainty `[D]` nodes (§6) or the root interpretation blocks most of the tree. Audit, stop.
2. **Converged**: griller verdict CONVERGED (no blocking, no major). Audit. Pass: stop with `converged`. Fail: fix what the audit found, run one more round, then stop regardless.
3. **Diminishing returns**: the round changed fewer than 2 nodes and added none. Audit. Pass: `converged`. Fail: `budget-exhausted`.
4. **Budget**: rounds equal `--rounds` (default 5). Audit, stop with `budget-exhausted`.

Otherwise continue. Typical runs converge in 2 to 4 rounds. A run still adding nodes at round 5 usually has an interpretation problem; say so in the summary rather than asking for more rounds.

## 9. Final audit

Run it yourself and log the result:

- **Citations.** Open the 5 highest-blast-radius `[E]` and `[C]` citations. Each must say what the node claims. Any failure downgrades the node to `[A]`; re-rank.
- **Tags.** Every statement in R1 to R10 carries a tag. Untagged becomes `[A]` and is registered.
- **Coverage.** Every behaviour node and every registered assumption has at least one T-case; every T-case names at least one node.
- **Confirm list.** 3 to 5 items, each answerable in one line, IDs valid.
- **Scope.** Nothing in R4 to R6 that the requirement did not ask for and no source justifies (creep); nothing the requirement implied that is missing (shrink).

Pass means all five are clean.

## 10. Grill log format

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

## 11. Resume

`PRD.md` has the marker and `Status: in-progress`: read the last round in the log, rebuild the frozen list and the open frontier from it, and continue at §3 step 1. Never restart from Phase 1; the log is the state.

## 12. Inline mode (`--inline`)

When subagents are unavailable (rate limits, a restricted tool set) or the user asks for a cheap run, play both roles yourself. Keep the separation by discipline: write the griller's questions to the log **before** researching any of them, run all nine attack patterns from `griller-prompt.md` against the PRD file (not against your memory of it), and hold every answer to the citation standard. State `mode: inline` in the launch card and the summary. Expect a more lenient griller: an agent questioning its own draft finds fewer gaps than a fresh one, so lower the diminishing-returns threshold to "changed fewer than 1 node" and keep the confirm list at 5.
