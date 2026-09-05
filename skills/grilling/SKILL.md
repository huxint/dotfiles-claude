---
name: grilling
description: "Grill a plan, decision, or idea to expose assumptions and trade-offs. Use when the user asks to be grilled or stress-test their thinking."
---

# Grilling

Interview relentlessly about decisions that could change the plan. Organize them as a **design tree** rooted in the user's goal, constraints, and success criteria. Its branches are consequential choices within that scope.

The **frontier** contains open decisions whose prerequisites are settled. Work the tree in rounds; each answer can expose new branches.

## Each round

1. **Establish the frontier.** Separate known facts, accepted decisions, assumptions, and open questions. A question that depends on another unanswered question belongs to a later round.
2. **Resolve discoverable facts.** Inspect available code, files, and tools before asking the user. Delegate independent research when agent tools are available and it would help; otherwise inspect directly. Pending research blocks only dependent questions. Mark unavailable evidence explicitly.
3. **Ask the frontier together.** Number each question, identify the decision, recommend an answer with its trade-off, and explain what evidence would change that recommendation. Ask the user for choices or information only they can supply.
4. **Reconcile the answers.** Wait for the user's response before advancing dependent branches. Record settled decisions, challenge contradictions with concrete consequences, and carry unanswered questions forward. A recommendation or silence leaves a decision open.

Probe goals, feasibility, dependencies, failure modes, reversibility, and success measures where they affect the outcome. Test assumptions with concrete cases. Reopen an accepted decision only when new evidence or a conflicting answer changes its basis.

## Completion

The interview is ready to close when every consequential branch in scope has a decision, an explicitly accepted assumption, or a user-approved deferral, and no unresolved blocker is hidden. Present the resulting plan and remaining trade-offs for confirmation.

If the user confirms, finish the interview and follow any existing authorization for implementation. If the user stops earlier, summarize the settled decisions and open branches. Research can proceed during the interview; implementation waits until the relevant decisions are confirmed.
