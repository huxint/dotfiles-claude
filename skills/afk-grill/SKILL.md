---
name: afk-grill
description: Unattended requirement alignment (an AFK grill loop) that turns a one-line requirement into a PRD without interviewing the user node by node. A fresh-context griller subagent asks what /grilling would ask, a researcher subagent answers from the project's own code, docs and conventions with citations, and rounds repeat until nothing is silently assumed. The output is built for a ten-minute human review - the 3 to 5 most uncertain nodes to confirm, acceptance cases that backstop every other node, and a provenance tag on every claim; the user confirms or prunes and the loop re-runs only the affected subtree. Use whenever the user says afk grill, self grill, grill it yourself, 自动对齐需求, AFK 循环, 自己展开需求树, 帮我出 PRD, wants a PRD or spec generated from a brief without being interviewed, or hands back a reviewed PRD to re-align. Needs an existing project with code and docs to draw on; on a greenfield project stop and point to /grilling instead.
argument-hint: <requirement or brief.md> | <path/to/PRD.md> [--rounds N] [--out DIR] [--inline]
---

# AFK Grill

`/grilling` (its protocol is in `references/grilling.md`) aligns a requirement by walking the design tree breadth-first with the user answering every frontier question. That guarantees nothing is silently assumed, but it costs hours. This skill keeps the tree and the BFS and moves the human out of the loop: a **griller** subagent asks, a **researcher** subagent answers from the project itself, and you (the orchestrator) merge rounds until the tree converges. The human then spends about ten minutes on the only things evidence cannot settle.

Two ideas make an unattended loop safe:

- **A tiny confirm surface.** After the tree converges, rank nodes by uncertainty and surface the 3 to 5 most uncertain for the human to confirm. Everything else gets a defensible default and a provenance tag.
- **Acceptance cases backstop the rest.** Every behaviour node maps to a concrete acceptance case written in the project's own test style. A node the human never read is still pinned: if the implementation drifts from the PRD, a test complains before a person has to.

Two preconditions, both enforced below: the project has iterated long enough to have conventions, docs and code to draw on; and the loop's goal and pass conditions are concrete, not "until it feels done".

## Modes

The invocation arguments are: `$ARGUMENTS`. Pick the mode:

| Argument | Mode |
|---|---|
| Free text, or a path to a file without the `<!-- afk-grill: prd -->` marker | **New run**; the text or file is the requirement brief |
| Path to a PRD with the marker and `Status: in-progress` | **Resume** the loop from the grill log (`references/loop-protocol.md` §11) |
| Path to a PRD with the marker plus review marks or answered confirm items | **Re-align**; read `references/prune-and-realign.md` |
| Path to a finished PRD (Status `converged`, `budget-exhausted`, `escalated` or `approved`) with no marks and no answers | Nothing to run; show the confirm list again and how to mark or answer, then stop |
| Nothing | Ask for the requirement (one sentence is enough), then New run |

Flags anywhere in the arguments: `--rounds N` (default 5), `--out DIR` (default `docs/prd/<slug>/`), `--inline` (no subagents: you play griller and researcher yourself per `references/loop-protocol.md` §12; use it when subagents are unavailable or the user wants a cheap run, and expect a more lenient griller). Read `references/loop-protocol.md` before the first round of a new run or resume; this file gives the shape, that file gives the mechanics.

## Phase 0: Preflight (never skip)

Why: the loop can only answer questions from evidence. On a codebase without conventions it still converges, by inventing assumptions and dressing them as facts. That hides deviation instead of controlling it.

