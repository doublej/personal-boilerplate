# Test Project

A brief description of your project

## Installation

```bash
# Clone the repository
git clone https://github.com/Test Author/test_project.git
cd test_project

# Create virtual environment
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# Install with uv
uv sync --dev
```

## Usage

```python
from test_project import core

# Add your usage examples here
```

## Development

### Setup Development Environment

```bash
# Install pre-commit hooks
pre-commit install

# Run quality checks
ruff check . && ruff format . && mypy src/

# Run tests
pytest
```

### Project Structure

```
src/test_project/
├── core/           # Core functionality
├── utils/          # Utility functions
└── models/         # Data models

tests/              # Test files
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run quality checks: `ruff check . && ruff format . && mypy src/ && pytest`
5. Commit your changes
6. Push to your fork
7. Create a pull request

## License

This project is licensed under the MIT License.
