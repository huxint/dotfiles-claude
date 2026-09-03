# Slop checks

Snippets are illustrations, not a literal list. Detect each pattern in whatever form it takes in the code under review, and do not flag code that merely resembles a snippet but is right in context. Every check has a **Not slop** line; read it before flagging.

## A. Silent failure and fabricated data

Errors must be loud. Swallowing a failure or inventing a value hides the bug and moves it downstream where it is harder to diagnose.

- **Swallowed exceptions**: `except Exception: pass`, bare `except:`, `catch (e) {}`, `_ = err`, catching and only logging, `logger.warning(...); continue` where the loop should stop, returning `None`/`null`/`-1` on failure without the caller checking.
- **Fabricated defaults on required data**: `record.get("amount", 0.0)`, `x or ""`, `?? 0`, `datetime.now()` for a missing timestamp, `int(str(record.get("x", 0)))` coercion in place of validation, empty list for a missing collection the logic depends on.
- **Compatibility shims for data you control**: `try: new_api() except: old_api()`; `col if col in df.columns else old_col`; probing several key names. Regenerate or migrate the upstream data instead.
- **Unnecessary defenses**: null checks on values a type or contract guarantees, re-validating arguments the caller already validated, `if not isinstance(x, str)` on typed code, `hasattr` on your own classes.
- **Retries and fallbacks that mask failure**: retry loops around non-transient errors, fallback to a cached or dummy value with no signal to the caller.

Not slop: a `try/except` at a real system boundary (CLI entry, request handler, worker loop) that logs with context and returns a proper error to its caller; defaults for genuinely optional fields; defensive checks at trust boundaries (user input, external APIs, files on disk).

## B. Band-aid patches

A fix that adds complexity where the symptom appears while the cause sits in untouched code.

- **Special cases**: a new `if x == <specific value>` or a growing `elif` chain that handles one observed input instead of fixing the logic that misclassifies it.
- **Hardcoded workarounds**: magic offsets, `[1:]` to skip a header that should not be there, `.replace("\\n", "")` to undo a producer's bug.
- **Consumer-side cleanup**: `.strip()`, `.lower()`, type coercion, or re-parsing in the caller because the producer returns bad data.
- **Diff in file B, cause in file A**: the change touches the place where an error surfaced, not the place where the wrong value was created.
- **Tests adjusted to the bug**: an expected value changed to match wrong output instead of fixing the output.

Not slop: a documented workaround for a third-party bug you cannot fix, with the upstream issue referenced.

## C. Dead code, leftovers, placeholder stubs

Code from earlier attempts and scaffolding that looks live.

- **Unreachable code**: after an unconditional `return`/`raise`, in an always-false branch, behind a flag that is never set.
- **Orphans**: imports, variables, functions, classes, fixtures, and config keys nothing references after the change.
- **Commented-out code**: any block of code in a comment. Version control holds history.
- **Placeholders shipped as done**: `TODO: implement`, `pass  # placeholder`, `...`, `raise NotImplementedError` in a path the feature needs, `# rest of the code remains the same`, `example.com`, `lorem ipsum`, `foo`/`bar` in non-test code, `YOUR_API_KEY`.
- **Duplicate implementations**: two functions doing the same job where one is the abandoned attempt (`parse` and `parse_v2`, `handler` and `new_handler`).
- **Debug leftovers**: `print`, `console.log`, `debugger`, `breakpoint()`, verbose logging added while investigating.

Not slop: a `TODO` with an owner or issue reference for work explicitly out of scope; an abstract method that raises `NotImplementedError` by design.

## D. Narration comments and doc slop

Comments that describe the code to itself instead of telling the maintainer something the code cannot.

- **Restating the code**: `# increment counter`, `// loop over users`, `# import libraries`, `# initialize variables`, `# return the result`.
- **Section banners and numbered steps**: `# ===== helpers =====`, `# Step 1: validate`, `# 1. ...`, `# --- end of function ---`.
- **Docstrings that repeat the signature**: "Args: user_id: the user id. Returns: the user." with nothing the types do not say.
- **Session talk**: `# as requested`, `# fixed per review`, `# changed from X`, `# now uses Y`, `# simplified`. These are afterimages; see the no-afterimage skill.
- **Excuse comments**: `# this is a bit hacky`, `# not sure if this is right`. Fix or ask; do not annotate.
- **Doc padding**: emoji headers, "🚀 Features", marketing adjectives (robust, comprehensive, seamless, powerful), auto-generated summaries at the top of every file, changelog lines inside source files.

