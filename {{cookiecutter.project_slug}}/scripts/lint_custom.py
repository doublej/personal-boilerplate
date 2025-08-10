#!/usr/bin/env -S uv run python3
"""Custom linting rules for {{ cookiecutter.project_name }}.

This script implements custom code quality checks beyond standard linters.
"""

import ast
import argparse
import sys
from pathlib import Path
from typing import List, Tuple, Optional


class CustomLinter:
    """Custom linter for project-specific rules."""
    
    def __init__(self, max_lines: int = {{ cookiecutter.max_lines_per_file }}):
        self.max_lines = max_lines
        self.errors: List[Tuple[str, int, str]] = []
        
    def check_file(self, file_path: Path) -> None:
        """Check a single Python file for custom rules."""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
                lines = content.splitlines()
            
            # Rule 1: Check max lines per file
            self._check_max_lines(file_path, lines)
            
            # Rule 2: Check for try/except blocks
            self._check_try_except_blocks(file_path, content)
            
        except Exception as e:
            self.errors.append((str(file_path), 0, f"Error reading file: {e}"))
    
    def _check_max_lines(self, file_path: Path, lines: List[str]) -> None:
        """Check if file exceeds maximum line count."""
        # Count non-empty, non-comment lines
        code_lines = [
            line for line in lines 
            if line.strip() and not line.strip().startswith('#')
        ]
        
        if len(code_lines) > self.max_lines:
            self.errors.append((
                str(file_path), 
                len(code_lines), 
                f"File has {len(code_lines)} code lines, exceeds limit of {self.max_lines}"
            ))
    
    def _check_try_except_blocks(self, file_path: Path, content: str) -> None:
        """Check for try/except blocks and warn about their usage."""
        try:
            tree = ast.parse(content)
            
            class TryExceptVisitor(ast.NodeVisitor):
                def __init__(self, file_path: Path, errors: List):
                    self.file_path = file_path
                    self.errors = errors
                
                def visit_Try(self, node):
                    # Check for bare except clauses
                    for handler in node.handlers:
                        if handler.type is None:
                            self.errors.append((
                                str(self.file_path),
                                handler.lineno,
                                "Bare 'except:' clause found. Consider catching specific exceptions."
                            ))
                        else:
                            # Warn about any try/except as per user's coding standards
                            exception_type = "specific exception" if handler.type else "all exceptions"
                            self.errors.append((
                                str(self.file_path),
                                node.lineno,
                                f"Try/except block found (catching {exception_type}). "
                                "Consider explicit error handling instead of try-catch blocks."
                            ))
                    
                    self.generic_visit(node)
            
            visitor = TryExceptVisitor(file_path, self.errors)
            visitor.visit(tree)
            
        except SyntaxError as e:
            self.errors.append((
                str(file_path), 
                e.lineno or 0, 
                f"Syntax error: {e.msg}"
            ))
    
    def lint_directory(self, directory: Path) -> None:
        """Recursively lint all Python files in directory."""
        python_files = directory.rglob("*.py")
        
        for file_path in python_files:
            # Skip virtual environments and cache directories
            if any(part in str(file_path) for part in ['.venv', 'venv', '__pycache__', '.tox', '.pytest_cache']):
                continue
            
            self.check_file(file_path)
    
    def report(self) -> int:
        """Print errors and return exit code."""
        if not self.errors:
            print("✅ All custom linting rules passed!")
            return 0
        
        print(f"❌ Found {len(self.errors)} custom linting issues:")
        print()
        
        for file_path, line_number, message in sorted(self.errors):
            if line_number > 0:
                print(f"{file_path}:{line_number}: {message}")
            else:
                print(f"{file_path}: {message}")
        
        print()
        print("Custom Linting Rules:")
        print(f"• Max lines per file: {self.max_lines}")
        print("• Try/except blocks should be avoided (prefer explicit error handling)")
        print()
        print("💡 Consider refactoring large files into smaller modules")
        print("💡 Replace try/except with explicit validation and error returns. Refer to CLAUDE.md rules")
        
        return 1


def main():
    """Main entry point for custom linter."""
    parser = argparse.ArgumentParser(description="Custom linter for {{ cookiecutter.project_name }}")
    parser.add_argument(
        "path", 
        nargs="?", 
        default=".", 
        help="Path to lint (default: current directory)"
    )
    parser.add_argument(
        "--max-lines", 
        type=int, 
        default={{ cookiecutter.max_lines_per_file }}, 
        help="Maximum lines per file (default: {{ cookiecutter.max_lines_per_file }})"
    )
    
    args = parser.parse_args()
    
    path = Path(args.path)
    if not path.exists():
        print(f"❌ Path does not exist: {path}")
        return 1
    
    linter = CustomLinter(max_lines=args.max_lines)
    
    if path.is_file():
        linter.check_file(path)
    else:
        linter.lint_directory(path)
    
    return linter.report()


if __name__ == "__main__":
    sys.exit(main())