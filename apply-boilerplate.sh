#!/bin/bash

# Apply Python Boilerplate to Existing Project
# Usage: ./apply-boilerplate.sh [options]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
GITIGNORE_PROFILE="standard"
INCLUDE_MKDOCS="no"
INCLUDE_PACKAGING="no"
PYTHON_VERSION="3.11"
LICENSE="MIT"
BACKUP_DIR=".boilerplate-backup-$(date +%Y%m%d-%H%M%S)"

print_usage() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -g, --gitignore PROFILE   Gitignore profile (minimal|standard|comprehensive|ai-dev|web-dev|data-science)"
    echo "  -m, --mkdocs             Include MkDocs setup"
    echo "  -p, --packaging          Include packaging setup"
    echo "  -v, --python VERSION     Python version (default: 3.11)"
    echo "  -l, --license LICENSE    License (MIT|Apache-2.0|GPL-3.0|BSD-3-Clause|None)"
    echo "  -h, --help              Show this help"
    echo ""
    echo "Example:"
    echo "  $0 --gitignore ai-dev --mkdocs --packaging"
}

log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

backup_file() {
    local file="$1"
    if [ -f "$file" ]; then
        mkdir -p "$BACKUP_DIR"
        cp "$file" "$BACKUP_DIR/"
        log "Backed up $file to $BACKUP_DIR/"
    fi
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -g|--gitignore)
            GITIGNORE_PROFILE="$2"
            shift 2
            ;;
        -m|--mkdocs)
            INCLUDE_MKDOCS="yes"
            shift
            ;;
        -p|--packaging)
            INCLUDE_PACKAGING="yes"
            shift
            ;;
        -v|--python)
            PYTHON_VERSION="$2"
            shift 2
            ;;
        -l|--license)
            LICENSE="$2"
            shift 2
            ;;
        -h|--help)
            print_usage
            exit 0
            ;;
        *)
            error "Unknown option: $1"
            print_usage
            exit 1
            ;;
    esac
done

# Validate gitignore profile
case $GITIGNORE_PROFILE in
    minimal|standard|comprehensive|ai-dev|web-dev|data-science)
        ;;
    *)
        error "Invalid gitignore profile: $GITIGNORE_PROFILE"
        exit 1
        ;;
esac

echo "🚀 Applying Python Boilerplate Configuration"
echo "============================================="
echo "Gitignore Profile: $GITIGNORE_PROFILE"
echo "Include MkDocs: $INCLUDE_MKDOCS"
echo "Include Packaging: $INCLUDE_PACKAGING"
echo "Python Version: $PYTHON_VERSION"
echo "License: $LICENSE"
echo ""

# Detect project info
PROJECT_NAME=$(basename "$(pwd)")
PACKAGE_NAME=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/_/g')

read -p "Project name [$PROJECT_NAME]: " input_name
PROJECT_NAME=${input_name:-$PROJECT_NAME}

read -p "Package name [$PACKAGE_NAME]: " input_package
PACKAGE_NAME=${input_package:-$PACKAGE_NAME}

read -p "Author name: " AUTHOR_NAME
read -p "Author email: " AUTHOR_EMAIL
read -p "Project description: " PROJECT_DESCRIPTION

echo ""
log "Applying boilerplate configuration..."

# 1. Setup pyproject.toml
log "Configuring pyproject.toml..."
backup_file "pyproject.toml"

