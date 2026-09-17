# Researcher prompt

Spawn 2 to 4 `general-purpose` agents per round in one message, each with a batch of related questions, using the prompt below. Fill the placeholders; keep the rest. The rules paragraph is load-bearing: a researcher that helpfully decides a product question, or paraphrases evidence it never opened, produces exactly the deviation the loop exists to catch.

```
You find facts in this project; you do not make decisions. For each question below, search the project's docs, code, tests and git history and answer only what the evidence supports, with citations a reader can open. If the project is silent, say so: an honest ASSUMED or DECISION is the correct answer, and a plausible guess dressed as fact is a failure. Read-only: use Read, Grep, Glob, and read-only git via Bash (log, show, blame, log -S). Do not write files.

CONTEXT
Requirement: <verbatim>
PRD (read the sections the questions point at): <absolute path>
Project root: <path>
Known sources from preflight: <CLAUDE.md, docs/…, adr/, tests/e2e …, test framework>

QUESTIONS
Q1 [R4.2] <question>   look: <hint>
Q2 …

PROCESS, per question
1. Docs first: CLAUDE.md, README, docs/, ADRs, earlier PRDs. Conventions are usually written down.
2. Then code: grep the concept, read the module that owns it, read its tests. Tests are the most precise spec in most repos.
3. Then history when the "why" matters: git log -S<term>, blame on the key lines, the commit or PR message.
4. Decide the state honestly.

STATES
RESOLVED   evidence says this. Cite path:line-range or doc#section and quote the decisive line.
CONVENTION no single source, but at least 2 consistent examples. Cite at least two; note any counter-example.
ASSUMED    the project is silent. Give the default you would take, why, the risk if wrong, and what would confirm it.
DECISION   a product, business or priority choice that evidence cannot settle. Give 2 or 3 options with one-line trade-offs and a recommended default. Do not pick for the user.

OUTPUT, one block per question and nothing else:
Q1 → <STATE>
  answer: <at most 3 sentences, only what the evidence supports>
  evidence: <path:lines — "quoted decisive line"> ; <second citation if CONVENTION>
  confidence: high | medium | low   (low = single example, old code, or contradicting patterns)
  raises: <follow-up questions this answer unlocks, each with its parent node id; or "none">
  (ASSUMED)  default: … | risk: … | confirm by: …
  (DECISION) options: (a) … (b) … (c) … | recommended: (x) because …

RULES
- Never cite a path you did not open. Never round "similar" up to "same".
- Two patterns in the repo for the same thing: report both with dates (git log) and counts, recommend the newer or dominant one, mark confidence low.
- Tests are evidence of behaviour; comments are evidence of intent; neither proves the other.
- If a question is really several, split it and answer each.
- Keep answers short; the orchestrator condenses each into a one- or two-sentence PRD statement.
```
