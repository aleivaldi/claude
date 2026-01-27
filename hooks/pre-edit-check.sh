#!/bin/bash
# Hook: Controlli pre-modifica file
# Eseguito su PreToolUse per Edit

FILE_PATH="$1"

# Verifica che non stiamo modificando file sensibili
SENSITIVE_PATTERNS=(
    ".env$"
    ".env.production$"
    "credentials"
    "secrets"
    "\.pem$"
    "\.key$"
    "id_rsa"
)

for pattern in "${SENSITIVE_PATTERNS[@]}"; do
    if [[ "$FILE_PATH" =~ $pattern ]]; then
        echo "⚠️ Warning: Modifying potentially sensitive file: $FILE_PATH"
        # Non blocca, ma avvisa
        cat << EOF
{
  "hookSpecificOutput": {
    "additionalContext": "CAUTION: Editing sensitive file $FILE_PATH. Ensure no secrets are exposed."
  }
}
EOF
        break
    fi
done

# Verifica che il file non sia troppo grande
if [ -f "$FILE_PATH" ]; then
    LINES=$(wc -l < "$FILE_PATH")
    if [ "$LINES" -gt 1000 ]; then
        echo "⚠️ Large file: $FILE_PATH has $LINES lines"
        cat << EOF
{
  "hookSpecificOutput": {
    "additionalContext": "Large file with $LINES lines. Consider if full file read is necessary."
  }
}
EOF
    fi
fi

# Sempre permetti (solo advisory)
exit 0
