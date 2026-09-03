---
name: readme-writer
description: "Writes or rewrites a README for the person who just found the project: what it is in one line, why it exists, how to install and use it, license. Gathers facts from the repo first (manifest, entry points, CLI help, CI config, license file), verifies every command it prints, matches the project's language and size, and rejects marketing tone, emoji headers, invented features, and internals tours. File trees and architecture diagrams only when readers cannot navigate without them. Use when asked to write, rewrite, improve, shorten, or review a README."
argument-hint: "[project dir or README path]"
---

# README Writer

A README is the project's front door. The reader has just arrived, knows nothing, and gives you about thirty seconds to answer three questions in order: **What is this? Should I use it? How do I start?** Every other section is optional and earns its place only by serving that reader.

## Step 1: Gather facts before writing a word

Never write from the project name and a guess. Collect from the repo itself:

- **Identity**: the manifest (`package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `install.sh`, ...), the existing README, `docs/`, `CHANGELOG`, `LICENSE`.
- **What it actually does**: read the main module or command, not the file list. For a CLI run `--help`. For a library read the public exports. For a config or dotfiles repo read the install script and the things it installs.
- **How it is installed and run**: the real commands. Run them when safe (into a temp dir, with `--help`, `--dry-run`, or `--version`). A README command that fails is worse than no README.
- **Badges that are real**: CI config present gives a build badge; published to a registry gives a version badge; a `LICENSE` file gives a license badge. Nothing else.
- **Audience and language**: who uses this (end users, developers, only the author), and which language the existing docs, commits, and comments use. Write in that language. When the project has no docs yet, use the language the user is speaking to you.
- **The existing README**: keep every fact that is correct and specific. Rewriting is not license to lose what the author wrote. Correct what is wrong, cut what is filler, and say in your final message what you removed.

## Step 2: Choose the shape from the project type and size

| Project | Sections that usually earn a place | Usually skip |
|---|---|---|
| Small tool, script, dotfiles | name and pitch, install, usage, license | badges, contributing, architecture, table of contents |
| CLI | pitch, install, quick start, short command reference that points to `--help`, config, license | file tree |
| Library or SDK | pitch, install, minimal example with real output, key API with a link to full docs, compatibility, license | internals, every option |
| Service or app | pitch, requirements, run locally, configuration table (env vars), deploy pointer, license | code walkthrough |
| Large multi-module repo | pitch, layout overview (the one case for a file tree or diagram), where to start, per-module links, license | per-module detail inline |

Length follows size. A 200-line tool gets a 30-line README. Remove a section rather than pad it.

## Section guidance, in order

1. **Name and one-line pitch**. Plain words: what it does and for whom. "Syncs a folder of Markdown notes to Notion", not "a powerful, flexible sync framework".
2. **Badges**. One row, only real ones.
3. **Why or when to use it**. The problem, in one paragraph. Compare to alternatives only if a newcomer would genuinely be choosing between them.
4. **Install**. The shortest verified path. One primary method; alternatives collapsed or linked.
5. **Usage**. The most common task first, as a runnable command or snippet with its real output. Two or three examples beat ten.
6. **Configuration**. Only the options a user must know to use it. A table once there are more than three.
7. **License**. The name and a link to the file. A contributing line if the project accepts contributions and says how.

## Avoid

- **Marketing tone**: powerful, robust, seamless, comprehensive, blazing fast, elegant, modern, next-generation. A claim with no number or example behind it is cut.
- **Emoji headers and feature bullet lists** ("🚀 Features", "✨ Highlights"). Features are shown in the pitch and the usage examples, not listed.
- **Invented content**: features you assumed, commands you did not run, screenshots that do not exist, a roadmap nobody planned, a "Contributing" process the project does not have.
- **Internals tour**: how it works, class names, design principles, "Project Structure". That is contributor documentation; link `CONTRIBUTING.md` or `docs/` if they exist.
- **Boilerplate**: a table of contents for a README under two screens, "PRs welcome!", "Acknowledgments" with nobody to acknowledge, "Support" with no channel, "Made with ❤️".
- **Full API or config dumps**. Point to generated docs or `--help`.
- **File trees and architecture diagrams by default**. Include one only when a reader cannot find their way without it, and limit it to the parts they need.

## Step 3: Verify before finishing

- Every command in the README was run in this session, or is a copy of one that was. Name in your final message any command you could not verify and why.
- Every link resolves: relative paths exist, URLs answer.
- A stranger can say what the project is after the first line, and can install and run it without asking a question.
- Nothing describes internals the reader did not need. Nothing describes a feature that does not exist.
- The license is visible.
- The language matches the project, and the length matches its size.
