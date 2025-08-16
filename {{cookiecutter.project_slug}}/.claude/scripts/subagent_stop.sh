#!/bin/bash
# Subagent stop handler for Claude Code hooks

set -e  # Exit on any error

echo "🤖 Subagent completed work..."

# Optional: Create commit if there are changes from subagent work
if [ -d .git ] && ! git diff --quiet; then
    echo "📝 Creating commit for subagent changes..."
    git add -A
    git commit -m "feat: Complete task" || true
fi

echo "✅ Subagent stop hook completed!"