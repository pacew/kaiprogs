# kai project memory

## What this project is
kai = "knowledge with AI" — an AI-assisted personal knowledge manager.
A hobby project with two goals: learn Claude Code, and build a usable personal PKM.
Implemented as an Obsidian-spirit wiki but with no compatibility requirements.
Primary interface: emacs + unix CLI. No GUI.

## Directory layout (target state)

    $HOME/kai/                  — kai tree; noexec bind-mounted on host
    $HOME/kai/notes/            — flat dir of timestamp-named .md nodes
    $HOME/kai/kaiprogs/         — git clone for container use (pull-only, no push authority)
    $HOME/kaiprogs/             — git clone for host use (push authority to GitHub)
                                  has remote 'kai' pointing to $HOME/kai/kaiprogs

## Security model
- Docker container runs Claude Code with kai tree mounted rw+exec
- Host mounts kai tree noexec (bind remount) — blocks direct execve, NOT bash/python interpreter execution
- The two-clone git workflow enforces human review before any push to GitHub
- Threat model: low-sensitivity data, willing to accept full-laptop-copy risk to work in this area

## Container setup
- Image: ubuntu:24.04, nodejs, npm, emacs-nox, git, claude code
- Built with: ./build-kai.sh (auto-detects host UID/GID)
- Launched with: ./run-kai.sh (mounts $HOME/kai, passes ANTHROPIC_API_KEY)
- kaiprogs/bin/ is on PATH inside container

## Node model
- Flat directory: $HOME/kai/notes/
- Filename: timestamp, e.g. 20260221T143052.md
- Format: freeform markdown for now; frontmatter will emerge when needed
- Tool: bin/newnode (creates file, opens in $EDITOR or emacs)

## Key files in kaiprogs
- Dockerfile           — container definition
- bootstrap            — one-time host setup: creates dirs + noexec bind mount via fstab
- build-kai.sh         — builds docker image tagged 'kai'
- run-kai.sh           — launches container
- bin/newnode          — creates a new note node

## Status as of 2026-02-21
- Full stack verified end-to-end: bootstrap → build → run → claude all work smoothly
- GitHub remote live at github.com:pacew/kaiprogs.git (public)
- Two-clone git workflow operational: host pushes to GitHub, container pulls
- ANTHROPIC_API_KEY stored in ~/.bashrc on host, passed into container via run-kai.sh
- Ready to migrate main conversation into the container

## Docker notes
- ubuntu:24.04 ships with 'ubuntu' user at UID/GID 1000; Dockerfile handles this by
  renaming existing group/user rather than creating fresh (groupmod/usermod)
- docker.io (apt) used, not snap (snap has bind-mount confinement issues)
- .dockerignore excludes .git to avoid legacy builder pipe errors
- Named volume kai-claude-config persists ~/.claude/ across container restarts
- ~/.claude.json persisted as ~/kai/.claude.json (bind-mounted into container)
- bootstrap pre-seeds ~/kai/.claude.json with {"hasCompletedOnboarding":true} to skip wizard
- run-kai.sh execs into running container if already running (docker exec)
- To do a full reset: sudo umount ~/kai && rm -rf ~/kai && docker rmi kai && docker volume rm kai-claude-config, then re-run bootstrap

## Context continuity note
Sessions are path-keyed. After directory move or entering container, start fresh but
read this file — it captures the full project state. Copy this file to the new
memory directory at: ~/.claude/projects/<path-encoded-dir>/memory/MEMORY.md
Path encoding: replace / with - and drop leading -.
New host path would be: -home-pace-kaiprogs
Container path (if workdir is /home/pace/kai/kaiprogs): -home-pace-kai-kaiprogs
