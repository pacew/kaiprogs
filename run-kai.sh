#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -z "${ANTHROPIC_API_KEY:-}" ]; then
    echo "Error: ANTHROPIC_API_KEY is not set" >&2
    exit 1
fi

# If the container is already running, open a new shell in it.
if docker ps --format '{{.Names}}' | grep -q '^kai$'; then
    exec docker exec -it kai /bin/bash
fi

# Ensure the kai Docker network exists with a known bridge interface name.
# kai-br is used by kai-firewall and kai-netwatch.
if ! docker network inspect kai-net >/dev/null 2>&1; then
    docker network create \
        --driver bridge \
        --opt com.docker.network.bridge.name=kai-br \
        kai-net
fi

# Install iptables rules restricting container to HTTPS + DNS only.
sudo "$SCRIPT_DIR/bin/kai-firewall" setup

# Mount CLAUDE.md (user instructions) read-only.
# Claude's writable config (including ~/.claude.json) lives in the named volume,
# never as a plain file on the host filesystem.
claude_mounts=()
src="${HOME}/.claude/CLAUDE.md"
[ -f "${src}" ] && claude_mounts+=(-v "${src}:/home/pace/.claude/CLAUDE.md:ro")

exec docker run -it --rm \
    --name kai \
    --network kai-net \
    -v "${HOME}/kai:/home/pace/kai" \
    -v "kai-claude-config:/home/pace/.claude" \
    "${claude_mounts[@]}" \
    -e ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY}" \
    -e TERM="${TERM:-xterm-256color}" \
    kai