cat > pyproject.toml << EOF
[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[project]
name = "$PACKAGE_NAME"
EOF

if [ "$INCLUDE_PACKAGING" = "yes" ]; then
    echo 'dynamic = ["version"]' >> pyproject.toml
else
    echo 'version = "0.1.0"' >> pyproject.toml
fi

cat >> pyproject.toml << EOF
description = "$PROJECT_DESCRIPTION"
authors = [
    {name = "$AUTHOR_NAME", email = "$AUTHOR_EMAIL"},
]
readme = "README.md"
requires-python = ">=$PYTHON_VERSION"
EOF

if [ "$LICENSE" != "None" ]; then
    echo "license = {text = \"$LICENSE\"}" >> pyproject.toml
fi

cat >> pyproject.toml << EOF
dependencies = []

[project.optional-dependencies]
dev = [
    "pytest>=8.0.0",
    "pytest-cov>=4.0.0",
    "mypy>=1.8.0",
    "ruff>=0.1.0",
    "pre-commit>=3.6.0",
]
EOF

if [ "$INCLUDE_MKDOCS" = "yes" ]; then
    cat >> pyproject.toml << EOF
docs = [
    "mkdocs>=1.5.0",
    "mkdocs-material>=9.5.0",
    "mkdocs-autorefs>=0.5.0",
    "mkdocstrings[python]>=0.24.0",
]
EOF
fi

if [ "$INCLUDE_PACKAGING" = "yes" ]; then
    cat >> pyproject.toml << EOF

[project.urls]
Homepage = "https://github.com/$AUTHOR_NAME/$PACKAGE_NAME"
Repository = "https://github.com/$AUTHOR_NAME/$PACKAGE_NAME"
Issues = "https://github.com/$AUTHOR_NAME/$PACKAGE_NAME/issues"

[tool.hatch.version]
path = "src/$PACKAGE_NAME/__init__.py"
EOF
fi

# Add tool configurations
cat >> pyproject.toml << 'EOF'

[tool.ruff]
target-version = "py311"
line-length = 100
select = [
    "E",  # pycodestyle errors
    "W",  # pycodestyle warnings
    "F",  # pyflakes
    "I",  # isort
    "B",  # flake8-bugbear
    "C4", # flake8-comprehensions
    "UP", # pyupgrade
    "ARG001", # unused arguments
    "SIM", # flake8-simplify
]
ignore = [
    "E501",  # line too long, handled by black
    "B008",  # do not perform function calls in argument defaults
    "C901",  # too complex
]

[tool.ruff.per-file-ignores]
"__init__.py" = ["F401"]
"tests/**/*" = ["S101", "ARG", "FBT"]

[tool.mypy]
python_version = "3.11"
check_untyped_defs = true
disallow_any_generics = true
disallow_incomplete_defs = true
disallow_untyped_defs = true
no_implicit_optional = true
warn_redundant_casts = true
warn_unused_ignores = true
warn_unreachable = true
strict_equality = true

[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
python_classes = ["Test*"]
python_functions = ["test_*"]
EOF

if [ "$INCLUDE_PACKAGING" = "yes" ]; then
    cat >> pyproject.toml << EOF
addopts = [
    "--cov=src/$PACKAGE_NAME",
    "--cov-report=term-missing",
    "--cov-report=html",
    "--cov-fail-under=80",
]

[tool.coverage.run]
source = ["src"]
omit = ["*/tests/*"]

[tool.coverage.report]
exclude_lines = [
    "pragma: no cover",
    "def __repr__",
    "raise AssertionError",
    "raise NotImplementedError",
]
EOF
else
    echo 'addopts = []' >> pyproject.toml
fi

success "pyproject.toml configured"

# 2. Setup gitignore
log "Setting up .gitignore..."
backup_file ".gitignore"

case $GITIGNORE_PROFILE in
    minimal)
        cat > .gitignore << 'EOF'
# Minimal Python .gitignore

# Byte-compiled files
__pycache__/
*.py[cod]
*$py.class

# Virtual environments
.venv/
venv/
env/

# IDE
.vscode/
.idea/

# OS files
.DS_Store
Thumbs.db

# Python distribution
build/
dist/
*.egg-info/
EOF
        ;;
    standard)
        cat > .gitignore << 'EOF'
# Standard Python .gitignore

# Byte-compiled / optimized / DLL files
__pycache__/
*.py[cod]
*$py.class
*.so

# Distribution / packaging
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
pip-wheel-metadata/
share/python-wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST

# Unit test / coverage reports
htmlcov/
.tox/
.nox/
.coverage
.coverage.*
.cache
nosetests.xml
coverage.xml
*.cover
*.py,cover
.hypothesis/
.pytest_cache/

# Environments
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/

# mypy
.mypy_cache/
.dmypy.json
dmypy.json

# Pyre type checker
.pyre/

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS files
.DS_Store
Thumbs.db
EOF
        ;;
    comprehensive)
        cat > .gitignore << 'EOF'
# Comprehensive Python .gitignore

