#!/bin/bash
# Pre-session commit for Claude Code hooks

set -e  # Exit on any error

# Only run if we have a git repository
if [ ! -d .git ]; then
    echo "ℹ️  No git repository found, skipping pre-session commit"
    exit 0
fi

# Get current branch
current_branch=$(git branch --show-current)

# Create feature branch if on main/master
if [[ "$current_branch" == "main" || "$current_branch" == "master" ]]; then
    timestamp=$(date +%Y%m%d_%H%M%S)
    feature_branch="claude-code/session-$timestamp"
    echo "🌿 Creating feature branch: $feature_branch"
    git checkout -b "$feature_branch" || true
fi

# Check if there are any changes to commit
if ! git diff --quiet || [ -n "$(git ls-files --others --exclude-standard)" ]; then
    echo "📝 Creating initial commit on feature branch..."
    git add -A
    git commit -m "WIP: Save progress before Claude Code session

[claude-code-wip]" || true
else
    echo "ℹ️  No changes to commit before session"
fi