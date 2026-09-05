---
name: quality-tests
description: "Test standards for writing, reviewing, and repairing tests: protect observable behavior and prove each added or rewritten test can detect its intended failure."
argument-hint: "[path | --all] [--report-only]"
---

# Quality Tests

A useful failure identifies **one behavior in one scenario**. Several assertions may describe that outcome; unrelated behaviors belong in separate tests.

## Scope and mode

- A requested path, glob, or module selects its tests and the code they cover. `--all` selects tracked tests and their production subjects, excluding generated and vendored code.
- Otherwise collect staged, unstaged, and untracked changes with `git diff`, `git diff --cached`, and `git status --short`. Include changed production code to find missing coverage.
- If the tree is clean, resolve the base branch from the task or repository metadata and compare from its merge base with HEAD. Report an unresolved base or an empty comparison.

Reviews produce findings unless fixes are also requested; `--report-only` always leaves target files unchanged. Otherwise apply the rules while writing tests or performing requested cleanup.

## Workflow

1. **Map behavior.** Read each target test and its production subject. State the intended contract, risky scenarios, and existing coverage. Judge a bug fix against the intended behavior, rather than treating current output as its specification.
2. **Evaluate coverage.** Apply the standards below to every target test. Account for each risky behavior of changed code as covered or a concrete gap; prioritize business rules, regressions, boundaries, and error paths.
3. **Write or repair.** For authorized edits, state the expectation before writing the assertion. Rewrite weak assertions, split unrelated scenarios, replace inappropriate mocks, or add missing coverage. Delete a test only when it has no meaningful contract to protect, and report the deletion.
4. **Prove red, then green.** Apply the red gate below to every added or behaviorally rewritten test.
5. **Verify integration.** Run the project test suite after targeted checks. Report the command and relevant failure output, or the concrete reason the suite could not run. Re-read edited files and inspect the diff for unintended production changes.

## Coverage that earns its cost

- Protect calculations, permissions, state transitions, limits, and public contracts.
- Reproduce each fixed bug with a named regression scenario.
- Choose boundaries relevant to the contract: empty input, duplicates, invalid values, limits and their neighbors. Assert error results and required rollback or side effects.
- Exercise fragile mechanics such as ordering, parsing, timezones, encoding, floating point, pagination, and retries even when the implementation is short.
- Cover private helpers through meaningful caller behavior. Framework behavior and trivial wiring need tests only when they form a real project contract.

## Assertions and isolation

- Derive expectations independently of the implementation: literal values, hand calculations, or an independent oracle. An expectation changed to match a defect conceals it; repair or report the production defect.
- Assert observable results. Presence, type, private-state, or mock-call checks alone are insufficient when the contract promises a richer outcome. Boundary smoke tests may have a deliberately narrow contract.
- Keep the subject and its meaningful logic real. Substitute external boundaries when isolation requires it; an interaction assertion is appropriate when the interaction itself is the contract.
- On errors, check the specific type and relevant stable fields or message. Use explicit tolerances for floating point; assert whole small collections or the defining properties of larger ones.
- Reserve broad snapshots for rendered output; assert business rules directly.
- Control clocks, randomness, filesystem state, and network dependencies. Use explicit synchronization instead of sleeps. Integration tests use controlled services and independent state.
- Name tests by scenario and expectation. Separate arrange, act, and assert with blank lines. Keep decisive input values visible in fixtures; use one scenario per fixture setup.

## Red gate

Run the test against the pre-fix behavior or a deliberate fault in the behavior it guards. For deliberate faults, use an isolated copy containing the current changes. Confirm that the intended assertion fails; collection errors, broken imports, and unrelated failures do not establish red.

Restore correct behavior and observe green. If the environment prevents either run, report the exact gap and leave the test's verification status explicit.

## Report

For reviews, use `File:Line | Test | Problem | Fix | Outcome`. List coverage gaps as `Subject | Scenario | Expected behavior`. For changes, include red/green evidence, suite results, and deletions. Distinguish verified coverage from work that remains unverified.
