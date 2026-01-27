#!/bin/bash
# Hook: Verifica che il commit message segua Conventional Commits
# Exit 0 = allow, Exit 2 = block

# Estrai il messaggio di commit dall'input
COMMIT_MSG="$1"

# Pattern per conventional commits
# type(scope): description
# type: description
PATTERN='^(feat|fix|refactor|docs|test|chore|style|perf|ci|build|revert)(\([a-zA-Z0-9_-]+\))?: .{1,72}$'

# Controlla se il messaggio inizia con il pattern
FIRST_LINE=$(echo "$COMMIT_MSG" | head -n1)

if [[ ! "$FIRST_LINE" =~ $PATTERN ]]; then
    echo "❌ Commit message does not follow Conventional Commits format"
    echo ""
    echo "Expected format: <type>(<scope>): <description>"
    echo ""
    echo "Types: feat, fix, refactor, docs, test, chore, style, perf, ci, build, revert"
    echo ""
    echo "Examples:"
    echo "  feat(auth): add login endpoint"
    echo "  fix(api): handle null response"
    echo "  chore(deps): update dependencies"
    echo ""
    echo "Your message: $FIRST_LINE"
    exit 2
fi

# Verifica lunghezza (max 72 caratteri per la prima linea)
if [ ${#FIRST_LINE} -gt 72 ]; then
    echo "⚠️ First line exceeds 72 characters (${#FIRST_LINE} chars)"
    echo "Consider shortening the commit message"
    # Warning, non blocca
    exit 0
fi

echo "✓ Commit message format OK"
exit 0
