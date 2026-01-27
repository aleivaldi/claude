#!/bin/bash
# Session End Hook - Memory Persistence
# Salva log sessione strutturato

SESSIONS_DIR="$HOME/.claude/sessions"
mkdir -p "$SESSIONS_DIR"

DATE=$(date +%Y-%m-%d)
TIMESTAMP=$(date +%H:%M:%S)
FILE="$SESSIONS_DIR/$DATE-session.md"

# Se file esiste, aggiorna timestamp
if [ -f "$FILE" ]; then
    # Usa sed compatibile con macOS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/Last Updated:.*/Last Updated: $DATE $TIMESTAMP/" "$FILE"
    else
        sed -i "s/Last Updated:.*/Last Updated: $DATE $TIMESTAMP/" "$FILE"
    fi
else
    # Crea nuovo file sessione
    cat > "$FILE" << EOF
# Session Log - $DATE

## Metadata
- Created: $DATE $TIMESTAMP
- Last Updated: $DATE $TIMESTAMP

## Context
<!-- Current project context -->

## Tasks Completed
<!-- List of completed tasks -->

## Work in Progress
<!-- Ongoing work -->

## Notes
<!-- Important observations -->

## Files Modified
<!-- Key files changed -->
EOF
fi

exit 0
