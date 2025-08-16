# Automated Git Workflow Guide

This project uses automatic commits to track changes during development sessions. Here's how to manage the git history effectively:

## Commit Strategy

**Automatic Feature Branch Workflow (Default):**
- When starting on `main`/`master`, automatically creates a feature branch named `feature/session-YYYYMMDD_HHMMSS`
- Creates commits on the feature branch to isolate development work
- Provides merge instructions at the end of each session

**Commit Types:**
- **WIP commits**: `WIP: Save progress before session`
- **Feature commits**: `feat: Implement changes`

## Managing Git History

### Option 1: Squash WIP Commits (Recommended)
```bash
# Before pushing to main/shared branch
git rebase -i HEAD~n  # n = number of commits to review

# In the interactive rebase:
# - Keep the first commit as 'pick'
# - Change WIP commits to 'squash' or 's'
# - Keep final feat commits as 'pick'
```

### Option 2: Automatic Feature Branch Workflow (Implemented)
**This is now the default behavior!**

```bash
# The hooks automatically:
# 1. Detect if you're on main/master
# 2. Create feature branch: feature/session-20241204_143022
# 3. Work on changes (all commits isolated on feature branch)
# 4. Provide merge instructions at session end

# To merge the changes:
git checkout main
git merge --squash feature/session-20241204_143022
git commit -m "feat: Implement feature"

# Clean up the feature branch:
git branch -d feature/session-20241204_143022
```

### Option 3: Rebase and Clean
```bash
# Interactive rebase to clean up history
git rebase -i HEAD~10

# Example rebase plan:
# pick abc123 feat: Initial implementation
# squash def456 WIP: Save progress before session  
# squash ghi789 feat: Implement changes
# pick jkl012 feat: Add tests and documentation
```

## Commit Message Patterns

**WIP Commits (auto-generated):**
```
WIP: Save progress before session

[wip]
```

**Feature Commits (auto-generated):**
```
feat: Implement changes
```

**Manual Commits (your commits):**
- Follow conventional commit format: `feat:`, `fix:`, `docs:`, etc.
- Update CHANGELIST.md with significant changes

## Best Practices

1. **Review before pushing:** Always review the commit history before pushing to shared branches
2. **Squash WIP commits:** Use interactive rebase to combine WIP commits with their related feat commits
3. **Keep meaningful commits:** Preserve commits that represent complete features or fixes
4. **Update changelog:** Manually update CHANGELIST.md for significant changes before final commits

## Quick Commands

```bash
# View recent commits with one-line format
git log --oneline -10

# Interactive rebase last 5 commits
git rebase -i HEAD~5

# Squash all commits since main branch
git rebase -i main

# Reset to specific commit (if needed)
git reset --soft HEAD~n
```

This workflow ensures you have a complete development history while maintaining a clean, publishable git history.