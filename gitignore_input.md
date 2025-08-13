# Enhanced Master .gitignore

A comprehensive, categorized collection of .gitignore patterns for various development environments, languages, and tools.

## Programming Languages

### Python
#### Byte-compiled / optimized / DLL files
```
__pycache__/
*.py[cod]
*.py[oc]
*.py[codz]
*$py.class
*.so
```

#### Distribution / packaging
```
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
```

#### Python tools
```
# PyInstaller
*.manifest
*.spec

# Installer logs
pip-log.txt
pip-delete-this-directory.txt

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
*.py.cover
.hypothesis/
.pytest_cache/
cover/

# Translations
*.mo
*.pot

# Type checkers
.mypy_cache/
.dmypy.json
dmypy.json
.pyre/
.pytype/

# Linters
.ruff_cache/

# Cython debug symbols
cython_debug/
```

#### Python package managers
```
# pipenv
#Pipfile.lock

# UV
#uv.lock

# poetry
#poetry.lock
#poetry.toml

# pdm
#pdm.lock
#pdm.toml
.pdm.toml
.pdm-python
.pdm-build/

# pixi
#pixi.lock
.pixi

# PEP 582
__pypackages__/

# PyPI configuration
.pypirc
```

#### Python frameworks
```
# Django
*.log
local_settings.py
db.sqlite3
db.sqlite3-journal

# Flask
instance/
.webassets-cache

# Scrapy
.scrapy

# Sphinx documentation
docs/_build/
site/
/site

# PyBuilder
.pybuilder/
target/

# Jupyter
.ipynb_checkpoints
profile_default/
ipython_config.py

# Celery
celerybeat-schedule
celerybeat.pid

# SageMath
*.sage.py
```

### JavaScript/TypeScript
#### Dependencies and package managers
```
node_modules/
.npm
.pnp
.pnp.js
.yarn/install-state.gz
```

#### Logs
```
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.pnpm-debug.log*
pnpm-debug.log*
lerna-debug.log*
```

#### Build and distribution
```
/build
dist
dist-ssr
*.local
```

#### TypeScript specific
```
*.tsbuildinfo
next-env.d.ts
```

#### Framework specific
```
# Next.js
/.next/
/out/

# Testing
/coverage

# Vercel
.vercel
```

### Swift/iOS Development
```
.build/
DerivedData/
*.pbxuser
!default.pbxuser
*.mode1v3
!default.mode1v3
*.mode2v3
!default.mode2v3
*.perspectivev3
!default.perspectivev3
xcuserdata/
*.moved-aside
*.xccheckout
*.xcscmblueprint
*.hmap
*.ipa
*.dSYM.zip
*.dSYM
PythonBundle/
site-packages/
*.dylib
```

## Development Environments

### Virtual Environments
```
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
```

### IDEs and Editors
#### JetBrains
```
.idea/
.idea/*
```

#### Visual Studio Code
```
.vscode/
.vscode/*
!.vscode/extensions.json
```

#### Vim/Emacs/Other editors
```
*.swp
*.swo
*.suo
*.ntvs*
*.njsproj
*.sln
*.sw?
```

#### AI Development tools
```
.cursorrules
.cursorignore
.cursorindexingignore
.aider*
.repomap.tags.cache.v1/
**/.prompts/
```

## Operating Systems

### macOS
```
.DS_Store
.DS_Store?
**/.DS_Store
._*
.Spotlight-V100
.Trashes
```

### Windows
```
ehthumbs.db
Thumbs.db
```

## Databases and Data Storage

### SQL databases
```
*.sqlite
/prisma/db.sqlite
/prisma/db.sqlite-journal
db.sqlite
```

### NoSQL and cache
```
cache.db
*.cache
```

### Project data directories
```
data/
/data/
logs/
logs
postgres-data
files/
temp/
workspace/
uploads/
```

## Security and Authentication

### Keys and tokens
```
*.pem
*.key
*.token
*.p12
*.pfx
oauth.json
browser.json
*auth*.json
```

## Media and Assets

### Images and documents
```
*.png
*.txt
```

### Temporary media
```
videos/
artifacts/
traces/
*.pkl
har/
```

## Framework-specific

### Supabase
```
supabase/.branches
supabase/.temp
supabase/**/*.env
```

### Streamlit
```
**/secrets*.toml
```

### AI/ML specific
```
.abstra/
__marimo__/
marimo/_static/
marimo/_lsp/
.llm_cache/
```

## Version Control Tools

### Tags and caches
```
tags
tags.lock
tags.temp
tags.temp.tmp
```

## Additional Resources

- For language-specific .gitignore templates: [github.com/github/gitignore](https://github.com/github/gitignore)
- For generating custom .gitignore files: [gitignore.io](https://www.gitignore.io/)

## Notes

- Commented lines (preceded by #) are optional patterns that you may want to uncomment based on your project's needs
- Some patterns may overlap between categories
- Adjust patterns based on your specific project requirements