1. **Inventory alignment sources.** Look for CLAUDE.md, README, `docs/`, ADRs or RFCs, earlier PRDs, API schemas, migrations, test suites, CI config, and the repo's age and activity (`git log --oneline | wc -l`, `git log -1 --format=%cd`). Note the test framework and where acceptance-level tests live; the T-cases will be written in that style.
2. **Verdict.** GO when there is real code plus at least one source of conventions (a doc, or a codebase consistent enough to infer them). Otherwise NO-GO: stop, say what is missing, and offer `/grilling` for an interactive session, or ask for a short seed brief (goal, users, constraints, non-goals) to re-run with. Never run the loop on a NO-GO; an unattended loop on a blank project produces confident fiction.
3. **Interpretation check.** List 2 or 3 readings of the requirement. Pick the one the project's context supports and record the rejected ones. If the readings diverge enough to change most of the tree, the interpretation becomes confirm item C1: take the most plausible reading and continue, don't block.
4. **Launch card.** Print it and continue immediately. The user may already be away and can interrupt if they want changes.

```
AFK grill: launch
Requirement:    <verbatim>
Interpretation: <chosen>  (rejected: <others>)
Sources:        CLAUDE.md, docs/architecture.md, 12 ADRs, tests/e2e (pytest) · repo: 2y, 1,340 commits
Output:         docs/prd/<slug>/PRD.md + grill-log.md
Budget:         ≤5 rounds · ≤12 questions/round · confirm list ≤5
```

## Phase 1: Seed the tree

Create `PRD.md` from `references/prd-template.md` with Status `in-progress`, and `grill-log.md` opening with the launch card. Writing the file first matters: the griller must attack a clean artifact rather than your reasoning, and an interrupted run leaves something resumable.

Expand the root into the ten fixed dimensions (R1 goal, R2 users, R3 scope, R4 behaviour, R5 data, R6 interfaces, R7 non-functional, R8 dependencies, R9 rollout, R10 acceptance). Then run **round 0**, researchers only: for each dimension, ask what already exists in the project that this requirement touches and which conventions apply. Merge the answers so the griller's first pass attacks a draft with evidence, not a skeleton. Mark a dimension `[N/A: reason]` only with a reason the griller can check.

## Phase 2: The loop

Each round, in order:

1. **Griller.** Spawn a fresh `general-purpose` agent with the verbatim prompt in `references/griller-prompt.md`. It sees only the requirement, the current `PRD.md`, and the frozen IDs. Never the grill log, never your reasoning, and never a `fork`: a forked agent inherits your context and with it your blind spots, and a reviewer that has seen the reasoning is biased toward agreeing with it. It returns at most 12 prioritized questions with node IDs and a verdict.
2. **Researchers.** Add any open nodes you know the griller missed, dedupe against the log, cap the batch at 12 by priority, group by area, and spawn 2 to 4 `general-purpose` agents in one message with the verbatim prompt in `references/researcher-prompt.md`. They answer with citations or say the project is silent. Reusing a researcher across rounds via SendMessage is fine: accumulated codebase knowledge helps it and cannot bias it, since every answer must still cite. Never reuse a griller.
3. **Merge.** Update `PRD.md`: node states, new child nodes the answers unlock, IDs appended and never renumbered. Reject any answer whose citation does not exist or does not say what is claimed, and re-ask it next round. Append the round to `grill-log.md` (questions, answers, evidence, state changes).
4. **Check the pass conditions** below. Continue or stop.

You may answer a griller question yourself only when you can cite evidence already read in this session, to the same standard as a researcher. Never answer from general knowledge; that is exactly the deviation the loop exists to prevent.

### Node states

| State | Tag | Requires |
|---|---|---|
| Resolved | `[E: path:line]` or `[E: doc#section]` | A citation a reader can open that says this |
| Convention | `[C: path, path]` | At least 2 consistent examples in the repo |
| Assumed | `[A#]` | No evidence; a default, why, and what breaks if wrong, all registered |
| Decision | `[D#]` | Evidence cannot settle it (product or business choice); options plus the recommended default the PRD currently follows |
| Human | `[H]` | Set only from the user's confirmations or edits during re-align |
| Not applicable | `[N/A: reason]` | A reason the griller can challenge |

An honest `[A]` beats a fake `[E]`. The loop's goal is not "no open questions"; it is "nothing silently assumed", the same bar `/grilling` sets.

