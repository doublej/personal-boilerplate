#!/bin/bash
# Session start information for Claude Code hooks

echo "🚀 Claude Code session started in {{ cookiecutter.project_name }}"
echo "📋 Project uses {{ cookiecutter.gitignore_profile }} gitignore profile"

if [ -f CLAUDE.md ]; then
    echo "📖 See CLAUDE.md for project-specific instructions"
fi