# Confirm, prune, re-align

The review costs the user about ten minutes. Apply it with maximum leverage and re-run the loop on the smallest frontier that could have changed.

## 1. Marks

Inline in `PRD.md` or in chat ("C1 queued writes, C2 = b, prune R7, R4.3 is wrong, the client already retries"); both are read the same way.

| Mark | Meaning | Effect |
|---|---|---|
| `C1 → text` in the file, or "C1: text" in chat | Confirmation | Node becomes `[H]`; its subtree reopens only if the answer differs from the default taken |
| `✅` or `[OK]` | Approved | Node and subtree frozen; the griller may not question them |
| `✏️` or `[EDIT]` on a rewritten line | Ground truth | Node becomes `[H]` with the new text; dependents reopen |
| `❌` or `[WRONG] note` | Wrong | Node reopens with the note as an `[H]` constraint; subtree and dependents reopen; the note may retire children |
| `✂️` or `[PRUNE]` | Out of scope | Node and subtree retired (IDs kept, listed in the log); dependents reopen; T-cases covering only retired nodes retire |
| A `## Review notes` block | Free-form guidance | `[H]` constraints on the nodes it names; guidance naming no node goes to R3 scope or the log |

An unmarked node keeps its state; only `✅` freezes. Unanswered confirm items keep their default, stay on the list, and are named in the summary. Never invent an answer.

## 2. Human versus evidence

When `[H]` contradicts an `[E]` or `[C]` node, the human wins the PRD, not silently: keep `⚠ conflicts with <citation>` beside the statement and add a T-case that makes the intended behavior explicit.

## 3. Reopen set

Compute it before re-running anything:

- **Changed**: nodes that received `[H]`, `❌`, `✂️`, or a confirm answer differing from the default.
- **Reopen**: everything under a changed node, every node whose `depends-on` names one, every A/D entry derived from one, and every T-case covering a changed or reopened node.
- **Frozen**: `✅` subtrees and every node neither changed nor reopened. The griller may touch a frozen node only on a failed citation check.

If one answer reopens most of the tree, the interpretation was wrong: say so and treat it as a new run with the answers pre-applied as `[H]`.

## 4. Re-run

- Bump Version, set Status `in-progress`, append `## Re-align v2` to the log with the marks received, the reopen set, and the frozen count.
- Run the loop on the reopen set only, passing the frozen IDs to the griller every round. Budget: `--rounds` or 3, whichever is smaller.
- Regenerate T-cases for reopened nodes: keep the ID when the behavior is unchanged, assign a new one otherwise.
- Rebuild the confirm list from the new ranking. Answered items never return; new items come only from reopened nodes.
- Deliver with the same summary block as a first run, plus one line: `since v1: 3 confirmed · 1 pruned (R7) · 9 nodes re-grilled · 4 T-cases changed`.

## 5. Approval

No marks and no unanswered confirm items, or an explicit "approved", "LGTM", "通过": set Status `approved`, say where the PRD is, and stop. Implementation is a separate task with the T-cases as its acceptance gate.
