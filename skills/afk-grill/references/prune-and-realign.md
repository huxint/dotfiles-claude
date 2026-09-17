# Confirm, prune, re-align

The user's review costs about ten minutes: answer the confirm items, optionally mark a few nodes. Your job is to apply that input with maximum leverage and re-run the loop on the smallest frontier that could have changed.

## 1. Reading the review

Marks can be inline in `PRD.md` or given in chat ("C1 queued writes, C2 = b, prune R7, R4.3 is wrong, the client already retries"). Treat both identically.

| Mark (emoji or ASCII) | Meaning | Effect |
|---|---|---|
| `C1 → text` after the arrow, or "C1: text" in chat | Confirmation | Node becomes `[H]`; its subtree reopens only if the answer differs from the default taken |
| `✅` or `[OK]` at the start of a line | Approved | Node and subtree frozen; the griller may not question them |
| `✏️` or `[EDIT]` at the start of a line the user rewrote | Ground truth | Node becomes `[H]` with the new text; dependents reopen |
| `❌` or `[WRONG] note` | Wrong | Node reopens with the note as an `[H]` constraint; subtree and dependents reopen; the note may retire children |
| `✂️` or `[PRUNE]` | Out of scope | Node and subtree retired (IDs kept, listed in the log); dependents reopen; T-cases covering only retired nodes retire |
| A `## Review notes` block anywhere | Free-form guidance | Applied as `[H]` constraints on the nodes it names; guidance naming no node goes to R3 scope or the log |

An unmarked node is neither approved nor rejected; it keeps its state. Only `✅` freezes.

Confirm items left unanswered: keep the default, keep them on the list, say so in the summary. Don't nag and don't invent an answer.

## 2. Conflicts between the human and the evidence

When an `[H]` input contradicts an `[E]` or `[C]` node, the human wins the PRD, but not silently. Keep the citation beside the human's statement as `⚠ conflicts with <citation>` and add a T-case that makes the intended behaviour explicit. The human may not know the code moved, or the code is what the requirement is changing; either way it must stay visible, not get overwritten.

## 3. Reopen set

Compute this before re-running anything:

1. **Changed** = nodes that received `[H]`, `❌`, `✂️`, or a confirm answer that differs from the default.
2. **Reopen** = every node under a changed node, plus every node whose `depends-on` names a changed node, plus every A/D entry derived from a changed node, plus every T-case covering a changed or reopened node.
3. **Frozen** = `✅` nodes and their subtrees, plus every node that is neither changed nor reopened. The one legitimate reason for the griller to touch an unmarked node is a failed citation check; allow that.

Small reviews should produce small reopen sets. If one answer reopens most of the tree, the interpretation was wrong: say so and treat it as a new run with the human's answers pre-applied as `[H]`.

## 4. Re-run

- Bump Version (v2, v3, …), set Status `in-progress`, append `## Re-align v2` to the log with the change set: marks received, reopen set, frozen count.
- Run the loop from `loop-protocol.md` §3 on the reopen set only. Pass the frozen IDs to the griller every round. Budget: `--rounds` or 3, whichever is smaller; re-align rounds are cheap because the frontier is small.
- Regenerate T-cases for reopened nodes. Keep an ID when the behaviour is unchanged, assign a new one when it is not.
- Rebuild the confirm list from the new ranking. Items the human answered never return; new items may appear only from reopened nodes.
- Deliver with the same summary block as Phase 3, plus one line: `since v1: 3 confirmed · 1 pruned (R7) · 9 nodes re-grilled · 4 T-cases changed`.

## 5. Approval

A review with no marks and no unanswered confirm items, or an explicit "approved", "LGTM" or "通过", sets Status `approved`. Say where the PRD is and stop. Implementation is a separate task with its own plan; the T-cases are its acceptance gate.
