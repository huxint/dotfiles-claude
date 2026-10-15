# Review Checks

Use these patterns to find candidates. Establish the contract and show a concrete improvement before reporting a finding.

## A. Unnecessary defenses

Trace the guarded value through construction, validation, and callers. Remove checks for states those contracts exclude: repeated validation, impossible null branches, empty checks before loops, handlers around operations guaranteed not to fail, defensive copies when no consumer mutates the value, or retries for deterministic failures.

Replace redundant checks with the direct operation. Validate malformed external input once at its entry point; do not fabricate a default to conceal it.

Keep checks for untrusted input, actual optional states, promised recovery, and supported dependency differences. In dynamically typed languages, annotations alone do not validate external input. Trusted internal contracts do not need repeated runtime checks.

## B. Needless wrappers

Inspect forwarding functions, single-method classes, accessors, re-export chains, custom exceptions, and adapters. Read their callers and identify the responsibility each layer owns.

Call the underlying operation directly when the layer adds no useful contract or meaning. Preserve domain vocabulary, argument or error translation, lifecycle ownership, public compatibility, and useful dependency or test boundaries. A single caller or implementation does not by itself make a layer unnecessary.

## C. Clearer forms

Look for representations and standard operations that remove incidental complexity:

- Suitable initial values or data structures can eliminate first-element, empty, and missing-value branches.
- Early returns can reduce nesting; direct predicates can replace flags and redundant boolean branches.
- Iterators and standard operations such as `enumerate`, `zip`, and `any` can replace manual bookkeeping.
- Records can replace parallel collections; derived values can replace duplicated state; a lookup table can express a fixed mapping.

Write the replacement and check evaluation order, error behavior, and performance requirements. A default is valid only when absence has a defined meaning. Keep explicit branches for real domain differences, readable loops, and measured optimizations. Brevity alone is not an improvement.

## D. Misplaced abstractions

Judge abstractions by the responsibilities they separate and the changes they make easier.

- **Excessive:** factories, registries, base classes, generic parameters, or strategies whose only purpose is hypothetical future variation. Collapse them to the concrete operation.
- **Insufficient:** one business rule repeated across locations, related values passed separately, or a domain concept scattered through unrelated helpers. Give the shared concept one clear home.
- **Mixed:** domain rules, I/O, and presentation policies coupled so that a change to one requires changing the others. Separate responsibilities where that reduces the coupling.

Preserve framework requirements, public contracts, and extension points the task actually needs. Similar text does not prove a shared concept. Independent rules may remain separate, and an orchestration function may legitimately coordinate several steps.

## E. Padding

Look for comments that restate code, draft history, decorative banners, commented-out implementations, vague TODOs, and logging that adds no diagnostic value. Remove them or replace them with the reason, invariant, or contract readers need.

Names such as `data`, `helper`, `manager`, `newParser`, or `fixedResult` are candidates only when they obscure the current role. Replace vague names with domain terms; keep clear local shorthand and names imposed by frameworks or protocols.

Investigate suppressions such as `type: ignore`, `noqa`, `@ts-ignore`, or `as any` when they conceal a real mismatch. Repair the mismatch instead of blindly deleting the suppression.

Preserve useful diagnostics, rationale, public documentation, actionable TODOs, legal notices, tool directives, and examples.

## F. Leftovers and scope creep

Look for unreachable branches, unused imports or options, abandoned alternatives, temporary switches, and incomplete implementations on required paths. Trace exports, registrations, configuration readers, and dynamic references before declaring code unused.

Remove proven leftovers within scope. Treat a stub on a required path as missing behavior. Preserve abstract methods, intentional scaffolding, and documentation examples.

Flag unrelated renames, formatting sweeps, dependencies, or behavior changes as scope issues. Supporting changes are justified when the requested behavior needs them. An unrelated diff is not permission to revert the user's existing work.

## G. Hidden failures and fabricated data

Trace swallowed exceptions, catch-and-log paths that still report success, unchecked error sentinels, defaults on required fields, and coercions that conceal malformed input. Look for consumer-side patches hiding a producer's defect or test expectations changed to accept wrong output.

Let unexpected failures surface, or handle them through a response the contract defines. Repair invalid data at the boundary or producer that owns it. Never invent a required amount, timestamp, or identifier to keep execution going.

Keep meaningful defaults for optional data, bounded recovery from transient failures, promised degradation, and justified third-party workarounds.

## H. API misuse and unsafe behavior

Verify unfamiliar symbols, arguments, and return values against the installed dependency or documentation for its version. Missing verification is a gap to report, not proof that an API was invented.

Check semantic traps: `strip` used to remove a prefix, an in-place sort's return value, a consumed iterator reused, an unawaited coroutine, mutable defaults, or incompatible datetime values. Flag floating-point equality when the contract requires tolerance.

Trace untrusted input reaching SQL, shell commands, HTML, evaluation, or deserialization. Check concrete risks from embedded credentials, disabled certificate checks, blocking I/O in async paths, shared mutable state, and missing resource cleanup.

Show the violated contract and the correct operation. Account for existing parameterization, deliberate state ownership, and domain guarantees before reporting a defect.

## I. Weak tests

Look for expectations copied from the implementation, mocks that replace the behavior under test, assertions too weak to establish the promised result, unrelated scenarios combined in one test, and timing or shared-state dependencies.

Derive expectations independently. Keep the subject real, assert the outcome, and control variability unrelated to the behavior under test. Synchronize on observable conditions instead of sleeping. Split unrelated scenarios or use parameterized cases. Never change an expectation to match a defect.

Keep narrow smoke tests, interaction checks, snapshots, and real integration dependencies when they test the intended contract. Do not add tests merely to prove that a cleanup changed the code.