### Pass conditions

The loop stops at the first of these:

- **Converged.** The griller returns no blocking or major questions AND the final audit passes (`references/loop-protocol.md` §9: sample citations, T-case coverage, untagged claims, scope). One clean griller pass alone is not enough; a lenient griller is the cheapest way for the loop to lie to itself.
- **Diminishing returns.** A round changed fewer than 2 nodes and added none: run the audit and stop.
- **Budget.** `--rounds` reached (default 5): audit, stop, Status `budget-exhausted`.
- **Escalated.** More than 5 nodes are `[D]` with real blast radius, or the root interpretation blocks most of the tree: stop early with Status `escalated`. More unattended rounds cannot settle what only the human can; recommend `/grilling` on just those nodes.

## Phase 3: Deliver

Finalize `PRD.md` per the template. Section order is review order:

1. **Confirm these.** 3 to 5 nodes ranked by uncertainty × blast radius (rule in the protocol §6). Each: the question in one line, the default the PRD took, why it is uncertain, what changes if wrong. Hard cap 5; overflow goes to the assumptions register with a default and a T-case.
2. **Requirements tree.** Every node with ID and provenance tag, written in the requirement's language; IDs and tags stay ASCII.
3. **Acceptance cases.** `T#` given/when/then in the project's test style, each naming the R-nodes it covers. Every behaviour node and every assumption outside the confirm list has at least one.
4. **Assumptions register** and **sources**.

Set Status (`converged`, `budget-exhausted`, or `escalated`) and report in this shape, with the confirm items in full so the user can answer from chat without opening the file:

```
AFK grill done: converged in 3 rounds (budget 5) · 41 nodes · 18 acceptance cases
PRD: docs/prd/offline-sync/PRD.md   log: docs/prd/offline-sync/grill-log.md

Confirm (answer inline or here):
C1 [R0]  Does "offline" mean read-only cache or queued writes?   default: queued writes
C2 [D1]  Conflict policy: (a) last-write-wins (b) server-wins (c) manual   default: (b)
C3 [A2]  Keep queued writes 7 days then drop?                    default: yes
Then: /afk-grill docs/prd/offline-sync/PRD.md   (optionally mark ✂️ ❌ ✏️ ✅ on any line first)
```

Do not start implementing. The approved PRD is the input to planning; this skill ends at alignment.

## Phase 4: Confirm, prune, re-align

The user answers the confirm items and optionally marks nodes; the syntax is in `references/prune-and-realign.md`, and chat answers work the same way. Apply their input as `[H]` ground truth, retire pruned subtrees, reopen only the nodes that depended on what changed, run the loop on that frontier with everything else frozen, regenerate the affected T-cases, bump the version, append to the log. A review that comes back with no marks and no unanswered confirm items sets Status `approved`.

If a human answer contradicts cited evidence, keep the human's answer but flag the conflict beside it with the citation. They may not know the code moved, or the code is what the requirement is changing; either way it stays visible.

## Guardrails

- Never ask the user mid-loop except on NO-GO. Silence is the feature; questions go to the confirm list.
- Never renumber IDs across versions; the user refers to them.
- Never let the griller see reasoning, and never let a researcher decide a product question; it classifies it `[D]` with options.
- Never let the confirm list grow past 5 or a round past 12 questions; prioritize instead. The human's ten minutes are the scarce resource this design protects.
- Keep `PRD.md` to claims and tags. Reasoning, rejected answers and round history live in `grill-log.md`.

## Files

- `references/loop-protocol.md`: round mechanics, uncertainty ranking, T-case rules, audit, budgets, log format, resume. Read at the start of every new run or resume.
- `references/griller-prompt.md`: verbatim prompt for the griller. Copy it; do not paraphrase.
- `references/researcher-prompt.md`: verbatim prompt for researchers.
- `references/prd-template.md`: exact PRD skeleton, ID scheme, tag legend.
- `references/prune-and-realign.md`: review mark syntax and the re-align procedure.
