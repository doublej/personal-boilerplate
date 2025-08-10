#!/bin/bash
# Pre-change quality checks for Claude Code hooks

set -e  # Exit on any error

echo "🔍 Running pre-change quality checks..."

# Format code with ruff
echo "📝 Formatting code..."
ruff format .

# Fix linting issues automatically
echo "🔧 Auto-fixing linting issues..."
ruff check . --fix

# Run custom linting rules
echo "🎯 Running custom linting rules..."
uv run scripts/lint_custom.py

echo "✅ Pre-change checks completed successfully!"