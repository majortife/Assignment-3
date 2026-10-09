#!/usr/bin/env bash
set -u
cd "$(dirname "$0")/.."
APP=./app/app.sh
passed=0
failed=0
check() {
    local description="$1" expected="$2"; shift 2
    "$@" >/dev/null 2>&1
    local actual=$?
    if [[ "$actual" -eq "$expected" ]]; then
        printf 'PASS: %s\n' "$description"
        passed=$((passed + 1))
    else
        printf 'FAIL: %s (expected %s, got %s)\n' "$description" "$expected" "$actual"
        failed=$((failed + 1))
    fi
}
check 'help' 0 "$APP" help
check 'system information' 0 "$APP" system-info
check 'invalid command' 2 "$APP" nonsense
check 'missing command' 2 "$APP"
check 'missing host' 2 "$APP" check-host
check 'valid host' 0 "$APP" check-host localhost
check 'missing port' 2 "$APP" check-port localhost
check 'non-numeric port' 2 "$APP" check-port localhost abc
check 'port below range' 2 "$APP" check-port localhost 0
check 'port above range' 2 "$APP" check-port localhost 65536
check 'missing host for port check' 2 "$APP" check-port
check 'extra arguments' 2 "$APP" system-info unexpected
printf 'Passed: %s; Failed: %s\n' "$passed" "$failed"
[[ "$failed" -eq 0 ]]
