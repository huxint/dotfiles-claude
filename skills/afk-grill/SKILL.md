---
name: afk-grill
description: "Unattended requirement alignment (an AFK grill loop): turns a one-line requirement into a PRD without interviewing the user node by node. A fresh-context griller subagent asks what /grilling would ask, researcher subagents answer from the project's own code, docs, and conventions with citations, and rounds repeat until nothing is silently assumed. Built for a ten-minute human review: the 3 to 5 most uncertain nodes to confirm, acceptance cases that backstop every other node, a provenance tag on every claim; the user confirms or prunes and only the affected subtree re-runs. Use when the user says afk grill, self grill, grill it yourself, 自动对齐需求, AFK 循环, 自己展开需求树, 帮我出 PRD, wants a PRD or spec from a brief without being interviewed, or hands back a reviewed PRD. Needs an existing project with code and docs; on a greenfield project stop and point to /grilling."
argument-hint: "<requirement or brief.md> | <path/to/PRD.md> [--rounds N] [--out DIR] [--inline]"
---

# AFK Grill

`/grilling` (`references/grilling.md`) walks the design tree breadth-first with the user answering every frontier question. Nothing is silently assumed, and it costs hours. This skill keeps the tree and the BFS and takes the human out of the loop: a **griller** subagent asks, **researcher** subagents answer from the project itself, and you merge rounds until the tree converges. The human then spends about ten minutes on what evidence cannot settle.

What makes the unattended loop safe:

- **A tiny confirm surface.** The 3 to 5 most uncertain nodes go to the human. Everything else takes a defensible default.
- **Acceptance cases backstop the rest.** Every behavior node and every default maps to a concrete case in the project's test style. A node the human never read still fails loudly when the implementation drifts.
- **Evidence or an honest tag.** Every claim cites the project or is marked assumed. An honest `[A]` beats a fake `[E]`.

Two preconditions, both enforced in preflight: the project has code and conventions to draw on, and the pass conditions are concrete. On a blank project the loop still converges, by inventing assumptions and dressing them as facts.

## Modes

Arguments: `$ARGUMENTS`.

| Argument | Mode |
|---|---|
| Free text, or a file without the `<!-- afk-grill: prd -->` marker | **New run**; that is the brief |
| PRD with the marker and `Status: in-progress` | **Resume** from the log (protocol §9) |
| PRD with the marker plus review marks or answered confirm items | **Re-align** (`references/prune-and-realign.md`) |
| Finished PRD, no marks, no answers | Show the confirm list and the mark syntax again; stop |
| Nothing | Ask for the requirement; one sentence is enough |

Flags: `--rounds N` (default 5), `--out DIR` (default `docs/prd/<slug>/`), `--inline` (no subagents; protocol §10). Read `references/loop-protocol.md` before the first round of a new run or resume.

## Preflight (never skip)

1. **Inventory.** CLAUDE.md, README, `docs/`, ADRs, earlier PRDs, schemas, migrations, tests, CI; repo age and activity. Note the test framework and where acceptance-level tests live; T-cases are written in that style.
2. **Verdict.** GO with real code plus one source of conventions (a doc, or code consistent enough to infer them). Otherwise NO-GO: say what is missing, offer `/grilling` or a short seed brief (goal, users, constraints, non-goals), and stop.
3. **Interpretation.** List 2 or 3 readings of the requirement, pick the one the project supports, record the rest. If the readings would change most of the tree, the choice becomes confirm item C1; continue on the most plausible reading rather than blocking.
4. **Launch card.** Print it and continue; the user may already be away.

```
AFK grill: launch
Requirement:    <verbatim>
Interpretation: <chosen>  (rejected: <others>)
Sources:        CLAUDE.md, docs/architecture.md, 12 ADRs, tests/e2e (pytest) · repo: 2y, 1,340 commits
Output:         docs/prd/<slug>/PRD.md + grill-log.md
Budget:         ≤5 rounds · ≤12 questions/round · confirm list ≤5
```

## Seed

Create `PRD.md` from `references/prd-template.md` with Status `in-progress`, and `grill-log.md` opening with the launch card. The file comes first: the griller attacks a clean artifact rather than your reasoning, and an interrupted run stays resumable.

Expand the root into the ten fixed dimensions (R1 goal, R2 users, R3 scope, R4 behavior, R5 data, R6 interfaces, R7 non-functional, R8 dependencies, R9 rollout, R10 acceptance). Run **round 0** with researchers only: for each dimension, what exists today that this touches, and which conventions apply. Merge, so the griller's first pass meets evidence rather than a skeleton. `[N/A: reason]` needs a reason the griller can check.

