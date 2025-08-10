{% if cookiecutter.include_mkdocs == "yes" -%}
# {{ cookiecutter.project_name }}

{{ cookiecutter.project_description }}

## Quick Start

```python
from {{ cookiecutter.package_name }} import core

# Add your usage examples here
```

## Installation

```bash
pip install {{ cookiecutter.package_name }}
```

## Features

- Feature 1
- Feature 2
- Feature 3

## API Reference

See the [API Reference](reference/) for detailed documentation of all modules and functions.
{% endif %}