Not slop: a comment that explains why (workaround, invariant, performance trade-off, non-obvious constraint); a docstring on a public API that states edge cases, side effects, or error conditions; numbered steps inside a genuinely multi-step algorithm where the order is the point.

## E. Speculative abstraction and over-engineering

Structure added for a future nobody requested.

- **Interfaces with one implementation**, abstract base classes with one subclass, factories that build one type, registries with one entry, strategy patterns with one strategy.
- **Configuration nobody asked for**: new options, env vars, or parameters with a single value ever passed; `**kwargs` forwarded to nothing.
- **Pass-through wrappers**: a function or class whose body only calls another with the same arguments.
- **Premature generality**: generic type parameters, plugin hooks, event buses, or dependency injection containers in a script-sized change.
- **Layering for its own sake**: `service` calling `manager` calling `handler` calling `helper`, each one line.
- **Reinventing what exists**: a new `slugify`, `chunk`, `retry`, `deep_merge`, or date parser when the stdlib, an installed dependency, or the project's own `utils` already has one.

Not slop: an abstraction with two or more real callers today, or one the task explicitly asked for; a boundary that isolates a third-party dependency the project intends to swap.

## F. Forced consolidation

Unrelated logic merged to look tidy.

- **Flag-driven functions**: a boolean or enum parameter that selects between distinct code paths sharing little. Split into separate functions.
- **Kitchen-sink modules**: unrelated features moved into one file or class to reduce the file count.
- **God helpers**: `process(data, mode, options)` whose body is a `match` over modes.
- **Over-DRY**: three similar-looking blocks squeezed into one parameterized function that is now harder to read than the three were, and that couples their futures.

Not slop: consolidation of genuinely identical logic with identical change reasons.

## G. Consistency and style drift

Code generated without reading its neighbors.

- **API or module mismatch**: `math.sqrt` in a file that uses `np.sqrt`, `os.path` beside `pathlib`, `requests` beside `httpx`, a new date library when one is already imported.
- **Style drift**: `.format()` among f-strings, `print` among `logging`, `dict()` among `{}`, camelCase in a snake_case module, semicolons in a project without them, different quote style, different import ordering, different error-message format.
- **Deprecated API in new code**: `df.append` when the file uses `pd.concat`, `datetime.utcnow()` beside timezone-aware code, `React.FC` in a codebase that dropped it.
- **Pattern mismatch**: raw SQL in a repository that uses an ORM, a class in a functional module, callbacks among async/await.
- **Formatting noise**: changed indentation, reordered imports, or reflowed lines on code the task did not touch.

Not slop: a deliberate migration the task asked for, applied consistently.

## H. Fragile duplication

The same fact encoded in several places, so one edit silently desynchronizes the others.

- **Hardcoded counts and ordinals**: "Apply all 10 patterns", `[9/10] Processing`, `assert len(x) == 7` next to a list literal.
- **Copy-paste with tweaks**: a block duplicated and lightly edited instead of parameterizing the original.
- **Parallel structures**: a list of names in one place and a matching `if/elif` in another; an enum and a separate dict of labels; a schema and a hand-written validator.
- **Magic strings repeated**: the same literal key, path, or URL typed in several files.

Not slop: duplication across module boundaries that the project keeps independent on purpose, such as test fixtures that mirror production data.

## I. Hallucinated or misused APIs

Calls that look plausible and do not exist, or exist with different semantics.

- **Nonexistent methods, parameters, or imports**: anything not already used elsewhere in the project must be checked against the installed package (`python -c "import x; help(x.y)"`, `node -e`, `go doc`, the type definitions) or its documentation.
- **Wrong signature or return type**: keyword arguments the function does not accept, treating a generator as a list, ignoring an awaitable.
- **Version mismatch**: using an API from a newer or older major version than the lockfile pins.
- **Misused semantics**: `dict.get` on a list, `str.strip("prefix")` treating the argument as a substring, `list.sort()` used for its return value, `Promise` not awaited.

