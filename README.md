# Linux Diagnostic CLI — CI/CD with GitHub Actions

This project is a Bash-based command-line tool for performing basic Linux system and network checks. I built it to work with a CI/CD pipeline using GitHub Actions, with automated validation, testing, and Docker checks.

The main goal was to build a working application and set up a pipeline that could automatically detect errors before changes were merged into the main branch.

## Features

The CLI supports four commands:

- **help:** Displays the available commands and their usage.
- **system-info:** Displays basic information about the Linux system.
- **check-host:** Resolves a hostname and checks whether it responds to a ping.
- **check-port:** Tests whether a TCP port can be reached, using a three-second timeout.

The application uses exit codes to indicate the result of each command:

- `0` — Successful execution
- `1` — Failed system or network check
- `2` — Invalid command or input

## Requirements

To run the project locally, you'll need:

- Linux or WSL with Bash
- Git
- Docker with Compose support
- `ping`, `getent`, and `timeout`

On Ubuntu, the required utilities can be installed with:

```bash
sudo apt update
sudo apt install -y iputils-ping libc-bin coreutils
```

## Getting Started

After cloning the repository, make the scripts executable:

```bash
chmod +x app/app.sh scripts/*.sh tests/test.sh grade.sh
```

Run the CLI using any of the following commands:

```bash
./app/app.sh help
./app/app.sh system-info
./app/app.sh check-host localhost
./app/app.sh check-port localhost 22
```

Network checks may fail if a host is unreachable, a port is closed, or a firewall blocks the connection.

## Testing and Validation

I included scripts for validating the Bash files, running automated tests, and checking the Docker build.

```bash
./scripts/lint.sh
./tests/test.sh
./scripts/build.sh
```

The tests cover valid and invalid commands, missing arguments, hostname checks, port validation, and other expected application behaviours.

The application can also be built and run using Docker:

```bash
docker build -t devops-tool .
docker run --rm devops-tool help
docker run --rm devops-tool system-info
docker compose config
```

## CI/CD Pipeline

I configured GitHub Actions to automatically run the pipeline whenever code is pushed or a pull request is opened.

The workflow is defined in `.github/workflows/ci.yml` and contains three dependent jobs:

1. **Validate:** Checks the required project files, Bash syntax, and linting.
2. **Test:** Runs the automated Bash tests after validation passes.
3. **Docker:** Builds the application image and performs container smoke tests after the tests pass.

The jobs run in this order so that errors can be detected before moving to the next stage.

## Testing CI Failure and Recovery

To verify that the pipeline could detect errors, I created a separate branch called `ci-failure-demo` and deliberately introduced a Bash syntax error into `app/app.sh`.

When I committed the change, GitHub Actions ran the workflow and the validation job failed as expected. This confirmed that the pipeline could identify invalid Bash syntax before proceeding to testing and Docker builds.

I then removed the syntax error and committed the correction. GitHub Actions ran the workflow again, and all three jobs passed.

This allowed me to test both outcomes of the pipeline: detecting a faulty change and confirming that the corrected version passed the automated checks.

**Workflow evidence:**



## Project Structure

```text
app/
  app.sh
scripts/
  lint.sh
  build.sh
tests/
  test.sh
.github/workflows/
  ci.yml
Dockerfile
compose.yaml
.dockerignore
.gitignore
README.md
grade.sh
```

## Notes

The application uses standard Ubuntu command-line utilities. Network checks depend on the environment, so DNS issues, blocked ICMP traffic, firewalls, and closed ports can affect the results.

The project runs locally and in Docker, while GitHub Actions handles the automated CI checks. No cloud deployment is required.
