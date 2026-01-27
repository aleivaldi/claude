#!/bin/bash
# Hook: Aggiorna progress.yaml quando un subagent completa
# Eseguito su SubagentStop

AGENT_NAME="$1"
AGENT_STATUS="$2"  # completed, failed, etc.
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Trova progress.yaml
PROGRESS_FILE="progress.yaml"
if [ ! -f "$PROGRESS_FILE" ]; then
    PROGRESS_FILE="./progress.yaml"
fi

if [ -f "$PROGRESS_FILE" ]; then
    # Aggiorna last_updated
    if command -v yq &> /dev/null; then
        yq -i ".last_updated = \"$TIMESTAMP\"" "$PROGRESS_FILE"
        yq -i ".last_agent = \"$AGENT_NAME\"" "$PROGRESS_FILE"
        yq -i ".last_status = \"$AGENT_STATUS\"" "$PROGRESS_FILE"
    fi
fi

# Output context per Claude
cat << EOF
{
  "hookSpecificOutput": {
    "additionalContext": "Agent $AGENT_NAME finished with status: $AGENT_STATUS"
  }
}
EOF

exit 0
