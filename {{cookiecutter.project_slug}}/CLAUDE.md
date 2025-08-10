# Claude Code Project Instructions

## Project Overview
{{ cookiecutter.project_description }}

**Status**: This is a newly scaffolded project created from a cookiecutter template. Core functionality needs to be implemented.

**Gitignore Profile**: This project was generated with the "{{ cookiecutter.gitignore_profile }}" .gitignore profile, optimized for {{ cookiecutter.gitignore_profile.replace('-', ' ') }} workflows.

## Changelog Maintenance
**IMPORTANT**: Update `CHANGELIST.md` with every significant change. This file tracks all project modifications and should be kept current. Add entries under "Unreleased" and move them to version sections when releasing.

## Development Commands

### Setup
```bash
{% if cookiecutter.git_init == "yes" -%}
# Git repository already initialized with initial commit
{% else -%}
# Initialize git repository (if not done during project setup)
git init && git add . && git commit -m "Initial commit"
{% endif -%}

{% if cookiecutter.create_venv == "yes" -%}
# Virtual environment already created during project setup
source {{ cookiecutter.venv_name }}/bin/activate  # On Windows: {{ cookiecutter.venv_name }}\Scripts\activate
{% else -%}
# Create virtual environment with uv
uv venv {{ cookiecutter.venv_name }}
source {{ cookiecutter.venv_name }}/bin/activate  # On Windows: {{ cookiecutter.venv_name }}\Scripts\activate
{% endif -%}

# Install dependencies with uv
uv sync --dev
```

### Code Quality
```bash
# Format code
ruff format .

# Lint code
ruff check .

# Type check
mypy src/

# Custom linting (max lines per file, try/except detection)
uv run scripts/lint_custom.py

# Run all quality checks
ruff check . && ruff format . && mypy src/ && uv run scripts/lint_custom.py
```

### Testing
```bash
# Run tests
pytest

# Run tests with coverage
pytest --cov=src/{{ cookiecutter.package_name }}

# Run specific test
pytest tests/test_core.py::test_placeholder
```

### Dependencies
```bash
# Add dependency
uv add package_name

# Add dev dependency
uv add --dev package_name

# Update dependencies
uv sync
```

## Project Structure

```
src/{{ cookiecutter.package_name }}/
├── __init__.py          # Package initialization
├── core/                # Core functionality modules
├── utils/               # Utility functions and helpers
└── models/              # Data models and classes (create as needed)

tests/                   # Test files mirror src structure
```

## Code Standards

- Use type hints for all functions and methods
- Follow PEP 8 style guide (enforced by ruff)
- Maintain test coverage above 80%
- Use descriptive variable and function names
- Keep functions focused and single-purpose
- Document public APIs with docstrings

### Custom Rules (Enforced by hooks)
- **Max lines per file**: {{ cookiecutter.max_lines_per_file }} lines of code
- **Avoid try/except blocks**: Use explicit validation and error returns instead
- **File organization**: Split large files into smaller, focused modules

## Before Committing

1. Update `CHANGELIST.md` with your changes
2. Run the full quality check suite:
```bash
ruff check . && ruff format . && mypy src/ && uv run scripts/lint_custom.py && pytest
```

## Claude Code Hooks

This project includes Claude Code hooks configured in `.claude/settings.json` that provide:

### Automatic Quality Enforcement
- **PreToolUse**: Runs `ruff format` and `ruff check --fix` before Write/Edit operations
- **PostToolUse**: Runs `mypy` type checking after code modifications
- **Quality Gates**: Ensures code meets standards before and after changes

### Automatic Git Integration
- **UserPromptSubmit**: Creates commit before Claude Code starts working
- **Stop**: Creates commit after Claude Code completes changes
- **Professional Commit Messages**: Includes Claude Code attribution

### Session Management
- **SessionStart**: Shows project info and reminds about CLAUDE.md instructions
- **Changelog Reminders**: Prompts to update CHANGELIST.md when it's over 30 minutes old

### Hook Configuration
The hooks are defined in `.claude/settings.json` and run automatically when using Claude Code in this project directory. They provide deterministic control over the development workflow.

### Git Workflow Management
- **WIP Commits**: Before-session commits are marked with `[claude-code-wip]` for easy identification
- **Clean History**: Use `git rebase -i HEAD~n` to squash WIP commits before pushing
- **Documentation**: See `CLAUDE_GIT_WORKFLOW.md` for detailed git history management strategies

## Implementation Notes

This project was scaffolded with a cookiecutter template and requires implementation:
- Core functionality in `src/{{ cookiecutter.package_name }}/core/`
- Utility functions in `src/{{ cookiecutter.package_name }}/utils/`
- Comprehensive tests in `tests/`
- Documentation updates in README.md and CHANGELIST.md