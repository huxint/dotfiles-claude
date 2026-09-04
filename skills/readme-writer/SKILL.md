---
name: readme-writer
description: "Writes or rewrites a README for the person who just found the project: what it is in one line, why it exists, how to install and use it, license. Gathers facts from the repo first (manifest, entry points, CLI help, CI config, license file), verifies every command it prints, matches the project's language and size, and rejects marketing tone, emoji headers, invented features, and internals tours. File trees and architecture diagrams only when readers cannot navigate without them. Use when asked to write, rewrite, improve, shorten, or review a README."
argument-hint: "[project dir or README path]"
---

# README Writer

The reader has just arrived, knows nothing, and gives thirty seconds to answer three questions in order: **What is this? Should I use it? How do I start?** Every other section earns its place only by serving that reader.

## Gather facts first

Never write from the project name and a guess.

- **Identity**: the manifest (`package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `install.sh`), existing README, `docs/`, `CHANGELOG`, `LICENSE`.
- **What it does**: read the main module or command, not the file list. CLI: run `--help`. Library: read the public exports. Dotfiles: read the install script and what it installs.
- **How to install and run**: the real commands. Run them when safe (temp dir, `--help`, `--dry-run`, `--version`). A command that fails is worse than no README.
- **Real badges only**: CI config gives a build badge; a registry gives a version badge; a `LICENSE` file gives a license badge.
- **Audience and language**: who uses this, and which language the existing docs, commits, and comments use. Write in that language. With no docs yet, use the language the user is speaking.
- **The existing README**: keep every fact that is correct and specific. Correct what is wrong, cut what is filler, and say in the final message what was removed.

## Shape follows project type and size

| Project | Sections that earn a place | Skip |
|---|---|---|
| Small tool, script, dotfiles | name and pitch, install, usage, license | badges, contributing, architecture, table of contents |
| CLI | pitch, install, quick start, short command reference pointing to `--help`, config, license | file tree |
| Library or SDK | pitch, install, minimal example with real output, key API with link to full docs, compatibility, license | internals, every option |
| Service or app | pitch, requirements, run locally, env var table, deploy pointer, license | code walkthrough |
| Large multi-module repo | pitch, layout overview (the one case for a file tree), where to start, per-module links, license | per-module detail inline |

A 200-line tool gets a 30-line README. Remove a section rather than pad it.

## Sections, in order

1. **Name and one-line pitch**: what it does and for whom. "Syncs a folder of Markdown notes to Notion", not "a powerful, flexible sync framework".
2. **Badges**: one row, only real ones.
3. **Why or when to use it**: the problem, one paragraph. Compare to alternatives only if a newcomer would genuinely be choosing.
4. **Install**: the shortest verified path. One primary method; alternatives linked.
5. **Usage**: the most common task first, as a runnable command with its real output. Two or three examples beat ten.
6. **Configuration**: only what a user must know. A table once there are more than three options.
7. **License**: name and link. A contributing line if the project accepts contributions and says how.

## Avoid

- **Marketing tone**: powerful, robust, seamless, comprehensive, blazing fast, elegant, modern. A claim with no number or example behind it is cut.
- **Emoji headers and feature bullet lists**. Features are shown in the pitch and usage examples.
- **Invented content**: assumed features, unrun commands, missing screenshots, a roadmap nobody planned, a contributing process the project does not have.
- **Internals tour**: how it works, class names, "Project Structure". That is contributor documentation; link it if it exists.
- **Boilerplate**: a table of contents for a README under two screens, "PRs welcome!", empty "Acknowledgments" or "Support", "Made with ❤️".
- **Full API or config dumps**. Point to generated docs or `--help`.
- **File trees and diagrams by default**. Only when a reader cannot navigate without one, limited to what they need.

## Verify before finishing

- Every command in the README was run this session, or copies one that was. Name any command that could not be verified and why.
- Every link resolves.
- A stranger can say what the project is after the first line, and can install and run it without asking a question.
- Nothing describes internals the reader did not need or features that do not exist.
- The license is visible. The language matches the project and the length matches its size.
