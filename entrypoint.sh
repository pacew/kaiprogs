#!/usr/bin/env bash
# Container entrypoint: runs on every start before handing off to bash.

# MEMORY.md in kaiprogs is the single source of truth for claude memory.
MEMORY_DIR="/home/pace/.claude/projects/-home-pace-kai-kaiprogs/memory"
mkdir -p "${MEMORY_DIR}"
ln -sf "/home/pace/kai/kaiprogs/MEMORY.md" "${MEMORY_DIR}/MEMORY.md"

# Keep ~/.claude.json inside the named volume (not the kai tree) so the API
# key never lands as a plain file on the host filesystem.
# ~/.claude.json symlinks to ~/.claude/claude.json which lives in the volume.
CLAUDE_JSON="/home/pace/.claude/claude.json"
if ! grep -q '"hasCompletedOnboarding"' "${CLAUDE_JSON}" 2>/dev/null; then
    printf '{"hasCompletedOnboarding":true}\n' > "${CLAUDE_JSON}"
fi
ln -sf "${CLAUDE_JSON}" /home/pace/.claude.json

exec /bin/bash
