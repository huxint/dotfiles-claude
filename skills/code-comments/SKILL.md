---
name: code-comments
description: "Engineering comment standards: comment only where it earns its keep — explain the 'why', never restate the 'what'; ban decorative garbage comments (numbered headers, tab alignment, corner-bracket quotes, asterisk banners). Use when writing code, reviewing code, or cleaning up existing comments."
---

# Engineering Comment Standards

A comment is for the maintainer, not for decorating the code. A comment's value = the understanding time it saves − the cost of keeping it in sync. Before writing one, ask: what does the reader lose if this comment is deleted? If the answer is "nothing", delete it.

## Comment when

1. **A non-obvious "why"** — workarounds, historical reasons, performance trade-offs, why not the simpler approach.
2. **Code that can't explain itself** — complex algorithms, regexes, bit operations, state machines: state the intent, don't translate the steps line by line.
3. **Implicit constraints and preconditions** — calling order, concurrency assumptions, immutability invariants, external facts the code depends on.
4. **Public API key behavior** — edge cases, side effects, error conditions, return-value contracts.
5. **TODO / FIXME** — always with a reason and an issue number or date, never a bare phrase.

## Don't comment when

- **The code already says it**: `// sum the list` next to `sum(items)` — remove.
- **The name already says it**: `// compute the total price` next to `computeTotalPrice(...)` — remove.
- **Decorative section banners**: `// ============ utility functions ============`, `// ----- part 2 -----` — remove. Boundaries come from refactoring and naming, not banners.
- **Changelog entries**: `// 2024-01-01 fixed the bug` — that's what git history is for.
- **Line-by-line translation**: `i++  // increment i` — remove.

## Format rules (hard bans)

- ❌ Numbered headers: `// 1. validate input`, `// ① initialize` (numbered steps inside a genuinely multi-step algorithm are the exception)
- ❌ Corner-bracket quotes around identifiers: `// the 「cache」 is shared` → write `// cache is shared`
- ❌ Tab or equals-aligned columns: `// name      : xxx`
- ❌ Asterisk, pipe, or dash banner frames; emoji; tildes for decoration
- ✅ Comments sit next to the code they explain: a blank line before a block comment, an end-of-line comment attached to its own statement
- ✅ When you change code, re-read the neighboring comments and fix anything that no longer holds

## Writing

- One comment says one thing, directly: `// binary search instead of linear: items are sorted and can be tens of thousands long`
- A comment is harder to write than code: it must say the part the code doesn't
- Don't use comments to excuse bad code — refactor what you can't explain, and only comment what you still can't
- Docstrings and inline comments have different jobs: docstrings tell callers *what it is / how to use it*; inline comments tell maintainers *why it's written this way*
