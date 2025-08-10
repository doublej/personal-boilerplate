#!/bin/bash
# Post-change quality checks for Claude Code hooks

set -e  # Exit on any error

echo "✅ Code modified, running post-change checks..."

# Run type checking (non-blocking for development)
echo "🔍 Running type checks..."
if mypy src/ --ignore-missing-imports; then
    echo "✅ Type checking passed"
else
    echo "⚠️  Type checking issues found (non-blocking)"
fi

echo "✅ Post-change checks completed!"