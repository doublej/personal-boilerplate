# Python Project Boilerplate

A comprehensive cookiecutter template for Python projects optimized for code quality, agent-friendly structure, and modern tooling.

## Features

- **Agent-Friendly Structure**: Organized with clear module boundaries for better AI code assistance
- **Modern Dependency Management**: Uses `uv` for fast, reliable dependency resolution
- **Strict Code Quality**: Pre-configured with `ruff`, `mypy`, and pre-commit hooks
- **Comprehensive Testing**: pytest setup with optional coverage reporting
- **Optional Documentation**: MkDocs integration with Material theme
- **Flexible Packaging**: Optional pyproject.toml configuration for package distribution
- **Professional Standards**: Follows PEP 8, includes proper .gitignore, .claudeignore
- **Claude Code Hooks**: Automatic quality checks and git commits via `.claude/settings.json`

## Quick Start

```bash
# Install cookiecutter if not already installed
pip install cookiecutter

# Generate a new project
cookiecutter https://github.com/your-username/python-boilerplate
# OR if using locally:
cookiecutter /path/to/this/directory
```

## Project Options

- **project_name**: Display name for your project
- **project_slug**: Generated slug (package directory name)
- **package_name**: Python package name (automatically derived)
- **author_name**: Your name
- **author_email**: Your email address
- **project_description**: Brief project description
- **python_version**: Python version requirement (default: 3.11)
- **include_packaging**: Enable package distribution setup (yes/no)
- **include_mkdocs**: Include MkDocs documentation setup (yes/no)
- **license**: Choose license (MIT, Apache-2.0, GPL-3.0, BSD-3-Clause, None)
- **gitignore_profile**: Select .gitignore template (minimal, standard, comprehensive, ai-dev, web-dev, data-science)
- **max_lines_per_file**: Maximum lines of code per file for custom linting (default: 400)
- **create_venv**: Automatically create virtual environment during setup (yes/no)
- **venv_name**: Virtual environment directory name (.venv, venv, env)
- **git_init**: Initialize git repository with initial commit (yes/no, default: yes)

## Generated Project Structure

```
your_project/
├── .gitignore
├── .claudeignore             # Claude Code ignore patterns
├── .pre-commit-config.yaml   # Pre-commit hooks
├── .python-version           # Python version for pyenv
├── CLAUDE.md                 # Claude Code project instructions
├── LICENSE                   # License file (if selected)
├── README.md                 # Project documentation
├── pyproject.toml           # Modern Python project configuration
├── src/
│   └── your_package/
│       ├── __init__.py
│       ├── core/            # Core functionality modules
│       │   └── __init__.py
│       └── utils/           # Utility functions
│           └── __init__.py
├── tests/
│   ├── __init__.py
│   └── test_core.py
├── data/                    # Data directories with .gitkeep
│   ├── raw/
│   ├── processed/
│   └── interim/
└── scripts/                 # Utility scripts
```

## Development Workflow

After generating a project:

```bash
cd your_project

# Create virtual environment
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# Install dependencies with uv
uv sync --dev

# Install pre-commit hooks
pre-commit install

# Run quality checks
ruff check . && ruff format . && mypy src/ && pytest
```

## Code Quality Features

### Ruff Configuration
- Line length: 100 characters
- Comprehensive rule set (pycodestyle, pyflakes, isort, flake8-bugbear, etc.)
- Pre-configured ignore patterns for common false positives

### MyPy Configuration
- Strict type checking enabled
- Comprehensive type validation
- Clear error reporting

### Pre-commit Hooks
- Trailing whitespace removal
- File formatting with ruff
- Type checking with mypy
- YAML validation
- Large file prevention

### Gitignore Profiles
- **minimal**: Basic Python patterns for simple projects
- **standard**: Comprehensive Python development patterns
- **comprehensive**: Extensive patterns for complex projects
- **ai-dev**: Optimized for AI/ML development with Claude Code, Cursor, etc.
- **web-dev**: Full-stack web development with Django/Flask + Node.js
- **data-science**: Data science workflows with Jupyter, models, datasets

### Testing
- pytest configuration
- Optional coverage reporting (when packaging enabled)
- Test structure mirrors source structure

## Agent Optimization

This template is designed to work excellently with AI coding assistants like Claude Code:

- **Clear Module Boundaries**: src/ layout with feature-based organization
- **Comprehensive Documentation**: CLAUDE.md with project-specific instructions
- **Quality Gates**: Strict linting and type checking prevent common issues
- **Ignore Patterns**: .claudeignore excludes generated/cache files from context

## Usage Examples

### Minimal Project
```bash
cookiecutter . --no-input \
  project_name="My Tool" \
  include_packaging="no" \
  include_mkdocs="no"
```

### Full-Featured Library
```bash
cookiecutter . --no-input \
  project_name="My Library" \
  include_packaging="yes" \
  include_mkdocs="yes" \
  license="MIT"
```

## Requirements

- Python 3.11+
- cookiecutter
- uv (recommended, or pip as fallback)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Test your changes with multiple project configurations
4. Submit a pull request

## License

This template is licensed under the MIT License.