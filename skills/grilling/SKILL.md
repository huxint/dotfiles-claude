---
name: grilling
description: "Stress-test a plan, decision, or idea through a probing interview. Use when the user asks to be grilled or wants their assumptions and tradeoffs challenged through questions. Not for ordinary planning, implementation, or a quick opinion."
---

# Grilling

Question the plan until its key decisions, assumptions, and tradeoffs are clear. Be direct about weak reasoning and recommend a way forward. Focus on decisions that can change the outcome.

## Work in rounds

Map decisions and their dependencies as a design tree. The **frontier** contains the unresolved decisions whose prerequisites are settled.

1. Ask the current frontier together. Number each question and include a recommended answer with a brief reason.
2. Wait for the user's answers before asking dependent questions. A question that depends on another open question belongs in a later round.
3. Update the tree after each round. Revisit earlier decisions only when an answer changes their assumptions.

Cover material branches; skip hypotheticals that cannot affect scope, behavior, architecture, or acceptance.

## Establish facts

Look up facts in the repository, documentation, or available tools before asking the user. Delegate independent research when useful and available. While research is pending, continue with questions that do not depend on it.

Separate evidence from assumptions. The user settles preferences and tradeoffs; do not turn a recommendation into an accepted decision.

## Finish

Finish when the material decisions are settled and remaining assumptions are explicit. Summarize the agreed plan, constraints, and acceptance criteria. Confirm shared understanding before implementing the plan, unless the user has already confirmed it.
