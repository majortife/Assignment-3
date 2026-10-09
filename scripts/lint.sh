#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
for file in app/app.sh scripts/lint.sh scripts/build.sh tests/test.sh grade.sh; do
    [[ -f "$file" ]] || { echo "Missing file: $file" >&2; exit 1; }
    bash -n "$file"
done
if command -v shellcheck >/dev/null 2>&1; then
    shellcheck app/app.sh scripts/lint.sh scripts/build.sh tests/test.sh
fi
echo 'Lint checks passed'
