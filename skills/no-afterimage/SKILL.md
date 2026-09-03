---
name: no-afterimage
description: "Remove afterimages: traces of the working session that leak into the final artifact. The user says 'ramen, no cilantro' and the result must be a bowl of ramen, not 'ramen (no-cilantro version)', not NoCilantroRamen, not a comment 'no cilantro as requested', and not a test asserting the absence of cilantro. Covers negative instructions turned into named features, rejected or superseded alternatives (newX, xV2, foo_old.py, 'instead of X'), commented-out earlier attempts, toggles between approaches, and commit or PR text that narrates the back-and-forth. Scans the working-tree changes by default, a path, or the whole project; rewrites each surface from the accepted state alone. Use after corrections, exclusions, or discarded proposals and before commits, PRs, or handoffs. Not for real deprecation, migration notes, changelogs, or mentions required for safety, accuracy, compatibility, or audit."
argument-hint: "[path | --all] [--report-only]"
---

# No Afterimage

The user orders ramen without cilantro. The right result is a bowl of ramen. The wrong results are "ramen (no-cilantro version)", a dish called `NoCilantroRamen`, a note on the bowl saying "no cilantro, as requested", and a test that checks the bowl for cilantro. The instruction shaped the work; it is not part of the work's identity.

An afterimage is any trace, in a final artifact, of something that existed only in the working session: an instruction about what to leave out, a proposal the user rejected, a first attempt you replaced, a correction you received. The reader of the artifact never saw the session. To them "uses SQLite (not Postgres)" raises a question nothing answers, `parserV2` implies a `parserV1` that does not exist, and `test_no_retry` guards a decision nobody told them about.

Rule: **generate every surface from the accepted final state, as if the excluded things had never been mentioned.** Say what is. Do not say what is not, what was, or why the other option lost.

## Constraints are not features

This is the most common afterimage and the easiest to miss, because each piece looks like diligence.

A negative instruction ("don't use X", "no Y", "without Z", "remove W", "not that way") produces an artifact that simply lacks X. It does not produce:

- **A name carrying the exclusion**: `NoCilantroRamen`, `ramen_without_cilantro`, `fetchUsersNoCache`, `SimpleParser` (meaning "the one without the feature you rejected"), `handler_v2`, `config.minimal.json`.
- **A comment or docstring announcing it**: `# no cilantro as requested`, `// does not use the cache`, `"""Version without retry logic."""`, `# removed X per feedback`.
- **A test or assertion guarding the absence**: `test_ramen_has_no_cilantro`, `assert "cilantro" not in ingredients`, `expect(cache.get).not.toHaveBeenCalled()` added only because the user said not to cache, a lint rule or CI check forbidding X.
- **A parameter or flag exposing the choice**: `make_ramen(cilantro=False)`, `use_cache: bool = False`, an env var toggling the rejected behavior, a config key that exists only to hold the value the user chose.
- **A defensive branch**: code that checks for X and strips it, when X never enters the system in the first place.
- **A handoff that leads with the exclusion**: "Here is the ramen, without cilantro." The handoff describes what was delivered.

The check for each candidate: would a reader who never heard the instruction need this to use, trust, or maintain the artifact? A no-cilantro test tells them nothing about ramen. A no-PII-in-logs test tells them something about the system, because that is a property the system must keep. See the next section.

## What is not an afterimage

Keep a mention when a reader **without** session history needs it:

- **The constraint is a real requirement of the system**, not a preference for this task: no PII in logs, no network in unit tests, no blocking calls on the event loop, no SQL string building. A test or comment guarding such a property is protection, not residue. Ask: would this belong even if the user had never said it?
- **Real deprecations, migrations, changelogs, and compatibility notes** for code that already has users.
- **The reason for a non-obvious choice**, when the alternative is one the reader would naturally reach for. `// binary search: items are sorted and can be huge` stays. `// binary search, not the linear scan from the first draft` does not.
- **Safety, accuracy, and audit facts**; diagnostics; names required by an interface; quoted source material.
- **Comparisons, audits, or history the user explicitly asked for.**
- **Pre-existing user changes and already executed events.** Uncommitted work is not rejected work.

The test for every candidate: rewrite it from the accepted state alone. If the rewritten text still needs the excluded thing to be true or useful, keep the mention. Otherwise the excluded thing goes.

## Surfaces

Check all of these, not only code:

- Code comments and docstrings
- Identifiers: functions, variables, classes, constants, parameters, files, directories, branch names
- Tests, assertions, fixtures, lint rules, and CI checks whose subject is the excluded thing
- Commented-out code, unused functions and imports, feature flags, env vars, and config keys left from an abandoned approach
- Commit messages, PR titles and bodies, changelog entries you wrote this session
- Documentation and README sections you touched
- Your handoff and final messages to the user

## Signals

A signal marks a candidate. A finding requires reading the candidate in context and confirming that a reader without session history is not served by it. A grep hit is not a finding; a zero-hit grep is not a clearance.

**Wording** (English and Chinese): without, no longer, not X, instead of, rather than, previously, originally, used to, was, replaced, switched from, changed from, reverted, back to, as discussed, as requested, as suggested, per feedback, per review, now uses, simplified from, the old way, the new way, alternative, minimal version, does not use, doesn't; 不加, 不用, 不含, 无, 去掉, 改为, 改成, 不再, 之前, 原来, 原先, 替换, 换成, 而不是, 按要求, 按建议, 新版, 旧版, 简化版, 精简版, 原方案.

**Names**: `no`, `without`, `new`, `old`, `v2`, `_2`, `final`, `fixed`, `temp`, `tmp`, `legacy`, `backup`, `bak`, `alt`, `simple`, `minimal`, `lite`, `real`, `actual`, `better` used as a prefix, suffix, or file-name part that only means something relative to the session.