# Byte-compiled / optimized / DLL files
__pycache__/
*.py[cod]
*.py[oc]
*.py[codz]
*$py.class
*.so

# Distribution / packaging
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
share/python-wheels/
pip-wheel-metadata/
*.egg-info/
.installed.cfg
*.egg
MANIFEST

# Type checkers
.mypy_cache/
.dmypy.json
dmypy.json
.pyre/
.pytype/

# Linters
.ruff_cache/

# Virtual Environments
.env
.env*
.env.local
.env*.local
.envrc
.venv
env/
venv/
venv*/
ENV/
env.bak/
venv.bak/
.direnv/

# IDEs and Editors
.idea/
.vscode/
*.swp
*.swo
*.suo

# Operating Systems
.DS_Store
.DS_Store?
**/.DS_Store
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Databases and Data Storage
*.sqlite
cache.db
*.cache

# Security and Authentication
*.pem
*.key
*.token
*.p12
*.pfx
oauth.json
*auth*.json

# Media and Assets
artifacts/
traces/
*.pkl
har/
EOF
        ;;
    ai-dev)
        cat > .gitignore << 'EOF'
# AI Development .gitignore

# Python Core
__pycache__/
*.py[cod]
*$py.class
*.so

# Distribution / packaging
build/
develop-eggs/
dist/
downloads/
*.egg-info/
.installed.cfg
*.egg

# Virtual environments
.env
.venv
env/
venv/
ENV/

# AI Development tools
.cursorrules
.cursorignore
.cursorindexingignore
.aider*
.repomap.tags.cache.v1/
**/.prompts/

# AI/ML specific
.abstra/
__marimo__/
marimo/_static/
marimo/_lsp/
.llm_cache/

# Testing and coverage
.pytest_cache/
.coverage
htmlcov/
.hypothesis/

# Type checkers and linters
.mypy_cache/
.ruff_cache/
.dmypy.json
dmypy.json

# Data and models
data/
/data/
models/
checkpoints/
*.pkl
*.joblib
*.h5
*.hdf5
*.parquet

# Logs and traces
*.log
logs/
artifacts/
traces/
har/

# Security
*.pem
*.key
*.token
oauth.json
*auth*.json

# IDEs
.vscode/
.idea/
*.swp
*.swo

# OS files
.DS_Store
Thumbs.db
EOF
        ;;
    web-dev)
        cat > .gitignore << 'EOF'
# Web Development .gitignore

# Python Core
__pycache__/
*.py[cod]
*$py.class
*.so

# Distribution / packaging
build/
develop-eggs/
dist/
downloads/
*.egg-info/
.installed.cfg
*.egg

# Virtual environments
.env
.env*
.env.local
.env*.local
.venv
env/
venv/
ENV/

# Web frameworks
# Django
*.log
local_settings.py
db.sqlite3
db.sqlite3-journal

# Flask
instance/
.webassets-cache

# JavaScript/Node.js (for full-stack projects)
node_modules/
.npm
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Build outputs
/build
dist
dist-ssr
*.local

# TypeScript
*.tsbuildinfo

# Next.js
/.next/
/out/

# Testing
/coverage

# Databases
*.sqlite
db.sqlite
cache.db

# Security
*.pem
*.key
*.token
oauth.json
*auth*.json

# Static files and uploads
uploads/
files/
temp/
workspace/

# IDEs
.vscode/
.idea/
*.swp
*.swo

# OS files
.DS_Store
Thumbs.db
EOF
        ;;
    data-science)
        cat > .gitignore << 'EOF'
# Data Science .gitignore

# Python Core
__pycache__/
*.py[cod]
*$py.class
*.so

# Distribution / packaging
build/
develop-eggs/
dist/
downloads/
*.egg-info/
.installed.cfg
*.egg

# Virtual environments
.env
.venv
env/
venv/
ENV/

# Data Science specific
# Jupyter
.ipynb_checkpoints
profile_default/
ipython_config.py

# Data files
data/
/data/
datasets/
*.csv
*.tsv
*.parquet
*.feather
*.h5
*.hdf5
*.pkl
*.pickle
*.joblib

# Model files
models/
checkpoints/
*.model
*.sav
*.bin

# Results and outputs
results/
outputs/
figures/
plots/
artifacts/

