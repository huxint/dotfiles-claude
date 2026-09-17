---
name: quality-tests
description: "Test pass: write, review, or repair tests so that each failure points at one behavior in one scenario, and prove every added or rewritten test by watching it fail first. Catches implementation mirrors, vacuous or presence-only asserts, mocks that replace the subject, happy-path-only suites, sleep-based or order-dependent tests, expectations adjusted to match a defect, and missing coverage of business rules, boundaries, and error paths. Use when tests are the subject: write tests for this, review the tests, improve coverage, 写测试, 补测试, 单测, 测试写得好不好, or when a task's deliverable is a test file."
argument-hint: "[path | --all] [--report-only]"
---

# Quality Tests

A test is worth having when its failure names **one broken behavior in one scenario**. Several assertions may describe that one outcome; a second scenario is a second test. Every test added or rewritten here is seen failing before it is trusted.

## Boundaries

A production bug the tests expose is reported with the failing evidence. Fix it only when the active task includes the fix. Never adjust the expectation to the defect.

## Target

- A path, glob, or module: the tests there and the code they cover. `--all`: every tracked test and its subject, skipping generated and vendored code.
- Otherwise the working tree: tests and production code in `git diff`, `git diff --cached`, and untracked files. Changed production code is in scope so that missing coverage is found. Clean tree: compare the branch with the merge base of its base branch, and report if the base cannot be resolved or the comparison is empty.
- Invoked during a coding task: the tests that task writes or touches.

A review request, or `--report-only`, produces findings without editing. A write, repair, or coverage request, or an active coding task, edits tests.

## What deserves a test

In priority order:

1. **Business rules**: calculations, permissions, state transitions, limits, and public contracts.
2. **Regressions**: each fixed bug gets a test named for the scenario that used to break.
3. **Boundaries the contract cares about**: empty, one, many, duplicates, invalid, the limit and its neighbors. Error paths assert the error and any required rollback or side effect.
4. **Fragile mechanics** even when the code is short: ordering, parsing, timezones, encoding, floating point, pagination, retries.

Private helpers are covered through the caller's behavior. Framework behavior and trivial wiring get a test only when they form a real project contract.

## What makes a test wrong

- **Implementation mirror.** The expected value is computed by the same logic as the subject. Derive expectations independently: a literal, a hand calculation, or a separate oracle.
- **Vacuous assertion.** Presence, type, "did not throw", or a mock-was-called check standing in for a promised result.
- **Mocked subject.** The thing under test, or the logic that makes it meaningful, is replaced. Substitute external boundaries only; assert on an interaction only when the interaction is the contract.
- **Expectation bent to a defect.** The assertion was changed to match wrong output. Repair or report the production defect.
- **Happy path only** where the risk is in the error or boundary.
- **Uncontrolled environment.** Real clock, randomness, network, shared filesystem state, or `sleep` as synchronization. Inject or fake them; use explicit waits.
- **Multiple scenarios in one test.** Split so each failure has one meaning.
- **Broad snapshot** where a business rule should be asserted directly. Snapshots are for rendered output.

## Writing a test

- Name it by scenario and expectation: `rejects_transfer_when_balance_insufficient`.
- Arrange, act, assert, separated by blank lines. Keep the decisive input values visible in the test, not buried in a shared fixture.
- On errors, assert the specific type and the stable fields or message. Use explicit tolerances for floats. Assert whole small collections; assert the defining properties of large ones.
- State the expectation before writing the assertion.

## Red gate

Every added or behaviorally rewritten test must fail once for the right reason. Run it against the pre-fix code, or against a deliberate fault in the behavior it guards (in an isolated copy of the current changes). The intended assertion must be what fails; a collection error, import error, or unrelated failure does not count. Restore the correct behavior and watch it pass.

If the environment prevents either run, say exactly which run and why, and mark the test unverified.

## Workflow

1. **Map the behavior.** Read each target test and its subject. State the intended contract, the risky scenarios, and what existing tests already cover. For a bug fix, judge against intended behavior, not current output.
2. **Evaluate.** Apply the lists above to every target test. Account for every risky behavior of changed code as covered or as a concrete gap.
3. **Write or repair** within scope. Delete a test only when it protects no meaningful contract, and report the deletion.
4. **Red gate** every added or rewritten test.
5. **Run the suite** after the targeted checks. Report the command and any failure output, or the concrete reason it could not run. Read the diff for accidental production changes.

## Report

Reviews: `File:Line | Test | Problem | Fix | Outcome`, plus gaps as `Subject | Scenario | Expected behavior`. Changes: red and green evidence per test, suite result, and any deletions. Keep verified and unverified work clearly separated.
