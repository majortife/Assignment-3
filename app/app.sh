#!/usr/bin/env bash
set -u

usage() {
    cat <<'EOF'
Usage: ./app/app.sh <command> [arguments]

Commands:
  system-info               Show system information
  check-host <host>         Resolve a host and check connectivity
  check-port <host> <port>  Check a TCP port
  help                      Show this message
EOF
}

invalid() { printf 'Error: %s\n' "$1" >&2; usage >&2; exit 2; }

system_info() {
    printf 'Hostname: %s\n' "$(hostname)"
    printf 'User: %s\n' "$(id -un)"
    printf 'Kernel: %s\n' "$(uname -r)"
    printf 'Operating system: %s\n' "$(uname -s)"
    printf 'Uptime: %s\n' "$(uptime -p 2>/dev/null || uptime)"
}

check_host() {
    local host="$1"
    if ! getent ahosts "$host" | head -n 1; then
        printf 'Could not resolve host: %s\n' "$host" >&2
        return 1
    fi
    if command -v ping >/dev/null 2>&1; then
        if ping -c 1 -W 2 "$host" >/dev/null 2>&1; then
            printf 'Ping successful: %s\n' "$host"
        else
            printf 'Ping failed or blocked: %s\n' "$host" >&2
        fi
    else
        printf 'Ping is not installed; DNS lookup succeeded.\n'
    fi
}

check_port() {
    local host="$1" port="$2"
    [[ "$port" =~ ^[0-9]+$ ]] || invalid 'Port must be a number from 1 to 65535'
    (( 10#$port >= 1 && 10#$port <= 65535 )) || invalid 'Port must be between 1 and 65535'
    if ! getent ahosts "$host" >/dev/null 2>&1; then
        printf 'Could not resolve host: %s\n' "$host" >&2
        return 1
    fi
    # shellcheck disable=SC2016
    if timeout 3 bash -c 'exec 3<>/dev/tcp/"$1"/"$2"' _ "$host" "$port" 2>/dev/null; then
        printf 'TCP connection successful: %s:%s\n' "$host" "$port"
    else
        printf 'TCP connection failed: %s:%s\n' "$host" "$port" >&2
        return 1
    fi
}

case "${1:-}" in
    help) [[ $# -eq 1 ]] || invalid 'help takes no arguments'; usage ;;
    system-info) [[ $# -eq 1 ]] || invalid 'system-info takes no arguments'; system_info ;;
    check-host) [[ $# -eq 2 && -n "$2" ]] || invalid 'Provide one host'; check_host "$2" ;;
    check-port) [[ $# -eq 3 && -n "$2" && -n "$3" ]] || invalid 'Provide a host and port'; check_port "$2" "$3" ;;
    *) invalid 'Unknown or missing command' ;;
esac
