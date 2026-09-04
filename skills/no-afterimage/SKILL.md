---
name: no-afterimage
description: "Remove afterimages: traces of the working session that leak into the final artifact. The user says 'ramen, no cilantro' and the result must be a bowl of ramen, not 'ramen (no-cilantro version)', not NoCilantroRamen, not a comment 'no cilantro as requested', and not a test asserting the absence of cilantro. Covers negative instructions turned into named features, rejected or superseded alternatives (newX, xV2, foo_old.py, 'instead of X'), commented-out earlier attempts, toggles between approaches, and commit or PR text that narrates the back-and-forth. Scans the working-tree changes by default, a path, or the whole project; rewrites each surface from the accepted state alone. Use after corrections, exclusions, or discarded proposals and before commits, PRs, or handoffs. Not for real deprecation, migration notes, changelogs, or mentions required for safety, accuracy, compatibility, or audit."
argument-hint: "[path | --all] [--report-only]"
---

# No Afterimage

The user orders ramen without cilantro. The right result is a bowl of ramen. The wrong results are "ramen (no-cilantro version)", a dish called `NoCilantroRamen`, a note saying "no cilantro, as requested", and a test that checks the bowl for cilantro. The instruction shaped the work; it is not part of the work.

An afterimage is any trace in a final artifact of something that existed only in the session: an instruction about what to leave out, a rejected proposal, a replaced first attempt, a correction. The reader never saw the session. To them "uses SQLite (not Postgres)" raises a question nothing answers, `parserV2` implies a `parserV1` that does not exist, and `test_no_retry` guards a decision nobody told them about.

Rule: **generate every surface from the accepted final state, as if the excluded things had never been mentioned.** Say what is. Not what is not, what was, or why the other option lost.

## Constraints are not features

A negative instruction ("don't use X", "no Y", "without Z", "remove W") produces an artifact that simply lacks X. It does not produce:

- **A name carrying the exclusion**: `NoCilantroRamen`, `fetchUsersNoCache`, `SimpleParser` (meaning "without the rejected feature"), `handler_v2`, `config.minimal.json`.
- **A comment announcing it**: `# no cilantro as requested`, `// does not use the cache`, `"""Version without retry."""`.
- **A test guarding the absence**: `test_ramen_has_no_cilantro`, `expect(cache.get).not.toHaveBeenCalled()` added only because the user said not to cache, a lint rule forbidding X.
- **A parameter or flag exposing the choice**: `make_ramen(cilantro=False)`, `use_cache: bool = False`, a config key that exists only to hold the value the user chose.
- **A defensive branch** that strips X when X never enters the system.
- **A handoff that leads with the exclusion**: "Here is the ramen, without cilantro."

The check: would a reader who never heard the instruction need this to use, trust, or maintain the artifact?

## What is not an afterimage

Keep a mention when a reader **without** session history needs it:

- **A real requirement of the system**, not a preference for this task: no PII in logs, no network in unit tests, no blocking calls on the event loop. A test guarding such a property is protection. Ask: would this belong even if the user had never said it?
- **Real deprecations, migrations, changelogs, and compatibility notes** for code with users.
- **The reason for a non-obvious choice** when the alternative is the one a reader would reach for. `// binary search: items are sorted and can be huge` stays. `// binary search, not the linear scan from the first draft` goes.
- **Safety, accuracy, and audit facts**; names required by an interface; quoted source material.
- **Comparisons or history the user explicitly asked for.**
- **Pre-existing user changes.** Uncommitted work is not rejected work.

## Surfaces

- Comments and docstrings
- Identifiers: functions, variables, classes, parameters, files, directories, branches
- Tests, assertions, fixtures, lint rules, CI checks whose subject is the excluded thing
- Commented-out code, unused functions and imports, feature flags, env vars, config keys left from an abandoned approach
- Commit messages, PR titles and bodies, changelog entries written this session
- Documentation and README sections touched this session
- The handoff and final messages to the user

## Signals

A signal marks a candidate. A finding requires reading the candidate in context. A grep hit is not a finding; a zero-hit grep is not a clearance.

