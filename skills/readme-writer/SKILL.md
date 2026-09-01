---
name: readme-writer
description: "Writes READMEs for real readers: what the project is, why it exists, how to use it, badges, license — not implementation internals. Architecture diagrams and file trees only when the project actually needs them. Use when writing or rewriting a README."
---

# README Writing

A README is the project's front door, not its technical specification. It
answers the reader's questions in order: **What is this? Why does it exist?
How do I get and run it?** Write for the person who just found the project —
not for contributors who already know it.

## Cover, in this order

1. **Name + one-line pitch** — what the project is and does, in plain words.
2. **Badges** — build status, version, license — if the project has them.
3. **Purpose / use case** — the problem it solves, who it's for, when to
   reach for it.
4. **Install / quick start** — the shortest path from nothing to running.
5. **Usage / examples** — realistic commands or snippets with real output.
6. **License** — what it is, where to read the full text. Contributing
   section if open source.

## Avoid by default

- **Implementation deep-dives** — internal principles, language functions and
  classes, the "how it works" tour. Only what the user must know to use it.
- **Architecture diagrams and file trees** — not the default. They belong in
  the README only when the project is complex enough that users or new
  contributors genuinely can't find their way without them.
- **README-as-tech-spec** — full API dumps, every option and config table.
  Point to the docs instead of reproducing them.

## Decide by the specific project

Nothing is banned outright. A library may deserve an API section, a large
codebase may justify an architecture note, a CLI tool may need a command
reference. The test is always: **does this serve the reader, and is it the
minimum needed?** If it exists to impress or fill length, cut it.

## Before finishing

- A stranger can tell what the project is in one line.
- A stranger can install and run it without asking questions.
- License is visible; contribution path is obvious for open source.
- No section explains internals the reader never asked about.
