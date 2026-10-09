# Assignment 3 - CI/CD with GitHub Actions

A Bash command-line tool for checking Linux system information, resolving hosts, and testing TCP ports. GitHub Actions runs validation, tests, and Docker checks whenever code is pushed or a pull request is opened.

## Requirements

- Linux or WSL with Bash
- Git
- Docker with Compose support
- `ping`, `getent`, `timeout` (available on Ubuntu with the packages below)

If needed on Ubuntu:

```bash
sudo apt update
sudo apt install -y iputils-ping libc-bin coreutils
```

## Setup

```bash
chmod +x app/app.sh scripts/*.sh tests/test.sh grade.sh
```

## Commands

```bash
./app/app.sh help
./app/app.sh system-info
./app/app.sh check-host localhost
./app/app.sh check-port localhost 22
```

`check-host` resolves a hostname and attempts to ping it. `check-port` checks a TCP connection with a three-second timeout. A failed connection or blocked ping can produce a runtime failure even when the host exists.

Exit codes: `0` for success, `1` for a failed check, and `2` for invalid input.

## Checks

```bash
./scripts/lint.sh
./tests/test.sh
./scripts/build.sh
./grade.sh
```

The test script checks the help and system commands, invalid commands, missing arguments, valid hostnames, and invalid port values. The build script builds the Docker image and runs smoke tests, including an invalid command.

You can also run the container directly:

```bash
docker build -t devops-tool .
docker run --rm devops-tool help
docker run --rm devops-tool system-info
docker compose config
```

## CI workflow

The workflow is in `.github/workflows/ci.yml` and runs on pushes and pull requests. Its jobs run in order:

1. `validate` checks required files and Bash syntax.
2. `test` runs the Bash tests after validation succeeds.
3. `docker` builds the image and runs smoke tests after tests succeed.

## Failed pipeline demonstration

The assignment requires a failed CI run followed by a successful fix. This must be done in the GitHub repository after the first working pipeline has passed:

1. Create a branch for the demonstration.
2. Introduce a Bash syntax error into `app/app.sh` and push the branch.
3. Open the failed run under GitHub Actions and record the failed validation job.
4. Correct the syntax error, commit the fix, and push again.
5. Confirm that the new run passes, then merge the branch.

Add the actual failed and successful run links here after completing the demonstration:

- Failed run: (add link)
- Successful run: (add link)

## Notes

The tool uses commands available in a standard Ubuntu environment. Network checks can fail because of DNS issues, firewalls, blocked ICMP traffic, or closed ports. No cloud deployment is required.
