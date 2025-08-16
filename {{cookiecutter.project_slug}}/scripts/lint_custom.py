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
        # Check if file is readable
        if not file_path.is_file() or not file_path.suffix == '.py':
            self.errors.append((str(file_path), 0, "File is not a readable Python file"))
            return
            
        # Read file content
        content = self._read_file_safely(file_path)
        if content is None:
            return  # Error already recorded
            
        lines = content.splitlines()
        
        # Rule 1: Check max lines per file
        self._check_max_lines(file_path, lines)
        
        # Rule 2: Check for try/except blocks
        self._check_try_except_blocks(file_path, content)
    
    def _read_file_safely(self, file_path: Path) -> Optional[str]:
        """Safely read file content with explicit error handling."""
        if not file_path.exists():
            self.errors.append((str(file_path), 0, "File does not exist"))
            return None
            
        if not file_path.is_file():
            self.errors.append((str(file_path), 0, "Path is not a file"))
            return None
            
        # Check file permissions
        if not file_path.stat().st_mode & 0o444:  # Check read permission
            self.errors.append((str(file_path), 0, "File is not readable"))
            return None
            
        # Read file with explicit encoding
        content_bytes = file_path.read_bytes()
        
        # Attempt UTF-8 decoding
        decoded_content = content_bytes.decode('utf-8', errors='replace')
        if '\ufffd' in decoded_content:  # Check for replacement characters
            self.errors.append((str(file_path), 0, "File contains invalid UTF-8 characters"))
            return None
            
        return decoded_content
    
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
        # Skip linting scripts themselves to avoid circular violations
        if 'lint_custom.py' in str(file_path) or '.claude/scripts/' in str(file_path):
            return
            
        # Parse AST with explicit error handling
        parsed_tree = self._parse_ast_safely(file_path, content)
        if parsed_tree is None:
            return  # Error already recorded
            
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
        visitor.visit(parsed_tree)
    
    def _parse_ast_safely(self, file_path: Path, content: str) -> Optional[ast.AST]:
        """Safely parse Python AST with explicit error handling."""
        # Basic content validation
        if not content.strip():
            return ast.parse('')  # Empty content is valid Python
            
        # Check for obvious syntax issues before parsing
        if content.count('(') != content.count(')'):
            self.errors.append((str(file_path), 0, "Unmatched parentheses detected"))
            return None
            
        if content.count('[') != content.count(']'):
            self.errors.append((str(file_path), 0, "Unmatched brackets detected"))
            return None
            
        if content.count('{') != content.count('}'):
            self.errors.append((str(file_path), 0, "Unmatched braces detected"))
            return None
            
        # Attempt to parse AST
        parsed_ast = self._attempt_ast_parse(content)
        if parsed_ast is None:
            self.errors.append((str(file_path), 0, "Failed to parse Python syntax"))
            return None
            
        return parsed_ast
    
    def _attempt_ast_parse(self, content: str) -> Optional[ast.AST]:
        """Attempt AST parsing with comprehensive validation."""
        # Validate content is not empty or whitespace-only
        if not content or not content.strip():
            return ast.parse('')
            
        # Check for null bytes which can cause parsing issues
        if '\x00' in content:
            return None
            
        # Validate encoding by checking for non-printable characters
        printable_chars = set('\t\n\r')
        printable_chars.update(chr(i) for i in range(32, 127))  # Standard ASCII printable
        printable_chars.update(chr(i) for i in range(128, 256))  # Extended ASCII
        
        if not all(c in printable_chars or ord(c) > 255 for c in content):
            return None
            
        # Check for basic Python syntax patterns
        lines = content.splitlines()
        for i, line in enumerate(lines, 1):
            stripped = line.strip()
            if stripped and not self._is_valid_python_line(stripped):
                return None
                
        # Final AST parse attempt
        return self._final_ast_parse(content)
    
    def _is_valid_python_line(self, line: str) -> bool:
        """Basic validation for Python line syntax."""
        # Skip comments and docstrings
        if line.startswith('#') or line.startswith('"""') or line.startswith("'''"):
            return True
            
        # Check for obviously invalid patterns
        invalid_patterns = ['\t ', '    \t']  # Mixed tabs and spaces
        return not any(pattern in line for pattern in invalid_patterns)
    
    def _final_ast_parse(self, content: str) -> Optional[ast.AST]:
        """Final AST parsing with comprehensive error detection."""
        # Pre-validate string quotes are balanced
        single_quotes = content.count("'") - content.count("\\'")
        double_quotes = content.count('"') - content.count('\\"')
        
        if single_quotes % 2 != 0 or double_quotes % 2 != 0:
            return None
            
        # Check indentation consistency
        lines = content.splitlines()
        tab_count = sum(1 for line in lines if line.startswith('\t'))
        space_count = sum(1 for line in lines if line.startswith('    '))
        
        # Reject mixed indentation
        if tab_count > 0 and space_count > 0:
            return None
            
        # Attempt final parse
        # This will raise SyntaxError for invalid Python
        ast_result = ast.parse(content, mode='exec')
        return ast_result if ast_result else None
    
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