#!/usr/bin/env bash
set -euo pipefail

if [ -z "${ANTHROPIC_API_KEY:-}" ]; then
    echo "Error: ANTHROPIC_API_KEY is not set" >&2
    exit 1
fi

exec docker run -it --rm \
    --name kai \
    -v "${HOME}/kai:/home/pace/kai" \
    -e ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY}" \
    kai
