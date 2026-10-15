---
name: readme-writer
description: "Write, revise, or review a README using repository facts and usable setup instructions. Use when the README itself is a requested deliverable. Not for other documentation or incidental README edits during an unrelated task."
argument-hint: "[project dir or README path]"
---

# README Writer

Help a newcomer understand what the project does, whether it fits their needs, and how to complete a first useful task. Include only material that serves that path.

Use the requested project directory or README path, otherwise the current project. Reviews produce findings; writing and editing requests authorize changes. Follow the project's documentation language unless the user requests another.

## Establish facts

Read the existing README and relevant manifests, entry points, scripts, CI, docs, and license. Establish the audience, supported behavior, prerequisites, installation path, and first useful operation. Support claims with repository evidence or authoritative documentation.

Preserve accurate information readers need. Do not invent features, compatibility, licenses, badges, or contribution processes.

## Verify setup and usage

Check new or changed commands against actual interfaces and run them in a disposable environment when feasible. Use existing task authorization for commands with external effects. Wording-only edits do not require repeating installation.

A command is verified only if it ran successfully. `--help`, `--version`, and `--dry-run` verify only those modes. Commands requiring unavailable credentials or infrastructure may be documented from source evidence; identify unexecuted steps and material limits in the handoff.

Use literal commands, identify values readers must supply, and show output only when observed. Resolve command failures or explain the unmet prerequisite. Check changed links and paths; verify external destinations when accessible.

## Write for the reader

Use only the sections the project needs:

1. **Purpose:** what it does and who it is for, usually in one sentence.
2. **Fit:** capabilities and constraints that affect the reader's choice.
3. **Start:** prerequisites and the shortest working installation path.
4. **Use:** the first common task as a runnable command or minimal API example.
5. **Details:** configuration, compatibility, and reference links needed beyond the first task.
6. **License:** the actual license and source link, when one is established.

Keep prerequisites before commands. Link detailed API, configuration, and contributor references instead of duplicating them. Add examples or diagrams only when they answer a distinct reader need. A small project may need only a description, installation, and one example.

Use plain headings and factual claims. Remove hype, filler, empty sections, and unsupported promises. Keep the requested length; do not expand a concise README into a template.

Review the result for accuracy and readability. In the handoff, summarize the changes, checks, and material verification limits. Keep the README focused on the project.
