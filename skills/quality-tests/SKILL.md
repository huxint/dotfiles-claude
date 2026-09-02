---
name: quality-tests
description: "High-quality test standards: write tests that are worth having — reject garbage tests (implementation mirrors, vacuous asserts, testing the obvious); focus on behavior, edge cases, and error paths; code that is easy to misunderstand or regress must be tested even when the logic is simple. Use when writing or reviewing tests."
---

# High-Quality Test Standards

The value of a test is not that it passes — garbage tests pass too. The value is this: **when it fails, it tells you precisely which behavior broke in which scenario.** A test is worth writing if and only if its failure teaches you something.

## Tests worth writing (priority order)

1. **Core business logic** — rules, calculations, state transitions
2. **Edge cases** — empty collections, zero, negatives, null, oversized input, limit values
3. **Error paths** — behavior on failure: what exception, what return value, what side effects, whether state rolls back
4. **Code that is easy to misunderstand or get wrong** — order-sensitive logic, timezones and dates, format parsing, regex, floating-point comparison, encoding. The logic may be simple, but the failure rate is high — **simple ≠ not worth testing**
5. **Regression tests** — every bug you fixed earns a test that pins it so it can't come back
6. **Public API contracts** — the test alarms when a behavior callers depend on changes

## Garbage tests (banned)

- ❌ **Implementation mirrors**: the test restates the implementation's logic, so a broken implementation still "passes". A test writes the **expectation**, never the **steps**
- ❌ **Vacuous asserts**: `assert result is not None`, `assert len(x) > 0`, `assert True` — an assertion with a 100% pass rate is not an assertion
- ❌ **Asserting implementation, not behavior**: asserting internal variables, call order, or private methods instead of observable results
- ❌ **Testing the obvious**: `assert add(1, 2) == 3` — unless the code is easy to miswrite or regress (rounding, carry rules, etc.)
- ❌ **One test asserting many unrelated behaviors**: a failure must localize — one test, one behavior
- ❌ **Depending on execution order, shared mutable state, or sleep**: tests must run independently, repeatably, and fast
- ❌ **Test data that fills every branch but makes it unclear which is under test**: given-when-then must be readable at a glance

## Assertion principles

- Assert **concrete values**, not fuzzy conditions: `assert format_date(d) == "2024-01-01"` beats `assert "-" in format_date(d)`
- Assert **key behavior**, not every line: verify the correctness of the result, not each step of the process
- Error paths: assert the error's **identity** (exception type) and **context** (relevant fields, message) — `assertRaises(...)` alone is not enough
- Floating point: range or approximate assertions, never `==`

## Tests are engineering code too

- Test naming: `scenario_behavior_expectation` — `test_empty_input_raises_error`, `test_expired_token_is_rejected`; never `test_func1`, `test_xxx_1`
- Tests follow the same naming and comment standards — garbage names and garbage comments are garbage in tests too
- Test data should be realistic and representative: use plausible inputs, and trap inputs (like `"2024-02-30"`) catch more bugs than a stream of correct ones
- Factory/helper functions for repetitive setup — don't stack ten lines of setup in every test

## Ask before writing a test

- If this test fails, can I locate the broken behavior directly from the failure message?
- Am I writing the expectation, or restating the implementation?
- Could this assertion ever fail?
- If this behavior is broken in the future, will a test catch it?
- Did I cover edge cases and error paths, or only the happy path?
