#!/bin/bash
# Post-Edit Check Hook
# Esegue controlli dopo modifica file TypeScript/JavaScript

FILE_PATH="$1"

# Exit se non è un file TS/JS
if [[ ! "$FILE_PATH" =~ \.(ts|tsx|js|jsx)$ ]]; then
    exit 0
fi

# Check per console.log (warning, non blocking)
if grep -n 'console\.log' "$FILE_PATH" 2>/dev/null; then
    echo "Warning: console.log found in $FILE_PATH" >&2
fi

# Check per debugger statement
if grep -n 'debugger' "$FILE_PATH" 2>/dev/null; then
    echo "Warning: debugger statement found in $FILE_PATH" >&2
fi

# Check per TODO con alta priorità
if grep -n 'TODO.*URGENT\|TODO.*CRITICAL\|FIXME' "$FILE_PATH" 2>/dev/null; then
    echo "Note: Critical TODO/FIXME found in $FILE_PATH" >&2
fi

exit 0
