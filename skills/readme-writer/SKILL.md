---
name: readme-writer
description: "Write or revise READMEs from repository evidence, with verified setup and usage. Use when creating, improving, or reviewing a README."
argument-hint: "[project dir or README path]"
---

# README Writer

A newcomer needs three answers in order: **What is this? Should I use it? How do I start?** Include material that helps them decide or complete their first useful task.

Use the requested project directory or README path, otherwise the current project. Reviews produce findings unless edits are also requested; writing and editing requests produce the README.

## Workflow

1. **Establish facts.** Inspect the existing README, manifests, entry points, public exports, installation scripts, CI, relevant docs, and license. Use CLI help where applicable. Identify the audience, supported behavior, prerequisites, primary install path, and first useful operation; each claim must have repository or authoritative documentation evidence.
2. **Verify the reader's path.** Follow the command-verification rules below. Account for every proposed command as executed successfully, corrected after failure, or unverified for a stated reason before presenting it as setup or usage.
3. **Write the README.** Follow the reader's path below. Preserve correct, audience-relevant facts. Use the project's documentation language, or the user's language when none is established.
4. **Check the result.** Verify local links and paths on disk; check external destinations when accessible. Confirm that prerequisites precede commands, examples use real interfaces, and license claims match the source. Report any unresolved link or command checks in the handoff.

## Command verification

Run installation and usage in a disposable environment where feasible. Use existing task authorization for commands that change state or contact external services.

`--help`, `--version`, and `--dry-run` establish only what those modes exercise. Distinguish those checks from executing the documented install or operation. Commands requiring credentials, deployment, or an unavailable environment can remain documented from verified source evidence; identify the exact unexecuted steps and limits in the handoff.

Use literal commands that match the project, label values readers must supply, and show output only when observed. When a command fails, resolve the failure or explain the unmet prerequisite; do not present it as verified.

## Reader's path

Use the sections the project needs, in this order:

1. **Identity:** name, concrete purpose, and intended user in one sentence.
2. **Fit:** the problem it solves and any constraint a user needs to choose it. Compare alternatives only when that choice matters.
3. **Start:** prerequisites and the shortest verified installation path. Link secondary methods.
4. **Use:** the first common task as a runnable command or minimal API example. Add examples only for distinct useful tasks.
5. **Configure:** values and compatibility details users need, with links to full references.
6. **License:** the actual license name and source link. If no license is established, report that gap instead of assigning one.

Adapt depth to the project: a script may need only installation and one example; a service may need environment setup and a deployment pointer; a multi-module repository may need a short navigation guide.

## Editorial rules

- Show capabilities through concrete purpose and usage. Keep claims factual and headings plain.
- Keep optional material only when evidence and reader need justify it: real CI or registry badges, an established contribution process, or a meaningful compatibility note.
- Link API, configuration, and contributor details rather than copying their full reference into the README.
- Use a file tree or diagram only when it resolves a navigation problem. Keep it limited to what the reader needs.
- Remove filler and empty sections. Length follows the reader's path, not a fixed template or line quota.

Finish with the file changed, the commands and links checked, and material verification limits. The README itself should describe the project.
