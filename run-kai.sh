#!/usr/bin/env bash
set -euo pipefail

if [ -z "${ANTHROPIC_API_KEY:-}" ]; then
    echo "Error: ANTHROPIC_API_KEY is not set" >&2
    exit 1
fi

# Mount host Claude Code config files read-only into the container.
# Guards handle the case where a file doesn't exist on this host yet.
claude_mounts=()
for f in CLAUDE.md settings.json .credentials.json; do
    src="${HOME}/.claude/${f}"
    [ -f "${src}" ] && claude_mounts+=(-v "${src}:/home/pace/.claude/${f}:ro")
done

exec docker run -it --rm \
    --name kai \
    -v "${HOME}/kai:/home/pace/kai" \
    "${claude_mounts[@]}" \
    -e ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY}" \
    kai
