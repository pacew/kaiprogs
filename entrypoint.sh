#!/usr/bin/env bash
# Container entrypoint: runs on every start before handing off to bash.
# Sets up the claude memory symlink so MEMORY.md in kaiprogs is the single
# source of truth for both host and container claude sessions.

MEMORY_DIR="/home/pace/.claude/projects/-home-pace-kai-kaiprogs/memory"
mkdir -p "${MEMORY_DIR}"
ln -sf "/home/pace/kai/kaiprogs/MEMORY.md" "${MEMORY_DIR}/MEMORY.md"

exec /bin/bash
