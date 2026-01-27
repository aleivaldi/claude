#!/bin/bash
# Hook: Esegue lint su file appena scritto/modificato
# Eseguito su PostToolUse per Write

FILE_PATH="$1"

# Determina il tipo di file e il linter appropriato
case "$FILE_PATH" in
    *.ts|*.tsx|*.js|*.jsx)
        # TypeScript/JavaScript - usa eslint se disponibile
        if command -v npx &> /dev/null && [ -f "package.json" ]; then
            if grep -q "eslint" package.json 2>/dev/null; then
                npx eslint --fix "$FILE_PATH" 2>/dev/null
                if [ $? -ne 0 ]; then
                    echo "⚠️ ESLint found issues in $FILE_PATH"
                    # Non blocca, solo warning
                fi
            fi
        fi
        ;;
    *.dart)
        # Dart - usa dart format se disponibile
        if command -v dart &> /dev/null; then
            dart format "$FILE_PATH" 2>/dev/null
        fi
        ;;
    *.py)
        # Python - usa black/ruff se disponibile
        if command -v ruff &> /dev/null; then
            ruff check --fix "$FILE_PATH" 2>/dev/null
        elif command -v black &> /dev/null; then
            black "$FILE_PATH" 2>/dev/null
        fi
        ;;
    *.json)
        # JSON - valida sintassi
        if command -v jq &> /dev/null; then
            jq . "$FILE_PATH" > /dev/null 2>&1
            if [ $? -ne 0 ]; then
                echo "⚠️ Invalid JSON syntax in $FILE_PATH"
            fi
        fi
        ;;
    *.yaml|*.yml)
        # YAML - valida sintassi
        if command -v yamllint &> /dev/null; then
            yamllint "$FILE_PATH" 2>/dev/null
        fi
        ;;
esac

# Sempre permetti l'operazione (lint è solo advisory)
exit 0
