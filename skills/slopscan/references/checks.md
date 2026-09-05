# Slop checks

Use each category to investigate behavior, then apply its exceptions. A candidate becomes a finding only with a location, violated requirement or convention, and concrete consequence. Examples identify patterns; equivalent-looking code may have different contracts.

## A. Silent failure and fabricated data

Keep required data and failures explicit at the boundary that owns them.

- Trace swallowed exceptions, catch-and-log paths that still report success, and error sentinels callers never check.
- Check defaults on required fields: a missing amount becoming zero, a missing timestamp becoming the current time, or coercion hiding malformed input.
- Investigate retries of non-transient failures, undisclosed fallback values, and compatibility probing for upstream data the project controls.
- Remove repeated defenses only after establishing the runtime guarantee they duplicate.

Valid cases include optional defaults, bounded transient recovery, contract-defined degradation, and validation at trust boundaries. Type annotations alone do not establish runtime validity.

## B. Band-aid patches

Trace the wrong value to its producer and repair the violated contract there.

- Investigate input-specific branches, magic offsets, and consumer cleanup added to compensate for an incorrect producer.
- Compare changed expectations with the intended behavior; a test adjusted to a defect can hide the same cause.

Valid cases include normalization owned by a boundary and necessary third-party workarounds with a documented constraint or upstream issue.

## C. Dead code, leftovers, and placeholder stubs

Establish whether a path still serves a caller or supported contract.

- Look for unreachable branches, unused imports or configuration, abandoned duplicate implementations, and commented-out attempts.
- Inspect required runtime paths containing unfinished stubs and investigation-only logging or breakpoints.
- Check exports, registries, configuration, and dynamic references before declaring code unused.

Valid cases include abstract methods, tracked deferred work outside the task, and placeholders or code examples clearly intended for documentation or configuration templates.

## D. Narration comments and doc padding

Keep rationale and caller contracts; remove prose that merely repeats code or the working session.

- Identify repeated signatures, operation-by-operation narration, decorative banners, and draft or review remarks.
- Check generic summaries, marketing claims, and embedded changelog text for actual reader value.

Valid cases include invariants, workarounds, public API contracts, legal notices, tool directives, and algorithm steps whose order needs explanation.

## E. Speculative abstraction

Require a present responsibility, contract, or variation that justifies each layer.

- Investigate single-entry registries, one-strategy factories, unused options, pass-through wrappers, and generic machinery without a current use.
- Look for chains of thin layers and custom utilities that duplicate equivalent behavior already available in the project or its dependencies.

Valid cases include a requested extension point or a boundary with a real ownership, lifecycle, testing, or compatibility purpose. Caller count alone does not establish whether an abstraction earns its place.

## F. Forced consolidation

Share logic when its callers share the same reason to change.

- Investigate mode flags selecting unrelated operations, kitchen-sink modules, and generic processors coupling independent features.
- Compare a parameterized abstraction with its callers: shared syntax may conceal different contracts.

Valid cases include genuinely shared invariants and dispatch that forms an intentional public interface.

## G. Consistency and style drift

Use neighboring conventions when they preserve the required semantics.

- Compare imports, libraries, error handling, naming, formatting, and architectural patterns with nearby code.
- Check deprecated APIs and broad formatting changes unrelated to the task.

Valid cases include deliberate migrations and differences required by behavior. For example, scalar and array APIs are not interchangeable solely because both expose a square-root function.

## H. Fragile duplication

Keep shared facts authoritative in one place.

- Trace duplicated counts, ordinals, magic strings, schema rules, and parallel lists or branches that must change together.
- Identify copied logic whose changes can silently diverge; establish whether the copies actually share a contract.

Valid cases include intentionally independent modules and hand-derived test expectations. Similar text alone does not justify coupling their implementations.

## I. Hallucinated or misused APIs

Verify unfamiliar calls against the installed version, type definitions, or documentation matching the lockfile.

- Check symbols, imports, argument names, return values, and version availability.
- Inspect semantic traps: treating `strip` as prefix removal, using an in-place sort's return value, consuming a generator as a list, or dropping an awaitable.

An unavailable lookup is a verification gap, not proof that an API is invented. Record the unresolved call and missing evidence.

## J. Scope creep

Tie each change to the requested outcome or a necessary dependency of that outcome.

- Identify unrelated renames, new options, behavior changes, dependency additions, and formatting sweeps.
- Explain why a supporting change is needed; proximity to touched code is not sufficient.

Valid cases include repairs across module boundaries that are necessary for the requested behavior. Judge necessity by the contract, not by the original diff's file list.

## K. Test slop

Require each test to detect a meaningful failure in one scenario.

- Inspect vacuous assertions, expectations copied from implementation logic, and mocks that replace the behavior supposedly tested.
- Check missing edge or error coverage where the risk demands it, expectations changed to match defects, and unrelated behaviors combined in one test.
- Investigate uncontrolled time, network, shared state, sleep-based synchronization, and broad snapshots standing in for business-rule assertions.

Valid cases include narrow smoke tests and interaction checks when the interaction is the contract. Judge an assertion against what the test is meant to prove.

## L. Naming slop

Judge a name where readers encounter it.

- Identify filler, action chains, implementation details irrelevant to callers, and labels meaningful only relative to a draft.
- Check vocabulary drift, misleading side effects, and ambiguity that survives the surrounding scope.

Valid cases include framework-required names, established local abbreviations, and real protocol or compatibility versions.

## M. Security and correctness

Trace unsafe operations to inputs, ownership, and observable effects.

- Investigate untrusted values reaching SQL, shell, HTML, evaluation, or unsafe deserialization without the required separation or validation.
- Check embedded credentials, disabled certificate checks, and unintended network exposure.
- Trace mutable defaults, shared caches, races, blocking work in asynchronous paths, and resource lifetimes lacking reliable cleanup.
- Examine floating-point comparisons, mixed timezone semantics, and string comparisons used where numeric or version ordering is required.

Safe parameterization, deliberate state ownership, and domain guarantees can justify a construct. A local convention alone cannot justify a demonstrated vulnerability or correctness defect.

## N. Verbosity and unidiomatic code

Prefer the simplest familiar expression that preserves meaning.

- Look for redundant boolean branches, needless nesting, manual operations with clear local idioms, and temporary variables that add no meaning.
- Inspect type suppressions and broad types that conceal a real mismatch.
- Check overlong functions and decorative output against the project's established style.

Valid cases include language-required ceremony, meaningful intermediate names, and explicit forms that clarify a domain constraint. Fix semantic defects before stylistic ones.
