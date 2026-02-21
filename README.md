# kai — knowledge with AI

An AI-assisted personal knowledge manager, built as a hobby project with two goals:
learn Claude Code in depth, and build something personally useful.

The spirit is Obsidian-style interlinked notes, but with no GUI requirement and no
compatibility obligations. Primary interfaces are emacs and Unix CLI tools.

## What's here

This repository (`kaiprogs`) contains the programs and infrastructure that run kai:
a Docker container definition, bootstrap script, and utilities. Notes themselves
live separately in `~/kai/notes/` and are not in version control.

## Security design

Claude Code runs inside a Docker container with access only to the kai tree.
On the host, the kai tree is bind-mounted `noexec` to make it easier to stick to
the policy of not running programs that may have been written by the AI inside the
container. This is not airtight: a host interpreter (bash, python, etc.) can still
be pointed at scripts in the kai tree. The defense is policy and habit, with noexec
as a mechanical reminder, not a hard barrier.

Changes Claude makes to kaiprogs flow through a two-clone git workflow that requires
human review before anything reaches GitHub.

Container network access is currently unrestricted outbound, which is a known gap.
The intent is to limit it to the minimum Anthropic API endpoints required for Claude
to function.

The threat model is explicitly permissive about data sensitivity in exchange for
being able to work in this area at all.

## Status

Early infrastructure stage. The container builds and runs, Claude Code works inside
it, and the git workflow is operational. The actual PKM features are next.

## Contact

If you're working on something in this space and want to compare notes, I'd like
to hear from you: pace.willisson@gmail.com
