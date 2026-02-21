#!/usr/bin/env bash
set -euo pipefail

if [ -z "${ANTHROPIC_API_KEY:-}" ]; then
    echo "Error: ANTHROPIC_API_KEY is not set" >&2
    exit 1
fi

# If the container is already running, open a new shell in it.
if docker ps --format '{{.Names}}' | grep -q '^kai$'; then
    exec docker exec -it kai /bin/bash
fi

# Mount CLAUDE.md (user instructions) read-only.
# Claude's writable config lives in a named volume so setup persists across restarts.
# ~/.claude.json (main config) is persisted as a file in the kai tree.
claude_mounts=()
src="${HOME}/.claude/CLAUDE.md"
[ -f "${src}" ] && claude_mounts+=(-v "${src}:/home/pace/.claude/CLAUDE.md:ro")

CLAUDE_JSON="${HOME}/kai/.claude.json"
touch "${CLAUDE_JSON}"   # ensure it exists as a file before docker sees it

exec docker run -it --rm \
    --name kai \
    -v "${HOME}/kai:/home/pace/kai" \
    -v "kai-claude-config:/home/pace/.claude" \
    -v "${CLAUDE_JSON}:/home/pace/.claude.json" \
    "${claude_mounts[@]}" \
    -e ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY}" \
    -e TERM="${TERM:-xterm-256color}" \
    kai
