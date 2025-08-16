#!/bin/bash
# Pre-compact handler for Claude Code hooks

set -e  # Exit on any error

echo "📦 Preparing context for compaction..."

# Optional: Create backup commit before context gets compacted
if [ -d .git ] && ! git diff --quiet; then
    echo "💾 Creating backup commit before context compaction..."
    git add -A
    git commit -m "wip: Backup before compaction

[wip]" || true
fi

# Optional: Clean up temporary files or optimize project state
echo "🧹 Cleaning up temporary files..."
find . -name "*.pyc" -delete 2>/dev/null || true
find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true

echo "✅ Pre-compact hook completed!"