## Loop

Each round:

1. **Griller.** A fresh `general-purpose` agent with the verbatim prompt in `references/griller-prompt.md`. It sees the requirement, the current `PRD.md`, and the frozen IDs; never the log, never your reasoning, never a `fork` (an agent that inherits your context inherits your blind spots). It returns at most 12 prioritized questions and a verdict.
2. **Researchers.** Add open nodes the griller missed, dedupe against the log, keep the top 12 by priority, group by area, and spawn 2 to 4 `general-purpose` agents in one message with the verbatim prompt in `references/researcher-prompt.md`. They cite or say the project is silent. A researcher may be reused across rounds via SendMessage; a griller never.
3. **Merge.** Open every citation; reject one that does not exist or does not say what is claimed, and re-ask it. Update node states, add the children the answers unlock, append IDs and never renumber. Append the round to the log.
4. **Check the pass conditions.**

You may answer a question yourself only from evidence already read this session, to the same citation standard. Never from general knowledge; that is the deviation the loop exists to prevent. Nobody answers a product or business question: it becomes `[D]` with options.

### Tags

| Tag | Means | Requires |
|---|---|---|
| `[E: path:line]`, `[E: doc#section]` | Evidence | A citation a reader can open that says this |
| `[C: path, path]` | Convention | At least 2 consistent examples |
| `[A#]` | Assumed | Default, why, and what breaks if wrong, all registered |
| `[D#]` | Decision | Evidence cannot settle it; options plus the default the PRD follows |
| `[H]` | Human | Only from confirmations or edits during re-align |
| `[N/A: reason]` | Not applicable | A reason the griller can challenge |

### Pass conditions

Stop at the first that holds, in this order:

- **Escalated.** More than 5 `[D]` nodes with real blast radius, or the interpretation blocks most of the tree. More rounds cannot settle what only the human can; recommend `/grilling` on those nodes.
- **Converged.** The griller reports no blocking or major questions and the final audit (protocol §7) passes. If the audit fails, fix what it found, run one more round, then stop regardless. One clean griller pass alone is not enough; a lenient griller is the cheapest way for the loop to lie to itself.
- **Diminishing returns.** A round changed fewer than 2 nodes and added none. Audit; pass is `converged`, fail is `budget-exhausted`.
- **Budget.** `--rounds` reached. Audit, `budget-exhausted`. A run still adding nodes at the budget usually has an interpretation problem; say so instead of asking for more rounds.

## Deliver

Finalize `PRD.md` per the template. Section order is review order: confirm list (ranked by uncertainty × blast radius, protocol §5), requirements tree, acceptance cases, assumptions register, sources. Set Status and report with the confirm items in full, so the user can answer from chat:

```
AFK grill done: converged in 3 rounds (budget 5) · 41 nodes · 18 acceptance cases
PRD: docs/prd/offline-sync/PRD.md   log: docs/prd/offline-sync/grill-log.md

Confirm (answer inline or here):
C1 [R0]  Does "offline" mean read-only cache or queued writes?   default: queued writes
C2 [D1]  Conflict policy: (a) last-write-wins (b) server-wins (c) manual   default: (b)
C3 [A2]  Keep queued writes 7 days then drop?                    default: yes
Then: /afk-grill docs/prd/offline-sync/PRD.md   (optionally mark ✂️ ❌ ✏️ ✅ on any line first)
```

Do not start implementing. The approved PRD is the input to planning.

## Re-align

The user answers the confirm items and optionally marks nodes; syntax in `references/prune-and-realign.md`, and chat answers work the same. Apply their input as `[H]`, retire pruned subtrees, reopen only the nodes that depended on what changed, run the loop on that frontier with everything else frozen, regenerate the affected T-cases, bump the version, append to the log. No marks and no unanswered items sets Status `approved`.

A human answer that contradicts cited evidence wins the PRD, with the citation kept beside it as a visible conflict. They may not know the code moved, or the code is what the requirement changes.

## Rules

- Never ask the user mid-loop except on NO-GO; questions go to the confirm list.
- Never renumber IDs; the user refers to them.
- Never exceed 5 confirm items or 12 questions per round; prioritize instead. The human's ten minutes are what this design protects.
- `PRD.md` holds claims and tags. Reasoning, rejected answers, and round history live in `grill-log.md`.