Not slop: nothing; verify every unfamiliar call.

## J. Scope creep

Changes the task did not ask for.

- **Unrequested refactors**: renames, reorganizing files, extracting helpers from untouched code, "while I was here" cleanups.
- **New dependencies** added for a one-line convenience.
- **Behavior changes** outside the task: changed defaults, new validation, altered log levels or messages.
- **Feature additions**: extra CLI flags, extra endpoints, extra config the task never mentioned.
- **Formatting sweeps** over files the task did not touch.

Not slop: a change the task requires to work, called out explicitly in the handoff.

## K. Test slop

Tests that pass without protecting anything. See the quality-tests skill for the full standard.

- **Vacuous asserts**: `assert result is not None`, `assert len(x) > 0`, `assert True`, `expect(fn).toBeDefined()`.
- **Implementation mirrors**: the expected value is computed with the same logic as the code under test.
- **Mocking the subject**: the function under test, or the only meaningful collaborator, is mocked so the test checks the mock.
- **Tests that only exercise the happy path** for code whose risk is in errors and edges.
- **Tests adjusted to match output** instead of asserting the intended behavior.
- **Snapshot tests for logic**, order-dependent tests, `sleep` for synchronization, real network or clock without control.
- **Test names without a scenario**: `test_1`, `test_function_works`, `it("should work")`.

Not slop: a smoke test at a boundary whose only job is "the module imports and starts".

## L. Naming slop

See the code-naming skill for the full standard.

- **Filler**: `data`, `info`, `helper`, `manager`, `utils`, `handler`, `processor`, `result`, `temp`, `obj`, `item2`.
- **Action chains**: `validateAndSaveAndNotify`.
- **Implementation in the name**: `getUserFromDatabaseById`, `loadConfigFromJsonFile`.
- **Session-relative names**: `newParser`, `parserV2`, `fixedCalc`, `simpleVersion`, `betterHandler`.
- **Vocabulary drift**: a concept the project calls `account` appearing as `user`, `member`, or `customer` in the new code.

## M. Security and correctness smells

Patterns that are usually wrong and always worth a look.

- **String-built SQL, shell, or HTML**: f-strings or concatenation into `execute`, `subprocess(..., shell=True)`, `innerHTML`, `dangerouslySetInnerHTML`, `eval`, `exec`, `pickle.loads` on external data.
- **Secrets and endpoints in code**: keys, tokens, passwords, internal hostnames as literals; `verify=False`; `0.0.0.0` binds in non-server code.
- **Mutable defaults**: `def f(x, acc=[])`, `def f(cfg={})`.
- **Shared mutable state introduced**: module-level caches, `global`, singletons, class attributes used as instance state.
- **Concurrency hazards**: check-then-act on shared state, unawaited coroutines, blocking calls in async paths, threads without joins.
- **Floating equality**, timezone-naive datetimes mixed with aware ones, `==` for identity checks, string comparison for versions or dates.
- **Resource leaks**: files, sockets, or sessions opened without `with`, `defer`, `try/finally`, or `using`.

Not slop: constructs sanctioned by the project's own patterns, such as a parameterized query builder that happens to concatenate SQL fragments internally.

## N. Verbosity and unidiomatic code

Correct code that reads like a transcript of thinking.

- `if x == True`, `if len(x) == 0`, `for i in range(len(xs))`, `return True if cond else False`, `not x is None`.
- Manual loops that build a list or dict where a comprehension or a stdlib call (`any`, `all`, `sum`, `sorted`, `Object.entries`, `map`) is the local idiom.
- Type hints of `Any` or `Optional` everywhere, `# type: ignore` and `@ts-ignore` to silence real errors, `as any` casts.
- Redundant `else` after `return`, nested conditionals a guard clause would flatten, single-use variables that name nothing.
- Over-long functions created in one shot, with inline helper functions used once.
- Emoji, ANSI colors, and exclamation marks in log messages and CLI output where the project uses plain text.

Not slop: verbosity the language requires (Go's error handling) or the project's chosen style.