- **Wording**: without, no longer, not X, instead of, rather than, previously, originally, used to, replaced, switched from, changed from, reverted, back to, as discussed, as requested, as suggested, per feedback, per review, now uses, simplified from, the old way, alternative, minimal version, does not use.
- **Names**: `no`, `without`, `new`, `old`, `v2`, `_2`, `final`, `fixed`, `temp`, `tmp`, `legacy`, `backup`, `bak`, `alt`, `simple`, `minimal`, `lite`, `real`, `actual`, `better` as a prefix, suffix, or file-name part that only means something relative to the session.
- **Tests**: `test_no_*`, `test_*_not_*`, `test_without_*`, `assert X not in`, `not.toHaveBeenCalled`, `assert_not_called`, added this session for a property the system did not require before.
- **Structure**: two implementations of one thing where one is unused; a flag toggling between them; a parameter always passed the same value; a commented-out block; an unused import; an unread config key.
- **Narrative**: a sentence whose subject is the session ("I", "we decided", "you asked", "after trying") rather than the artifact.

Grep seeds, then read every hit in context:

```bash
grep -rnEi "without|instead of|rather than|no longer|previously|originally|replaced|switched from|changed from|revert|as (discussed|requested|suggested)|per (feedback|review)|now uses|does ?n[o']t use" <targets>
grep -rnE "\b(no|without|old|new|legacy|temp|tmp|final|fixed|bak|backup|alt|simple|minimal|lite|actual|real)[A-Z_]|_(no|without|old|new|v2|final|fixed|tmp|temp|bak|backup|legacy|alt|simple|minimal|lite)\b" <targets>
grep -rnE "test_(no|not|without)_|_not_|assert_not_called|not\.toHaveBeenCalled|not in " <test targets>
git ls-files <targets> | grep -Ei "(_|-|\.)(no|without|old|new|v2|final|fixed|bak|backup|legacy|alt|simple|minimal|lite|copy)(\.|_|-|$)"
```

## Scope

The user's words win. With no instruction, use the first row.

| User says | Target |
|---|---|
| nothing, "this change", "my changes" | Working tree: `git diff`, `git diff --cached`, untracked files. If clean, the commits on this branch not on the default branch. Plus any commit message, PR text, or handoff about to be produced. |
| a path, glob, or module | Those files. |
| "whole project", `--all` | Every file tracked by git except vendored and generated code. Afterimages from past sessions count too. |

## Execution

1. **Recall the session's instructions first.** List every "don't", "no", "without", "remove", and every proposal the user turned down. Each is something to look for by meaning, not only by grep; `cilantro` is not in the seed list.
2. **Read each file in full**, not just the hunks. An afterimage often sits in an untouched line next to the change. Large targets: work directory by directory.
3. **Fix** when the target is code produced in this session or the user asked; otherwise report and offer. `--report-only` always stops at the report.

## Fix

Produce each replacement from the accepted state only:

- **Comment or doc**: state what the code does or why, with no reference to the excluded thing. If nothing is left, delete it.
- **Name**: name the thing by what it is. `NoCilantroRamen` becomes `Ramen`, `parserV2` becomes `parser`, after confirming the name is free. Rename every reference, including strings, docs, and tests. Public or exported names: report and let the user decide.
- **Test guarding an absence**: delete it, unless the absence is a real system requirement, in which case name it by the property (`test_logs_contain_no_pii`), not by the instruction.
- **Parameter or flag holding the choice**: remove it and inline the accepted behavior, unless a real caller passes the other value.
- **File**: `git mv` to the plain name; update imports and docs.
- **Dead code, commented-out code, unused imports, toggles, unread config, impossible defensive branches**: delete.
- **Commit or PR text not yet pushed**: describe the change from baseline to final state. Pushed history: report only.
- **Handoff**: describe what was delivered. Confirm a constraint only if the user asks whether it was honored.

Create no new residue while fixing: no `// cleaned up` markers, no "removed the old approach" commit lines, no compatibility alias, no test proving the afterimage is gone.

## Verify

1. Re-read every edited surface on disk; formatters and hooks can rewrite a file.
2. `git diff` to confirm nothing beyond the fixes changed.
3. Run the project's tests if a rename or deletion touched code.
4. Close with what the artifact now is and how it was verified. Do not write "no afterimages remain", "clean", "without X", or any other claim about absence. A statement about what is not there is itself residue.
