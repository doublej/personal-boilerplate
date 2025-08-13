# Claude Code Project Instructions

## Project Overview
A brief description of your project

## Development Commands

### Setup
```bash
# Create virtual environment
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

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

# Run all quality checks
ruff check . && ruff format . && mypy src/
```

### Testing
```bash
# Run tests
pytest

# Run tests with coverage
pytest --cov=src/test_project

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
src/test_project/
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

## Before Committing

Run the full quality check suite:
```bash
ruff check . && ruff format . && mypy src/ && pytest
```