# Logs
*.log
logs/
mlruns/
wandb/

# Testing and coverage
.pytest_cache/
.coverage
htmlcov/
.hypothesis/

# Type checkers and linters
.mypy_cache/
.ruff_cache/

# ML frameworks
# TensorBoard
runs/
logs/

# MLflow
mlruns/
mlartifacts/

# Weights & Biases
wandb/

# DVC
.dvc/
.dvcignore

# Security
*.pem
*.key
*.token
oauth.json
*auth*.json

# IDEs
.vscode/
.idea/
*.swp
*.swo

# OS files
.DS_Store
Thumbs.db
EOF
        ;;
esac

success ".gitignore configured with $GITIGNORE_PROFILE profile"

# 3. Setup Claude Code hooks
log "Setting up Claude Code hooks..."
mkdir -p .claude

cat > .claude/settings.json << EOF
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "echo '🔍 Running pre-change quality checks...' && ruff format . && ruff check . --fix"
          }
        ]
      },
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "echo '⚡ About to run bash command, checking project state...'"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "echo '✅ Code modified, running post-change checks...' && mypy . --ignore-missing-imports || echo '⚠️ Type checking issues found'"
          }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "matcher": ".*",
        "hooks": [
          {
            "type": "command",
            "command": "if [ -d .git ] && ! git diff --quiet; then echo '📝 Creating commit before Claude Code changes...' && git add -A && git commit -m 'Save progress before Claude Code changes\n\n🤖 Generated with Claude Code\n\nCo-Authored-By: Claude <noreply@anthropic.com>' || true; fi"
          }
        ]
      }
    ],
    "Stop": [
      {
        "matcher": ".*",
        "hooks": [
          {
            "type": "command", 
            "command": "if [ -d .git ] && ! git diff --quiet; then echo '📝 Creating commit after Claude Code changes...' && git add -A && git commit -m 'Implement changes with Claude Code\n\n🤖 Generated with Claude Code\n\nCo-Authored-By: Claude <noreply@anthropic.com>' || true; fi"
          },
          {
            "type": "command",
            "command": "if [ -f CHANGELIST.md ]; then changelist_age=\$(($(date +%s) - \$(stat -f %m CHANGELIST.md 2>/dev/null || stat -c %Y CHANGELIST.md 2>/dev/null || echo 0))); if [ \$changelist_age -gt 1800 ]; then echo '💡 Consider updating CHANGELIST.md with recent changes'; fi; fi"
          }
        ]
      }
    ],
    "SessionStart": [
      {
        "matcher": ".*",
        "hooks": [
          {
            "type": "command",
            "command": "echo '🚀 Claude Code session started in $PROJECT_NAME' && echo '📋 Project uses $GITIGNORE_PROFILE gitignore profile' && if [ -f CLAUDE.md ]; then echo '📖 See CLAUDE.md for project-specific instructions'; fi"
          }
        ]
      }
    ]
  }
}
EOF

success "Claude Code hooks configured"

# 4. Setup pre-commit hooks
log "Setting up pre-commit hooks..."
backup_file ".pre-commit-config.yaml"

cat > .pre-commit-config.yaml << 'EOF'
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
      - id: check-case-conflict
      - id: check-merge-conflict

  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.1.15
    hooks:
      - id: ruff
        args: [--fix, --exit-non-zero-on-fix]
      - id: ruff-format

  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.8.0
    hooks:
      - id: mypy
        additional_dependencies: [types-all]
        args: [--strict, --ignore-missing-imports]
EOF

success "Pre-commit hooks configured"

# 5. Setup CLAUDE.md
log "Creating CLAUDE.md..."
backup_file "CLAUDE.md"

cat > CLAUDE.md << EOF
# Claude Code Project Instructions

## Project Overview
$PROJECT_DESCRIPTION

**Status**: Existing project enhanced with boilerplate configuration.

