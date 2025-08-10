# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial project scaffolding with cookiecutter template
- Core project structure with src/{{ cookiecutter.package_name }} layout
- Development tooling setup (ruff, mypy, pytest, pre-commit)
- Basic test framework with placeholder test
{% if cookiecutter.include_mkdocs == "yes" -%}
- MkDocs documentation setup with Material theme
{% endif -%}
{% if cookiecutter.include_packaging == "yes" -%}
- Package distribution configuration in pyproject.toml
{% endif -%}

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