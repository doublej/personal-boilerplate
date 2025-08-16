#!/bin/bash
# Post-session commit and workflow guidance for Claude Code hooks

set -e  # Exit on any error

# Only run if we have a git repository
if [ ! -d .git ]; then
    echo "ℹ️  No git repository found, skipping post-session commit"
    exit 0
fi

# Create final commit if there are changes
if ! git diff --quiet || [ -n "$(git ls-files --others --exclude-standard)" ]; then
    echo "📝 Creating final commit after changes..."
    git add -A
    git commit -m "feat: Implement changes" || true
fi

# Provide workflow guidance based on current branch
current_branch=$(git branch --show-current)
if [[ "$current_branch" == feature/* ]]; then
    echo "🔀 Feature branch workflow active on: $current_branch"
    echo "💡 To merge: git checkout main && git merge --squash $current_branch && git commit"
    echo "🗑️  To cleanup: git branch -d $current_branch"
else
    echo "🧹 Tip: Use \"git rebase -i HEAD~n\" to squash WIP commits before pushing"
fi

# Check changelog reminder
if [ -f CHANGELIST.md ]; then
    # Get last modification time of CHANGELIST.md
    if command -v stat >/dev/null 2>&1; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            changelist_mtime=$(stat -f %m CHANGELIST.md 2>/dev/null || echo 0)
        else
            # Linux
            changelist_mtime=$(stat -c %Y CHANGELIST.md 2>/dev/null || echo 0)
        fi
        current_time=$(date +%s)
        
        # If CHANGELIST.md is older than 30 minutes (1800 seconds)
        if [ $((current_time - changelist_mtime)) -gt 1800 ]; then
            echo "💡 Consider updating CHANGELIST.md with recent changes"
        fi
    fi
fi