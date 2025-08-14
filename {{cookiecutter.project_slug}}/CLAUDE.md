# Claude Code Project Instructions

## Project Overview
{{ cookiecutter.project_description }}

**Status**: Newly scaffolded project. Core functionality needs implementation.

## Essential Rules
- Update `CHANGELIST.md` with every significant change
- Use type hints for all functions and methods  
- Keep files under {{ cookiecutter.max_lines_per_file }} lines of code
- Avoid try/except blocks (use explicit error handling)

## Quick Commands

```bash
# Setup (first time)
uv sync --dev

# Quality checks (automated by Claude Code hooks)
ruff format . && ruff check . && mypy src/

# Testing  
pytest
```

{% if cookiecutter.include_docker == "yes" -%}
## Docker Commands

```bash
# Build and run
docker build -t {{ cookiecutter.project_slug }} . && docker run -p {{ cookiecutter.docker_port }}:{{ cookiecutter.docker_port }} {{ cookiecutter.project_slug }}

# Development mode with live code changes
docker run -p {{ cookiecutter.docker_port }}:{{ cookiecutter.docker_port }} -v $(pwd):/app {{ cookiecutter.project_slug }}
```
{% endif %}

## Claude Code Integration

This project includes automated quality checks and git integration via Claude Code hooks.

**Key Features:**
- Automatic code formatting and linting
- Type checking after changes
- File protection for sensitive files  
- Desktop notifications (macOS)
- Professional git workflow with WIP commits

**Complete documentation:** See `.claude/README.md` for full Claude Code configuration details.