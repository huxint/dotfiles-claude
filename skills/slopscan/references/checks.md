# Slop checks

For each category: what to look for, how to establish it, the better form, and the exceptions. A candidate becomes a finding only with a location, the better form written out, and what the change removes. Examples identify patterns; code that looks the same may carry a different contract.

## A. Over-defense

A guard is dead when the condition it tests cannot hold where it stands. Establish that from the code, not from intuition.

- Trace the guarded value to its origin: a constructor that always sets the field, a parser that raises on malformed input, a signature that types the parameter, a caller that validated already. Cite the line that makes the check dead.
- Look for `try/except` around code that cannot raise; `except Exception` handlers that log and continue; `isinstance` or `hasattr` on values the types settle; `if x is not None` on a value with no `None` path; `if len(xs) > 0` before a `for`; a defensive copy of data nobody mutates; a fallback default for required configuration; a retry around a deterministic failure; the same input validated at every layer it passes through.
- Better form: delete the check and let the guarantee carry it. When the guarantee is only implicit, make it explicit once at the boundary (a type, a validation at the entry point, an assertion that names the invariant) and delete the downstream copies.

Exceptions: trust boundaries (user input, network, files, databases, third-party responses); a documented contract that promises the check; an invariant the language cannot express; behavior that varies across supported versions of a dependency. In a dynamically typed language an annotation alone is not a runtime guarantee unless something validates it.

## B. Needless wrapping

A layer earns its place by changing something: the arguments, the error contract, the lifecycle, or the name the call site reads.

- Look for a function whose body is one call forwarding the same arguments; a class with one method and no state; a local wrapper around a standard-library or dependency call that adds no argument, default, or error translation; accessors that only return or assign a field; an exception subclass with no extra field and no handler that distinguishes it; a decorator or context manager around one statement; a chain of re-exports; a layer whose removal leaves every caller working unchanged.
- Read the callers. A wrapper with one caller is inlined; a wrapper with many still needs a reason beyond brevity.
- Better form: call the thing directly. If the wrapper's name carried meaning, keep the meaning as a named argument or a comment at the call site.

Exceptions: a seam a test replaces; a boundary the project intends to swap (a vendor call behind one name); public API surface that outside code depends on; one place that hides a genuinely ugly call.

## C. A better form exists

The first form that worked is rarely the simplest. For every branch, loop, and data structure, ask what would make it unnecessary.

- **Special cases.** A branch for the first, last, empty, or missing element; a check that runs on every iteration for a condition that holds on one. Look for the structure that makes the case ordinary: a lookup with a default, a `defaultdict`, an accumulator seeded so the first iteration needs no test, a loop over adjacent pairs instead of an index minus one, an indirection one level up so the first element takes the same path as the rest.
- **Control flow.** A `found` flag plus `break` where `any`, `next`, or `for/else` says it; nested `if` where a guard clause and early return flatten; `if c: return True else: return False`; an `elif` chain on one value that is a dictionary; `try/except KeyError` where `.get` was meant, or the reverse.
- **Loops.** A manual index that `enumerate` provides; index-based parallel iteration that is `zip`; a count, sum, min, or max built by hand; a list built to be consumed once; a membership test against a list inside a loop.
- **Data.** Parallel lists that are one list of records; a tuple unpacked positionally in several places; a value computed twice, or stored when deriving it is free; a boolean parameter that selects between two functions; a string that encodes a structure the code then parses back.
- Better form: write it. If it does not fit in the table, put the code block under the table and point to it.

Exceptions: an idiom the project does not use and would find foreign; a longer form that carries a needed name or comment; performance-motivated code backed by a measurement; a form the project's toolchain cannot express.

## D. Wrong level of abstraction

Judge each layer by whether it separates things that change for different reasons. Caller count does not settle this; the reason to change does.

- **Too high.** A base class with one subclass; an interface with one implementation; a registry, factory, or plugin loader with one entry; a strategy pattern for two branches; a generic parameter instantiated once; a config object holding two constants; an event bus with one subscriber. Better form: collapse to the concrete thing, and keep a seam only where a second variant is scheduled, not imaginable.
- **Too low.** The same block repeated with one name changed; rules interleaved with I/O, logging, and formatting in one long function; eight positional parameters that are one record; a dictionary passed around where a type would carry the fields and their invariants; a module that is a bag of unrelated functions. Better form: name the concept the repetition circles, extract it, and let each call site read as the rule it expresses.
- **Mixed.** One function that parses, validates, persists, and renders; a domain rule in `utils`; a database call inside a formatting helper; presentation strings in a model. Better form: one responsibility per function, the domain rule at the level of the domain.

