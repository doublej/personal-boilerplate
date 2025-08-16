#!/bin/bash
# Post-change quality checks for Claude Code hooks

set -e  # Exit on any error

echo "✅ Code modified, running post-change checks..."

# Define keyword warnings
declare -A KEYWORD_WARNINGS=(
    ["mock"]="The word 'mock' is found. Has the user explicitly asked for mockdata? If not, this is absolutely forbidden and needs to be removed or finished."
    ["TODO"]="TODO comment found. Consider creating a proper issue or completing the implementation."
    ["FIXME"]="FIXME comment found. This indicates broken code that needs immediate attention."
    ["HACK"]="HACK comment found. This indicates a workaround that should be properly implemented."
    ["XXX"]="XXX comment found. This indicates a problem or questionable code that needs review."
    ["TEMP"]="TEMP or temporary code found. This should be replaced with proper implementation."
    ["DEBUG"]="DEBUG code found. This should be removed before production."
    ["console.log"]="console.log found. Debug logging should be removed or replaced with proper logging."
    ["print("]="print() statement found. Consider using proper logging instead of print statements."
    ["debugger"]="Debugger statement found. This should be removed before committing."
)

# Check for keyword warnings in source code
echo "🔍 Checking for keyword warnings..."
warning_found=false

for keyword in "${!KEYWORD_WARNINGS[@]}"; do
    # Search in source files (case-insensitive for comments, case-sensitive for code)
    if grep -r -i --include="*.py" --include="*.js" --include="*.ts" --include="*.jsx" --include="*.tsx" --include="*.vue" --include="*.go" --include="*.rs" --include="*.java" --include="*.cpp" --include="*.c" --include="*.h" "$keyword" src/ 2>/dev/null; then
        echo "⚠️  KEYWORD WARNING: $keyword"
        echo "   ${KEYWORD_WARNINGS[$keyword]}"
        echo ""
        warning_found=true
    fi
done

if [ "$warning_found" = true ]; then
    echo "⚠️  Keyword warnings found in code. Please review and address before finalizing."
    echo ""
fi

# Run type checking (non-blocking for development)
echo "🔍 Running type checks..."
if mypy src/ --ignore-missing-imports; then
    echo "✅ Type checking passed"
else
    echo "⚠️  Type checking issues found (non-blocking)"
fi

echo "✅ Post-change checks completed!"