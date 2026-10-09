#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
image=devops-tool
docker build -t "$image" .
docker run --rm "$image" help
docker run --rm "$image" system-info
if docker run --rm "$image" invalid-command >/dev/null 2>&1; then
    echo 'Invalid command should fail' >&2
    exit 1
fi
echo 'Docker smoke tests passed'
