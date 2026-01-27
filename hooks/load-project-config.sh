#!/bin/bash
# Hook: Carica configurazione progetto all'inizio della sessione
# Eseguito su SessionStart

# Cerca project-config.yaml nella directory corrente o parent
find_config() {
    local dir="$PWD"
    while [ "$dir" != "/" ]; do
        if [ -f "$dir/project-config.yaml" ]; then
            echo "$dir/project-config.yaml"
            return 0
        fi
        dir=$(dirname "$dir")
    done
    return 1
}

CONFIG_PATH=$(find_config)

if [ -n "$CONFIG_PATH" ]; then
    # Estrai informazioni base dal config
    PROJECT_NAME=$(grep -E "^\s*name:" "$CONFIG_PATH" | head -1 | sed 's/.*name:\s*"\?\([^"]*\)"\?/\1/')
    PROJECT_PHASE=$(grep -E "^\s*phase:" "$CONFIG_PATH" | head -1 | sed 's/.*phase:\s*"\?\([^"]*\)"\?/\1/')

    # Output JSON per Claude
    cat << EOF
{
  "hookSpecificOutput": {
    "additionalContext": "Project: $PROJECT_NAME, Phase: $PROJECT_PHASE. Config at: $CONFIG_PATH"
  }
}
EOF
else
    # Nessun config trovato
    cat << EOF
{
  "hookSpecificOutput": {
    "additionalContext": "No project-config.yaml found. Run /project-setup to create one."
  }
}
EOF
fi

exit 0
