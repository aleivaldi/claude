#!/bin/bash
# Session Start Hook - Memory Persistence
# Carica contesto da sessioni precedenti

SESSIONS_DIR="$HOME/.claude/sessions"
SKILLS_DIR="$HOME/.claude/skills/learned"

# Crea directory se non esistono
mkdir -p "$SESSIONS_DIR"

# Cerca sessioni recenti (ultimi 7 giorni)
if [ -d "$SESSIONS_DIR" ]; then
    RECENT_COUNT=$(find "$SESSIONS_DIR" -name "*.md" -mtime -7 2>/dev/null | wc -l | tr -d ' ')
    if [ "$RECENT_COUNT" -gt 0 ]; then
        echo "Found $RECENT_COUNT recent session(s)" >&2
    fi
fi

# Carica project-config.yaml se esiste
if [ -f "project-config.yaml" ]; then
    echo "Loaded project-config.yaml" >&2
fi

# Carica progress.yaml se esiste
if [ -f "progress.yaml" ]; then
    echo "Loaded progress.yaml" >&2
fi

exit 0
