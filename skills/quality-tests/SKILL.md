---
name: quality-tests
description: "Test standards for writing and reviewing tests: a test is worth having only if its failure points at exactly one broken behavior in one scenario. Rejects implementation mirrors, vacuous asserts, tests that mock the subject, happy-path-only suites, order-dependent or sleep-based tests, and tests adjusted to match buggy output. Prioritizes business rules, edge cases, error paths, regressions, and code that is easy to get wrong even when simple. Every new test is seen failing once before it passes. Scans the working-tree changes by default, a path, or the whole project, and fixes or rewrites bad tests. Use when writing, reviewing, or cleaning up tests."
argument-hint: "[path | --all] [--report-only]"
---

# Quality Tests

A passing test proves nothing on its own; garbage tests pass too. The value of a test is what happens when it fails: **it names one behavior, in one scenario, that no longer holds.** A test is worth writing only if its failure would teach the reader something.

## What to test, in priority order

1. **Business rules**: calculations, state transitions, permissions, pricing, limits.
2. **Edge cases**: empty, zero, one, negative, null, maximum, boundary plus and minus one, unicode, whitespace, duplicates.
3. **Error paths**: what is raised or returned, what side effects happen or roll back, what the caller sees.
4. **Code that is easy to get wrong even when short**: ordering, timezones, parsing, regex, floating point, encoding, off-by-one, pagination, retries.
5. **Regressions**: every fixed bug gets a test that reproduces it by name.
6. **Public contracts**: behavior callers rely on.

Not worth a test: private helpers covered through their callers, framework behavior, getters and setters, pure wiring.

## Banned tests

- **Implementation mirrors**: the expected value is computed with the same logic as the code under test. Write expectations as literals or hand-derived values.
- **Vacuous asserts**: `assert result is not None`, `assert len(x) > 0`, `assert True`, `expect(fn).toBeDefined()`, `isinstance` alone.
- **Asserting implementation instead of behavior**: private state, call order, `assert_called_once_with` as the only check when an observable result exists.
- **Mocking the subject**: the function under test or its one meaningful collaborator is mocked. Mock only at real boundaries: network, clock, filesystem, randomness, third-party services.
- **Testing the obvious**: `assert add(1, 2) == 3`, unless the code is prone to regress.
- **Many behaviors in one test**: the first failure hides the rest.
- **Order dependence, shared mutable state, sleep-based sync, real time, real network.**
- **Tests adjusted to the bug**: an expected value changed to match wrong output. Fix the code or file the bug.
- **Snapshot tests for logic**: acceptable for rendered output only.
- **Fixtures that exercise every branch at once**, so nobody can tell which scenario a test covers.

## Assertions

- Concrete values: `assert format_date(d) == "2024-01-01"`, not `assert "-" in format_date(d)`.
- The result that matters, not every intermediate step.
- On errors, the exception type plus the relevant message or fields. `assertRaises(Exception)` alone is not enough.
- Floating point: approximate with an explicit tolerance.
- Collections: the whole value when small; length plus specific elements when large.

## Tests are engineering code

- Names are `scenario_expectation`: `test_empty_cart_total_is_zero`, `it("rejects an expired token")`. Never `test_1`, `test_works`.
- Arrange, act, assert separated by blank lines; no `# Arrange` comments.
- Realistic data plus trap inputs: `"2024-02-30"`, `"  "`, `-0.0`, `"ß"`.
- Shared setup in factories or fixtures. Fixtures that hide the values a test depends on are worse than repetition.
- Determinism: inject the clock, seed randomness, use temp directories, fake the network.
- Naming and comment standards apply here too.

## Writing new tests

1. **Read the code under test** and list its behaviors, edge cases, and failure modes as sentences. Each sentence becomes at most one test.
2. **Write the expectation first**, as a literal. If the expected value cannot be stated without running the code, the behavior is not yet understood.
3. **See it fail once.** Run the new test against a deliberately broken version (flip the comparison, return early) or against the pre-fix code for a regression. Restore and see it pass.
4. **Run the whole suite**, not just the new file. Report failures verbatim.

## Scope

The user's words win. With no instruction, use the first row.

| User says | Target |
|---|---|
| nothing, "this change", "my changes" | Tests in the working tree, plus the production code changed in the same diff, to check what is untested. |
| a path, glob, or module | Those test files and the code they cover. |
| "whole project", `--all` | Every test file tracked by git. |

## Execution

1. **Read the tests and the code they cover.** A test cannot be judged without knowing what the subject does and where its risk is. Large targets: work directory by directory.
2. **Evaluate each test** against the banned list and assertion rules. Then list behaviors of the changed code that have **no** test, ranked by the priority order.
3. **Fix** when the target is code produced in this session or the user asked; otherwise report and offer. `--report-only` always stops at the report. Fixes: rewrite the assertion, split the test, replace the mock with the real collaborator, add the missing test, or delete a test that cannot be made meaningful. Deletions are reported explicitly.
4. **Verify.** Run the full suite. Do the see-it-fail check for every added or rewritten test. Re-read edited files, `git diff` for sprawl.

## Report

```
| # | File:Line | Test | Problem | Fix |
```

followed by a `Missing coverage` table: `Function | Behavior | Proposed test`. One summary line: `N bad tests, M missing behaviors across L files.` After fixing, add an `Outcome` column and the suite result.
