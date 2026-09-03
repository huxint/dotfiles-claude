---
name: quality-tests
description: "Test standards for writing and reviewing tests: a test is worth having only if its failure points at exactly one broken behavior in one scenario. Rejects implementation mirrors, vacuous asserts, tests that mock the subject, happy-path-only suites, order-dependent or sleep-based tests, and tests adjusted to match buggy output. Prioritizes business rules, edge cases, error paths, regressions, and code that is easy to get wrong even when simple. Every new test is seen failing once before it passes. Scans the working-tree changes by default, a path, or the whole project, and fixes or rewrites bad tests. Use when writing, reviewing, or cleaning up tests."
argument-hint: "[path | --all] [--report-only]"
---

# Quality Tests

A passing test proves nothing on its own; garbage tests pass too. The value of a test is what happens when it fails: **it names one behavior, in one scenario, that no longer holds.** A test is worth writing if and only if its failure would teach the reader something they did not know.

## What to test, in priority order

1. **Business rules**: calculations, state transitions, permissions, pricing, limits.
2. **Edge cases**: empty, zero, one, negative, null, maximum, boundary plus and minus one, unicode, whitespace, duplicates.
3. **Error paths**: what is raised or returned on failure, what side effects happen or are rolled back, what the caller can see.
4. **Code that is easy to get wrong even when short**: ordering, timezones and dates, parsing, regex, floating point, encoding, off-by-one, pagination, retries. Simple is not the same as safe.
5. **Regressions**: every fixed bug gets a test that reproduces it by name, so it cannot return.
6. **Public contracts**: behavior callers rely on, so a change alarms before it ships.

Not worth a test: private helpers already covered through their callers, framework behavior, getters and setters, code that only wires other tested code together.

## Banned tests

- **Implementation mirrors**: the expected value is computed with the same logic as the code under test, so both break together and the test still passes. A test writes the expectation as a literal or a hand-derived value, never the steps.
- **Vacuous asserts**: `assert result is not None`, `assert len(x) > 0`, `assert True`, `expect(fn).toBeDefined()`, `assert isinstance(...)` alone. An assertion that cannot fail is not an assertion.
- **Asserting implementation instead of behavior**: private state, call order, `mock.assert_called_once_with` as the only check, when an observable result exists.
- **Mocking the subject**: the function under test or its one meaningful collaborator is mocked, so the test checks the mock. Mock only at real boundaries: network, clock, filesystem, randomness, third-party services.
- **Testing the obvious**: `assert add(1, 2) == 3`, unless the code is prone to regress (rounding, carry, sign).
- **Many unrelated behaviors in one test**: the first failure hides the rest. One test, one behavior.
- **Order dependence, shared mutable state, sleep-based synchronization, real time, real network**: tests run alone, in any order, repeatably, fast.
- **Tests adjusted to the bug**: an expected value changed to match wrong output. Fix the code or file the bug; do not enshrine it.
- **Snapshot tests for logic**: acceptable for rendered output, not for computed values.
- **Fixtures that exercise every branch at once** so nobody can tell which scenario a test covers.

## Assertions

- Assert concrete values: `assert format_date(d) == "2024-01-01"`, not `assert "-" in format_date(d)`.
- Assert the result that matters, not every intermediate step.
- On errors, assert identity and context: the exception type and the relevant message or fields. `assertRaises(Exception)` alone is not enough.
- Floating point: approximate assertions with an explicit tolerance, never `==`.
- Collections: assert the whole expected value when it is small; assert length plus specific elements when it is large.

## Tests are engineering code

- Names are `scenario_expectation`: `test_empty_cart_total_is_zero`, `test_expired_token_is_rejected`, `it("rejects an expired token")`. Never `test_1`, `test_works`, `test_function`.
- Structure reads as arrange, act, assert. A blank line between the three is enough; no `# Arrange` comments.
- Realistic data, plus trap inputs: `"2024-02-30"`, `"  "`, `-0.0`, `"ß"`, an id that exists in one table but not the other.
- Shared setup goes in factories or fixtures; ten lines of setup repeated in every test is a smell. Fixtures that hide the values a test depends on are a worse one.
- Naming and comment standards apply here too (see the code-naming and code-comments skills).
- Determinism: inject the clock, seed randomness, use temp directories, fake the network.

## Writing new tests

1. **Read the code under test** and list its behaviors, edge cases, and failure modes as sentences before writing any test. Each sentence becomes at most one test.
2. **Write the expectation first**, as a literal. If you cannot state the expected value without running the code, you do not yet understand the behavior.
3. **See it fail once.** Run the new test against a deliberately broken version of the behavior (comment out the branch, flip the comparison, return early), or against the pre-fix code for a regression test. A test that has never failed has never been shown to test anything. Restore the code and see it pass.
4. **Run the whole suite**, not just the new file, and report the result verbatim on failure.

## Scope

The user's words win. With no instruction, use the first row.

| User says | Target |
|---|---|
| nothing, "this change", "my changes" | Tests in the working tree: `git diff`, `git diff --cached`, untracked files. Plus the production code changed in the same diff, to check what is untested. |
| a path, glob, or module | Those test files, and the code they cover. |
| "whole project", `--all` | Every test file tracked by git. |

## Execution

1. **Read the tests and the code they cover.** A test cannot be judged without knowing what the subject does and which of its behaviors carry risk.
2. **Evaluate each test** against the banned list and the assertion rules. Then list the behaviors of the changed code that have **no** test, ranked by the priority order above.
3. **Mode.** Up to about 15 files: do it yourself. Larger: split by directory into chunks of about 15 files and launch one subagent (type `general-purpose`, instructed to stay read-only) per chunk, all in one message, with the prompt below. Merge, dedupe, and re-verify.
4. **Fix** when the target is code produced in this session or the user asked; otherwise report and offer. `--report-only` always stops at the report. Fixes are: rewrite the assertion, split the test, replace the mock with the real collaborator, add the missing test using the Writing-new-tests steps, or delete a test that cannot be made meaningful. Deleting a test is reported explicitly, never done silently.
5. **Verify.** Run the full suite. For every added or rewritten test, do the see-it-fail check. Re-read edited files, `git diff` for sprawl.

Scan subagent prompt:

```
Read-only task. Do not edit anything.
For each test file below, also read the code it covers. Evaluate every test against these
rules: <paste the Banned-tests and Assertions sections>. Then list behaviors of the covered
code (business rules, edge cases, error paths, easy-to-get-wrong logic) that have no test.
Files: <list>
Return two markdown tables.
Bad tests:   | file:line | test name | problem | concrete fix |
Missing:     | covered file:function | untested behavior | why it matters | proposed test name |
Return the single word "none" for an empty table.
```

## Report

```
| # | File:Line | Test | Problem | Fix |
```

followed by a `Missing coverage` table with `Function | Behavior | Proposed test`. One summary line: `N bad tests, M missing behaviors across L files.` After fixing, add an `Outcome` column and the suite result.
