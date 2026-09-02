---
name: code-naming
description: "Naming standards: function, variable, class, and constant names must be concise, precise, and say exactly what they mean in their current context; ban bloated names (action chains, filler words, implementation details in names). Use when writing new code, refactoring, or reviewing names."
---

# Naming Standards

A good name has one criterion: **the reader knows what it is and what it does at first glance, without reading the implementation.** A name is the most-read comment in the code — it speaks for you, so it can't require explanation.

## Three principles

1. **Concise** — two to four words: `verb + noun` (functions), `adj + noun` (variables). If it can't fit, the abstraction is wrong; adding words is not the fix.
2. **Precise** — says exactly what it means **in its current context** — not vague, not misleading, not overstated.
3. **Not overdone** — no stacks of qualifiers, no implementation details, no repeated context.

## Anti-patterns (bad names)

- ❌ **Action chains**: `validateAndProcessAndSaveUser` → split into single-purpose functions and name each one.
- ❌ **Filler words**: `userData` / `userInfo` / `userHelper` / `userManager` / `userUtils` — data, info, helper, manager, utils are filler in most cases. Try deleting them.
- ❌ **Repeated context**: `orderStatus` inside class `Order` → `status` is enough; `paymentProcessor` in module `payment.go` → `processor`.
- ❌ **Implementation details in names**: `getUserFromDatabaseById` → `getUser` (the source is internal); `loadConfigFromJsonFile` → `loadConfig` (the file format is internal, unless the format is the key decision the caller is making).
- ❌ **Mechanism instead of intent**: `processItems` → unknowable until you read the body; `applyDiscount` → the name is the intent.
- ❌ **Vague words**: `temp`, `data`, `stuff`, `thing`, `xxx1` / `xxx2`.
- ❌ **Over-abbreviation**: `usrCnt`, `cfgPrms` — an abbreviation must be instantly clear to every reader, otherwise spell it out.
- ❌ **Double negatives**: `isNotUnavailable`, `disableFlagEnabled`.

## Standards by kind

**Functions / methods**
- Verb first: `get` / `set` / `create` / `update` / `delete` / `send` / `parse` / `convert`…
- Boolean returns: `is*` / `has*` / `can*` / `should*` — reads as a question: `isExpired`, `hasPermission`
- Non-boolean returns: the name says what it returns: `getTotalPrice()`, `parseTimestamp()`
- Side effects must be visible in the name: `save()` is not `validate()`, `remove()` is not `check()`

**Variables**
- Nouns, with accurate singular/plural: `items` (collection) vs `item` (one)
- Locals can be short (`i`, `buf` inside a 5-line scope is fine); anything crossing function or module boundaries must stand alone
- Booleans read as statements of fact: `isActive`, `canEdit` — not `flag` / `mark`

**Constants / enums**
- Name the business meaning, not the literal: `MAX_RETRY_COUNT = 3` is good, `NUMBER_3` is garbage
- A constant is a named decision

**Classes / modules**
- Nouns that answer "what is it": `UserService`, `PriceCalculator`
- Single responsibility is what makes a good name possible; struggling to name it is a sign the responsibility is muddled

## Checklist

- [ ] Can you say what it is at first glance, without reading the implementation?
- [ ] Does the name leak implementation details (source, format, algorithm)?
- [ ] Does it repeat context the enclosing class/module already gives?
- [ ] Any filler words (data / info / helper / tmp / old / new)?
- [ ] Renaming is nearly free — naming is the first-class refactor; fix names as you find them, don't accommodate old ones