Exceptions: an abstraction the framework or a public contract requires; an extension point the task or the docs name; duplication between modules meant to evolve independently (similar text alone does not prove a shared concept).

## E. Padding

Words that carry no information the reader lacks.

- Comments that restate the next line, the signature, or the loop; docstrings that list parameters the types already declare; banners; changelog lines and session remarks ("as requested", "fixed per review"); commented-out code; a `TODO` with no owner or reason.
- `# type: ignore`, `# noqa`, `@ts-ignore`, `as any` on a line with a real mismatch underneath.
- Logging that narrates control flow; decorated progress output in library code; a message that restates the return value.
- Filler names (`data`, `info`, `item`, `helper`, `manager`, `utils`, `process`, `handle`, `result`, `temp`) where the concept has a name; draft names (`newX`, `xV2`, `fixedY`, `old_`, `_backup`) that mean something only to whoever saw the previous version.
- Better form: delete, or replace with the rationale, invariant, or caller contract the code cannot say. A filler name becomes the concept.

Exceptions: invariants, workarounds with their reason, public API contracts, legal notices, tool directives, doc examples; names a framework or protocol imposes; established local shorthand.

## F. Leftovers and creep

Things in the diff the task did not need.

- Unreachable branches; unused imports, options, and configuration keys; an old implementation kept beside its replacement; a flag that always takes one value; a stub (`pass`, `raise NotImplementedError`, `return None  # TODO`) on a path the task requires.
- Renames, formatting sweeps, dependency additions, and behavior changes outside the requested outcome. Proximity to touched code is not a reason.
- Check exports, registries, configuration, reflection, and dynamic references before calling code unused.
- Better form: delete the leftover; move the creep to its own change.

Exceptions: abstract methods; deferred work tracked outside the task with an owner; placeholders in documentation and templates; a supporting change across a module boundary that the requested behavior needs.

## G. Silent failure and fabricated data

Keep failures and required data explicit at the boundary that owns them.

- Trace swallowed exceptions, catch-and-log paths that still report success, and error sentinels no caller checks.
- Check defaults on required fields: a missing amount becoming zero, a missing timestamp becoming now, coercion that hides malformed input.
- Look for consumer-side cleanup compensating for a producer's bug, input-specific branches, magic offsets, and test expectations edited to match a defect.
- Better form: let the failure surface where it happens, or handle it with a decision the caller can see (a bounded retry, degradation the contract defines, a report). Fix a wrong value at its producer.

Exceptions: optional fields with meaningful defaults; bounded transient recovery; degradation the contract defines; validation at trust boundaries; a third-party workaround with the upstream issue named.

## H. Misused APIs and unsafe code

Verify unfamiliar calls against the installed version; trace unsafe operations to their inputs.

- Symbols, imports, argument names, return values, and versions absent from the lockfile or the type definitions. An unavailable lookup is a verification gap, not proof of invention; record it.
- Semantic traps: `strip` as prefix removal; the return value of an in-place `sort`; a generator consumed twice; an unawaited coroutine; a mutable default argument; string comparison of versions or numbers; float equality; naive and aware datetimes mixed.
- Untrusted input reaching SQL, shell, HTML, `eval`, or deserialization without parameterization or escaping; embedded credentials; disabled certificate checks; blocking calls in async paths; shared mutable state without an owner; resources without reliable cleanup.
- Better form: the correct call, the parameterized query, the awaited call, the explicit tolerance.

Exceptions: safe parameterization, deliberate state ownership, and domain guarantees can justify a construct. A local convention never justifies a demonstrated vulnerability.

## I. Test slop

A test earns its place by failing for one reason in one scenario.

- Assertions of presence, type, or "did not throw" where a promised value was available; expectations copied from the implementation; mocks that replace the subject instead of its boundaries; `sleep` as synchronization; real time, randomness, or network in the arrange step; several scenarios in one test; an expectation edited to match wrong output.
- Better form: an independently derived expected value, the subject unmocked, one scenario per test, injected time.

Exceptions: narrow smoke tests; interaction checks when the interaction is the contract.