**Gitignore Profile**: This project uses the "$GITIGNORE_PROFILE" .gitignore profile, optimized for ${GITIGNORE_PROFILE//-/ } workflows.

## Changelog Maintenance
**IMPORTANT**: Update \`CHANGELIST.md\` with every significant change. This file tracks all project modifications and should be kept current. Add entries under "Unreleased" and move them to version sections when releasing.

## Development Commands

### Setup
\`\`\`bash
# Create virtual environment
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\\Scripts\\activate

# Install dependencies with uv
uv sync --dev
\`\`\`

### Code Quality
\`\`\`bash
# Format code
ruff format .

# Lint code
ruff check .

# Type check
mypy .

# Run all quality checks
ruff check . && ruff format . && mypy .
\`\`\`

### Testing
\`\`\`bash
# Run tests
pytest

# Run specific test
pytest tests/test_example.py::test_function
\`\`\`

### Dependencies
\`\`\`bash
# Add dependency
uv add package_name

# Add dev dependency
uv add --dev package_name

# Update dependencies
uv sync
\`\`\`

## Code Standards

- Use type hints for all functions and methods
- Follow PEP 8 style guide (enforced by ruff)
- Keep functions focused and single-purpose
- Use descriptive variable and function names
- Document public APIs with docstrings

## Before Committing

1. Update \`CHANGELIST.md\` with your changes
2. Run the full quality check suite:
\`\`\`bash
ruff check . && ruff format . && mypy . && pytest
\`\`\`

## Claude Code Hooks

This project includes Claude Code hooks configured in \`.claude/settings.json\` that provide:

### Automatic Quality Enforcement
- **PreToolUse**: Runs \`ruff format\` and \`ruff check --fix\` before Write/Edit operations
- **PostToolUse**: Runs \`mypy\` type checking after code modifications
- **Quality Gates**: Ensures code meets standards before and after changes

### Automatic Git Integration
- **UserPromptSubmit**: Creates commit before Claude Code starts working
- **Stop**: Creates commit after Claude Code completes changes
- **Professional Commit Messages**: Includes Claude Code attribution

### Session Management
- **SessionStart**: Shows project info and reminds about CLAUDE.md instructions
- **Changelog Reminders**: Prompts to update CHANGELIST.md when it's over 30 minutes old

### Hook Configuration
The hooks are defined in \`.claude/settings.json\` and run automatically when using Claude Code in this project directory. They provide deterministic control over the development workflow.

## Implementation Notes

This project was enhanced with boilerplate configuration including:
- Modern Python project configuration in pyproject.toml
- Comprehensive code quality tools (ruff, mypy, pre-commit)
- Claude Code hooks for automated workflow
- Professional .gitignore patterns
EOF

success "CLAUDE.md created"

# 6. Setup CHANGELIST.md
log "Creating CHANGELIST.md..."
backup_file "CHANGELIST.md"

cat > CHANGELIST.md << 'EOF'
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Applied Python boilerplate configuration
- Modern development tooling (ruff, mypy, pytest, pre-commit)
- Claude Code hooks for automated quality checks and git integration
- Comprehensive project documentation and standards

### Changed

### Deprecated

### Removed

### Fixed

### Security

---

## Instructions for Maintaining This Changelog

**For Claude Code users**: This changelog should be updated with every significant change to the project. When making changes:

1. Add new entries under the appropriate "Unreleased" section
2. Use these categories: Added, Changed, Deprecated, Removed, Fixed, Security
3. Write entries from the user's perspective
4. Include relevant context and reasoning for changes
5. When releasing a version, move "Unreleased" items to a new version section

**Entry Format Examples:**
- Added: New feature or capability
- Changed: Modification to existing functionality
- Deprecated: Features marked for removal
- Removed: Features that were removed
- Fixed: Bug fixes
- Security: Security improvements or fixes

**Version Release Process:**
When ready to release, create a new version section like:

```markdown
## [1.0.0] - 2024-01-15

### Added
- Feature descriptions here

### Changed
- Change descriptions here
```

Then reset the "Unreleased" section for future changes.
EOF

success "CHANGELIST.md created"

# 7. Setup .claudeignore
log "Creating .claudeignore..."
backup_file ".claudeignore"

cat > .claudeignore << 'EOF'
# Claude Code ignore file
# Ignore large data files and generated content

# Coverage reports
htmlcov/
.coverage
coverage.xml

# Cache and temp files
.pytest_cache/
.mypy_cache/
.ruff_cache/
__pycache__/

# Virtual environments
.venv/
venv/
env/

# IDE files
.vscode/
.idea/

# OS files
.DS_Store
Thumbs.db

# Large binary files
*.pkl
*.joblib
*.h5
*.hdf5
*.parquet

# Logs
*.log
EOF

success ".claudeignore created"

# 8. Setup MkDocs (if requested)
if [ "$INCLUDE_MKDOCS" = "yes" ]; then
    log "Setting up MkDocs..."
    
    cat > mkdocs.yml << EOF
site_name: $PROJECT_NAME
site_description: $PROJECT_DESCRIPTION
site_author: $AUTHOR_NAME

theme:
  name: material
  features:
    - navigation.tabs
    - navigation.sections
    - toc.integrate
    - navigation.top
    - search.suggest
    - search.highlight
    - content.tabs.link
    - content.code.annotation
    - content.code.copy
  language: en
  palette:
    - scheme: default
      toggle:
        icon: material/toggle-switch-off-outline
        name: Switch to dark mode
      primary: teal
      accent: purple
    - scheme: slate
      toggle:
        icon: material/toggle-switch
        name: Switch to light mode
      primary: teal
      accent: lime

nav:
  - Home: index.md
  - API Reference: reference/

plugins:
  - search
  - autorefs
  - mkdocstrings:
      handlers:
        python:
          paths: [src]
          options:
            docstring_style: google

markdown_extensions:
  - pymdownx.highlight:
      anchor_linenums: true
  - pymdownx.inlinehilite
  - pymdownx.snippets
  - admonition
  - pymdownx.arithmatex:
      generic: true
  - footnotes
  - pymdownx.details
  - pymdownx.superfences
  - pymdownx.mark
  - attr_list
  - pymdownx.emoji:
      emoji_index: !!python/name:material.extensions.emoji.twemoji
      emoji_generator: !!python/name:material.extensions.emoji.to_svg

extra:
  social:
    - icon: fontawesome/brands/github-alt
      link: https://github.com/$AUTHOR_NAME/$PACKAGE_NAME
EOF

    mkdir -p docs
    cat > docs/index.md << EOF
# $PROJECT_NAME

$PROJECT_DESCRIPTION

## Quick Start

\`\`\`python
import $PACKAGE_NAME

# Add your usage examples here
\`\`\`

## Installation

\`\`\`bash
pip install $PACKAGE_NAME
\`\`\`

## Features

- Feature 1
- Feature 2
- Feature 3

## API Reference

See the [API Reference](reference/) for detailed documentation of all modules and functions.
EOF

    cat > docs/reference.md << EOF
# API Reference

::: $PACKAGE_NAME
EOF

    success "MkDocs configured"
fi

# 9. Python version file
echo "$PYTHON_VERSION" > .python-version
success "Python version file created"

# Final summary
echo ""
echo "🎉 Boilerplate Configuration Applied Successfully!"
echo "=================================================="
echo ""
echo "📁 Files created/updated:"
echo "  - pyproject.toml (Python project configuration)"
echo "  - .gitignore ($GITIGNORE_PROFILE profile)"
echo "  - .claude/settings.json (Claude Code hooks)"
echo "  - .pre-commit-config.yaml (Pre-commit hooks)"
echo "  - CLAUDE.md (Project instructions)"
echo "  - CHANGELIST.md (Changelog)"
echo "  - .claudeignore (Claude Code ignore patterns)"
echo "  - .python-version (Python version)"

if [ "$INCLUDE_MKDOCS" = "yes" ]; then
    echo "  - mkdocs.yml (Documentation configuration)"
    echo "  - docs/ (Documentation directory)"
fi

if [ -d "$BACKUP_DIR" ]; then
    echo ""
    warning "Existing files backed up to: $BACKUP_DIR"
fi

echo ""
echo "🚀 Next Steps:"
echo "1. Review the generated configuration files"
echo "2. Install dependencies: uv sync --dev"
echo "3. Install pre-commit hooks: pre-commit install"
echo "4. Initialize git repository (if not already done): git init"
echo "5. Create initial commit: git add -A && git commit -m 'Apply boilerplate configuration'"
echo ""
echo "📖 See CLAUDE.md for detailed project instructions"
echo "📝 Update CHANGELIST.md with your future changes"
echo ""
echo "Happy coding! 🎯"
EOF