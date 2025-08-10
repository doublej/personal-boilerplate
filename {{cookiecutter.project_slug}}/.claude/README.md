# Claude Code Configuration

This directory contains Claude Code automation and configuration for this project.

## Overview

This cookiecutter template includes a complete Claude Code integration that provides:

- **Automated Code Quality**: Format, lint, and type check on every change
- **Git Workflow Integration**: Automatic commits with proper attribution
- **File Protection**: Blocks edits to sensitive files
- **macOS Desktop Notifications**: Get notified when Claude needs input
- **Session Management**: Handles project initialization and cleanup

## File Structure

```
.claude/
├── settings.json        # Hook configuration
├── README.md           # This documentation
└── scripts/            # Automation scripts
    ├── pre_change_checks.sh    # Format & lint before changes
    ├── post_change_checks.sh   # Type check after changes
    ├── pre_session_commit.sh   # Create WIP commit before session
    ├── post_session_commit.sh  # Create final commit after session
    ├── session_start.sh        # Session initialization
    ├── subagent_stop.sh        # Subagent completion handler
    └── pre_compact.sh          # Context compaction preparation
```

## Hook Configuration

### PreToolUse Hooks

**File Protection**
- **Trigger**: Before Write/Edit/MultiEdit operations
- **Purpose**: Blocks edits to sensitive files (`.env`, `package-lock.json`, `.git/`)
- **Implementation**: Python inline check with exit code 2 to block operation

**Pre-Change Quality Checks**  
- **Trigger**: Before Write/Edit/MultiEdit operations
- **Script**: `pre_change_checks.sh`
- **Actions**:
  - `ruff format .` - Auto-format code
  - `ruff check . --fix` - Auto-fix linting issues
  - `uv run scripts/lint_custom.py` - Custom project rules

**Bash Command Notification**
- **Trigger**: Before Bash operations  
- **Purpose**: Notify about upcoming bash commands
- **Implementation**: Simple echo message

### PostToolUse Hooks

**Post-Change Type Checking**
- **Trigger**: After Write/Edit/MultiEdit operations
- **Script**: `post_change_checks.sh`
- **Actions**: `mypy src/` - Type checking

### Session Management Hooks

**UserPromptSubmit**: Pre-session commit creation
- **Script**: `pre_session_commit.sh`
- **Purpose**: Create WIP commit before Claude starts working

**Stop**: Post-session commit and guidance
- **Script**: `post_session_commit.sh`  
- **Purpose**: Create final commit and provide workflow guidance

**SessionStart**: Project initialization
- **Script**: `session_start.sh`
- **Purpose**: Display project info and setup reminders

**SubagentStop**: Subagent completion
- **Script**: `subagent_stop.sh`
- **Purpose**: Handle subagent work completion with optional commits

**PreCompact**: Context preparation
- **Script**: `pre_compact.sh`
- **Purpose**: Create backup and clean temporary files before context compaction

### Notification Hook

**Desktop Notifications** (macOS)
- **Trigger**: When Claude needs user input
- **Implementation**: `osascript` for native macOS notifications
- **Message**: "Awaiting your input" with "Claude Code" title

## Git Workflow Integration

### Commit Strategy
- **WIP Commits**: Marked with `[claude-code-wip]` for easy identification
- **Feature Commits**: Include proper attribution: `Co-Authored-By: Claude <noreply@anthropic.com>`
- **Automatic Branch Management**: Creates feature branches for isolation

### Commit Messages
All commits follow conventional format with Claude Code attribution:

```
feat: Implement changes via Claude Code

Detailed description of changes made.

Co-Authored-By: Claude <noreply@anthropic.com>
```

## Quality Standards Enforced

### Automatic Formatting & Linting
- **ruff format**: Consistent code style
- **ruff check --fix**: Auto-fix common issues
- **mypy**: Static type checking
- **Custom rules**: Max lines per file, try/except detection

### File Protection
Blocks edits to:
- `.env` files (environment secrets)
- `package-lock.json` (dependency lock files) 
- `.git/` directory (git internals)

### Custom Linting Rules
- **Max lines per file**: {{ cookiecutter.max_lines_per_file }} lines of code
- **Try/except detection**: Warns about exception handling blocks
- **Syntax validation**: Catches Python syntax errors

## Hook Script Details

### pre_change_checks.sh
```bash
# Runs before any Write/Edit operations
ruff format .                    # Format code
ruff check . --fix              # Fix linting issues  
uv run scripts/lint_custom.py   # Custom rules check
```

### post_change_checks.sh  
```bash
# Runs after any Write/Edit operations
mypy src/                       # Type checking
```

### pre_session_commit.sh
- Detects if on main/master branch
- Creates feature branch: `claude-code/session-YYYYMMDD_HHMMSS`
- Creates WIP commit if changes exist
- Provides branch workflow guidance

### post_session_commit.sh
- Creates final commit if changes exist
- Provides merge instructions for feature branches
- Reminds about git history cleanup
- Checks CHANGELIST.md freshness (30min threshold)

### session_start.sh
- Displays project information
- Shows current git status
- Reminds about CLAUDE.md instructions
- Provides development commands

### subagent_stop.sh
- Creates commit for subagent changes
- Includes proper Claude Code attribution
- Provides completion feedback

### pre_compact.sh  
- Creates backup commit before context compaction
- Cleans temporary files (*.pyc, __pycache__)
- Prepares project for context optimization

## Customization

### Adding New Hooks
Edit `settings.json` to add new hooks:

```json
{
  "hooks": {
    "HookName": [
      {
        "matcher": "pattern",
        "hooks": [
          {
            "type": "command",
            "command": "./.claude/scripts/your_script.sh"
          }
        ]
      }
    ]
  }
}
```

### Modifying Existing Scripts
All scripts are in `.claude/scripts/` and can be customized for project needs.

### Disabling Features
Remove or comment out specific hook configurations in `settings.json`.

## Integration with Project

### Shared Tools
- `scripts/lint_custom.py` - Used by both hooks and developers
- Quality standards apply to both automated and manual workflows

### Documentation References
- Project `CLAUDE.md` briefly references this configuration
- Project `README.md` focuses on actual project functionality
- This documentation provides complete Claude Code details

## Troubleshooting

### Hook Failures
- Check script permissions: `chmod +x .claude/scripts/*.sh`
- Verify script paths in `settings.json`
- Check script output for error messages

### Git Issues
- Ensure git repository is initialized
- Check file permissions and git configuration
- Review commit history with `git log --oneline`

### Quality Check Failures
- Run scripts manually: `./.claude/scripts/pre_change_checks.sh`
- Check tool installations: `ruff`, `mypy`, `uv`
- Review custom linting rules in `scripts/lint_custom.py`

This configuration provides a complete, professional development environment with Claude Code integration while maintaining clear separation from project functionality.