---
name: quality-tests
description: "Write, review, or repair tests that protect meaningful behavior and expose real defects. Use when tests or test coverage are the requested focus. Do not invoke merely because an implementation task touches a test file or needs routine verification."
argument-hint: "[path | --all] [--report-only]"
---

# Quality Tests

A useful test fails for **one broken behavior in one scenario**. Several assertions may establish that outcome. Protect contracts and plausible regressions; coverage counts alone do not justify a test.

## Scope

- Use the requested paths, globs, or modules. `--all` covers tracked tests and the code they exercise, excluding generated and vendored code.
- When invoked within a larger task, cover that task's tests and changed behavior. Read production code to identify meaningful coverage gaps.
- Otherwise review staged, unstaged, and untracked changes. In a clean tree, compare the branch with the merge base of its known base branch. If the base is unknown or the diff is empty, report that limit.

Reviews and `--report-only` produce findings. Writing, repair, and coverage requests authorize test edits. Report production bugs with failing evidence; fix them when the task includes that repair. Never change an expectation to match a defect.

## Choose what to test

Prioritize business rules, public contracts, reproducible regressions, and error or boundary cases the contract cares about. Give fragile mechanics such as parsing, ordering, time handling, pagination, and retries attention when they carry real risk.

Cover private helpers through their callers. Trust framework behavior and trivial wiring unless they form a project-specific contract. Do not add tests for hypothetical inputs internal callers cannot produce, incidental implementation details, or the mere presence of an edit.

## Write meaningful assertions

- **Derive expectations independently.** Use requirements, known examples, hand calculations, or a separate oracle. Repeating the implementation in the expected value repeats its bugs.
- **Assert the promised outcome.** Presence, type, or "did not throw" is enough only when that is the contract. Assert interactions when the interaction itself matters.
- **Keep the subject real.** Substitute external boundaries without mocking away the behavior under test. Real dependencies are appropriate when an integration test is meant to exercise them.
- **Control unrelated variability.** Isolate time, randomness, network, and shared state when they are not the subject. Synchronize on observable conditions instead of sleeping.
- **Keep failures specific.** Use one scenario per test or parameterized case. Check stable error details and required side effects. Use tolerances when approximate values require them.
- **Keep the contract visible.** Name the scenario and expected behavior, keep decisive inputs close to the assertion, and separate setup, action, and checks clearly.
- **Use snapshots selectively.** Snapshot stable output when the whole output is the contract; use focused assertions for individual rules.

## Verify that tests detect failure

Every new or behaviorally rewritten test must fail for the intended assertion before it is trusted. Run it against the broken version or introduce a plausible fault in an isolated copy. Import errors, broken fixtures, and unrelated failures do not count. Restore correct behavior and confirm the test passes. Renames and formatting-only edits do not need this step.

Run targeted tests, then the affected suite. Broaden verification when the change or project requirements justify it. If a failing or passing run is unavailable, report the missing evidence and reason.

For reviews, give the location, defective test or coverage gap, expected behavior, and proposed repair. For edits, report failure and success evidence, suite results, and any removed tests. Delete tests only when they protect no meaningful contract.
