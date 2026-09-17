---
name: slopscan
description: "Review a diff, path, or whole project for the slop that generated code leaves even when it is correct: guards against conditions that cannot occur, wrappers and layers that change nothing, the first form that worked instead of the simplest one, abstraction at the wrong level or one concept in two places, padding comments and filler names, plus the rarer real defects (swallowed errors, fabricated defaults, misused APIs, unsafe input). Every finding comes with the better form written out; reports a ranked table and applies the fixes when asked. Use when the user says slopscan, de-slop, review this code, 审查一下, 检查有没有 slop, 看看 AI 味, 太啰嗦了, 过度防御, 有没有更好的写法, or wants a sanity check of code before a commit or PR."
argument-hint: "[path | --all] [--report-only]"
---

# Slopscan

Generated code is usually correct. Its slop is shape: it guards against conditions that cannot occur, wraps what needed no wrapper, keeps the first form that worked, and settles at the wrong level of abstraction. The bar is the version a strong engineer would have written under the same constraints; the review finds that version and shows the delta.

A finding has three parts: the location, the better form written out (for a dead guard, the cited guarantee that makes it dead), and what the change removes: a branch, a layer, a special case, a repeated block. If you cannot write the better form, it is not a finding. The better form changes no behavior; when it would, you have found a defect, and it is reported as one.

One principle covers most shape findings: **good code removes special cases instead of handling them.** A branch for the first, last, empty, or missing element is a question about the representation, not a fact about the problem. The right structure, invariant, or entry point makes the edge case the ordinary case; look for that form before accepting the branch.

Read the [check catalogue](references/checks.md) before triage; it gives the evidence, the better form, and the exceptions for each category.

## Target

- A path, glob, or module selects those files. `--all` selects every tracked source file, skipping generated and vendored code.
- Otherwise the working tree: `git diff`, `git diff --cached`, and untracked files from `git status --short`. If the tree is clean, compare the branch with the merge base of its base branch; report it when the base cannot be resolved or the comparison is empty.

A review request, or `--report-only`, produces the table without editing. A fix or cleanup request, or an active coding task, applies the fixes after showing the table.

## Checks

Shape first; this is where generated code usually fails.

- **A. Over-defense.** A guard for a condition that cannot hold where it stands: a null check on a value built two lines up, `try/except` around code that cannot raise, re-validation of what the boundary already validated, a fallback for required config, a retry on a deterministic failure. A check earns its place at a trust boundary or under a documented contract; elsewhere, cite the guarantee that makes it dead.
- **B. Needless wrapping.** A layer whose removal changes nothing: a function that forwards one call, a class with one method and no state, a wrapper over a library call that adds no argument or error translation, an exception subclass that adds nothing.
- **C. A better form exists.** A branch a different representation would absorb; a flag variable or nesting where an early return flattens; a loop rebuilding `enumerate`, `zip`, `any`, or `defaultdict`; an `elif` chain that is a lookup table; parallel lists instead of records; a value stored when it can be derived.
- **D. Wrong level of abstraction.** Too high: a base class, interface, registry, or factory with one entry; a strategy for two branches. Too low: the same block repeated with one name changed; rules interleaved with I/O in one long function; eight parameters that are one record. Mixed: one function that parses, validates, persists, and renders; a domain rule in `utils`.
- **E. Padding.** A comment or docstring that restates the code, banners, changelog lines, commented-out code, `# type: ignore` hiding a real mismatch, decorative logging, filler names (`data`, `helper`, `manager`, `utils`), draft names (`newX`, `xV2`, `fixedY`).
- **F. Leftovers and creep.** Unreachable branches, unused imports and options, an old implementation kept beside its replacement, a stub on a required path, a rename or formatting sweep the task did not ask for.

Then defects: rarer, and they outrank everything above when found.

- **G. Silent failure and fabricated data.** Swallowed exceptions, catch-log-and-succeed, required fields defaulted (`amount or 0`, `timestamp or now()`), error sentinels nobody checks, a consumer-side patch for a producer's bug, a test bent to a defect.
- **H. Misused APIs and unsafe code.** Symbols or arguments absent from the installed version; `strip` as prefix removal, an in-place sort's return value, an unawaited coroutine; untrusted input reaching SQL, shell, HTML, or eval; embedded credentials; mutable defaults, races, blocking calls in async paths, float equality.
- **I. Test slop.** Vacuous or presence-only asserts, expectations copied from the implementation, mocks replacing the subject, `sleep` as synchronization.

## Workflow

1. **Collect context.** List the target files and read each in full. For every candidate, trace what makes it slop: the construction and callers of a guarded value, the callers of a wrapper, the tests around a form you mean to rewrite. On a large target, finish one module before starting the next and keep a coverage list.
2. **Triage every category against every target.** Write the better form for each candidate and apply the catalogue's exceptions. A local convention excuses a shape finding when the neighbors do the same thing on purpose; it never excuses a defect.
3. **Report** in the table below. When fixes are authorized, show the table first, then fix.
4. **Fix**, defects first, then structure, then local. Delete a guard only with its guarantee cited; inline a wrapper only after checking its callers and whether a test uses it as a seam; rewrite a form only when tests cover it, or after writing down the behavior it must keep. For a defect, trace to the code that owns the violated contract and make the smallest complete repair. When intent is unclear, decide from the evidence and record the decision; when it cannot be decided, report the exact question.
5. **Verify.** Format, lint, build, and test the way the project does. Re-read the edited regions and check the diff for unrelated edits. Every finding gets an outcome; every claim of verification names its evidence.

## Report

`Level | File:Line | Check | Why it is slop | Better form | Outcome`

Sort by level, then by file. Level comes from what the fix changes, not from how generated the code looks:

- **Defect:** wrong behavior, a hidden failure, fabricated required data, an invalid API call, or a demonstrated security risk.
- **Structure:** a wrong layer, a wrong level of abstraction, or one concept in two places; every future change pays for it.
- **Local:** a dead guard, a pass-through wrapper, or an expression with a simpler form; the reader pays once per read.

"Why it is slop" states the guarantee, the count, or the special case: "`cfg` comes from `load_config()`, which raises on a missing file (config.py:12), so the `None` branch never runs." "Better form" is the replacement, short enough for the table or a pointer to a code block under it.

Close with counts, the scope inspected, the categories checked, and the limits (files skipped, guarantees that could not be traced). No findings is a valid result; state what was inspected. An incomplete scan says it is incomplete.
