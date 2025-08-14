# {{ cookiecutter.project_name }}

{{ cookiecutter.project_description }}

> **Note**: This is a newly scaffolded project created from a cookiecutter template. Core functionality is yet to be implemented.

## Installation

```bash
# Clone the repository
git clone https://github.com/{{ cookiecutter.author_name }}/{{ cookiecutter.project_slug }}.git
cd {{ cookiecutter.project_slug }}

# Create virtual environment
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# Install with uv
uv sync --dev
```

## Usage

```python
from {{ cookiecutter.package_name }} import core

# Add your usage examples here once core functionality is implemented
```

## Development

```bash
# Setup
uv sync --dev

# Run tests
pytest

# Quality checks (automated with Claude Code)
ruff format . && ruff check . && mypy src/
```

{% if cookiecutter.include_docker == "yes" -%}
## Docker

```bash
# Build image
docker build -t {{ cookiecutter.project_slug }} .

# Run container
docker run -p {{ cookiecutter.docker_port }}:{{ cookiecutter.docker_port }} {{ cookiecutter.project_slug }}

# Development with volume mount
docker run -p {{ cookiecutter.docker_port }}:{{ cookiecutter.docker_port }} -v $(pwd):/app {{ cookiecutter.project_slug }}
```
{% endif %}

## Contributing

1. Fork the repository
2. Create a feature branch  
3. Make your changes
4. Run tests and quality checks
5. Update `CHANGELIST.md`
6. Submit pull request

**Note**: This project includes Claude Code integration for automated quality checks and git workflow. See `CLAUDE.md` for developer instructions.

{% if cookiecutter.license != "None" -%}
## License

This project is licensed under the {{ cookiecutter.license }} License.
{% endif -%}