**Tests**: names or assertions of the form `test_no_*`, `test_*_not_*`, `test_without_*`, `assert X not in`, `not.toHaveBeenCalled`, `assertNotCalled`, `assert_not_called`, added in this session for a property the system did not require before.

**Structure**: two implementations of one thing where one is unused; a flag that toggles between them; a parameter always passed the same value; a commented-out block; an import nothing uses after the last edit; a config key nothing reads.

**Narrative**: a sentence whose subject is the session ("I", "we decided", "you asked", "after trying") rather than the artifact.

Grep seeds, run together over the target, then read every hit in context:

```bash
grep -rnEi "without|instead of|rather than|no longer|previously|originally|replaced|switched from|changed from|revert|as (discussed|requested|suggested)|per (feedback|review)|now uses|does ?n[o']t use|不加|不用|不含|去掉|改为|改成|不再|之前|原来|原先|替换|换成|而不是|按要求|按建议|旧版|新版|简化版|精简版|原方案" <targets>
grep -rnE "\b(no|without|old|new|legacy|temp|tmp|final|fixed|bak|backup|alt|simple|minimal|lite|actual|real)[A-Z_]|_(no|without|old|new|v2|final|fixed|tmp|temp|bak|backup|legacy|alt|simple|minimal|lite)\b" <targets>
grep -rnE "test_(no|not|without)_|_not_|assert_not_called|not\.toHaveBeenCalled|not in " <test targets>
git ls-files <targets> | grep -Ei "(_|-|\.)(no|without|old|new|v2|final|fixed|bak|backup|legacy|alt|simple|minimal|lite|copy)(\.|_|-|$)"
```

## Scope

The user's words win. With no instruction, use the first row.

| User says | Target |
|---|---|
| nothing, "this change", "my changes" | Working tree: `git diff`, `git diff --cached`, untracked files from `git status --porcelain`. If the tree is clean, the commits on this branch that are not on the default branch. Plus any commit message, PR text, or handoff you are about to produce. |
| a path, glob, or module | Those files. |
| "whole project", `--all` | Every file tracked by git except vendored and generated code (`node_modules`, `vendor`, `dist`, `build`, lockfiles, generated migrations). Older afterimages from past sessions count too. |

## Execution

- **Recall the session's instructions first.** List every "don't", "no", "without", "remove", "not like that", and every proposal the user turned down. Each one is a thing to look for by meaning, not only by the grep seeds; `cilantro` will not be in the seed list.
- **Up to about 15 files or 1500 changed lines**: do it yourself. Read each file in full, not just the hunks; an afterimage often sits in an untouched line next to the change.
- **Larger**: split by top-level directory or module into chunks of about 15 files. Launch one subagent (type `general-purpose`, instructed to stay read-only) per chunk, all in one message, with the prompt below, including the list of session instructions. Merge the tables, drop duplicates, and re-verify any row you cannot confirm by reading the cited lines yourself.
- **Fixing**: apply edits yourself for up to about 10 findings. Beyond that, hand each file to a `general-purpose` subagent with its rows and the Fix section below. A fixing subagent edits only its assigned files.

Scan subagent prompt:

```
Read-only task. Do not edit anything.
Find "afterimages" in the files below: names, comments, tests, parameters, or leftover code
that only make sense relative to an instruction or alternative from a past working session,
and that a reader without that history does not need. Read every file in full and judge each
candidate in context.
Session instructions and rejected alternatives to look for by meaning: <list>
Signals: <paste the Signals section>
Keep (do not report): <paste the What-is-not-an-afterimage section>
Files: <list>
Return one markdown table row per confirmed finding:
| file:line | surface (comment / name / test / parameter / dead code / doc) | quoted text | rewrite from the accepted state alone |
Return the single word "none" if nothing is confirmed.
```

## Fix

Produce each replacement from the accepted state only:

- **Comment or doc**: state what the code does or why it is this way, with no reference to the excluded thing. If nothing is left after the reference is removed, delete the comment.
- **Name**: name the thing by what it is. `NoCilantroRamen` becomes `Ramen`, `parserV2` becomes `parser`, `fetchUsersNoCache` becomes `fetchUsers`, after confirming nothing else holds that name. Rename every reference across the project, including strings, docs, and tests. Public or exported names: report and let the user decide, since the rename breaks callers.
- **Test or assertion guarding an absence**: delete it, unless the absence is a real system requirement (see What is not an afterimage), in which case name it by the property (`test_logs_contain_no_pii`), not by the instruction.
- **Parameter or flag holding the choice**: remove it and inline the accepted behavior, unless a real caller passes the other value.
- **File**: `git mv` to the plain name; update imports and docs.
- **Dead code, commented-out code, unused imports, toggles, unread config, defensive branches for things that cannot occur**: delete.
- **Commit or PR text not yet pushed**: describe the change from the baseline to the final state. Already pushed history: report only; rewriting it is the user's call.
- **Handoff message**: describe what was delivered. Confirm a constraint only if the user asks whether it was honored.

Do not create new residue while fixing: no `// cleaned up` markers, no "removed the old approach" commit lines, no compatibility alias for the old name, no test proving the afterimage is gone.

## Verify and close

1. Re-read every edited surface as it is on disk. Formatters and hooks can rewrite a file after your edit.
2. Run `git diff` again and confirm nothing beyond the fixes changed.
3. Run the project's tests if a rename or deletion touched code.
4. Close with what the artifact now is and how you verified it. Do not write "no afterimages remain", "clean", "without X", or any other claim about absence. A statement about what is not there is itself residue.
