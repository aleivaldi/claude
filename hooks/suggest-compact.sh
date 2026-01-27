#!/bin/bash
# Strategic Compact Suggestion Hook
# Suggerisce compaction dopo N tool calls

COUNTER_FILE="/tmp/claude-tool-count-$$"

# Leggi counter corrente o inizializza
COUNT=$(cat "$COUNTER_FILE" 2>/dev/null || echo 0)
COUNT=$((COUNT + 1))
echo $COUNT > "$COUNTER_FILE"

# Suggerisci compaction a intervalli
if [ $COUNT -eq 50 ]; then
    echo "Tip: 50 tool calls reached. Consider /compact at next milestone." >&2
elif [ $COUNT -gt 50 ] && [ $((COUNT % 25)) -eq 0 ]; then
    echo "Tip: $COUNT tool calls. Reminder: /compact helps reduce context." >&2
fi

exit 0
