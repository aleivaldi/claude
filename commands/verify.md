# /verify - Complete Verification Suite

## Overview

Suite di verifiche automatiche per validare lo stato del codice prima di commit, PR, o deploy.

## Syntax

```bash
/verify              # Verifica completa (6 checks)
/verify quick        # Solo build + types
/verify pre-commit   # Checks per commit
/verify pre-pr       # Extended + security audit
```

## Modes

### Default (Full)
Esegue tutti i 6 check in sequenza.

### Quick
Solo build e type checking per feedback veloce.

### Pre-commit
Build, types, lint, test unitari.

### Pre-PR
Tutto + security audit + coverage check.

## Workflow Process

### 1. Build Validation
```bash
npm run build
# Verifica che il progetto compili senza errori
```

### 2. Type Safety
```bash
npm run typecheck   # o tsc --noEmit
# Verifica type errors TypeScript
```

### 3. Code Quality
```bash
npm run lint
# Verifica ESLint/linting rules
```

### 4. Test Execution
```bash
npm run test
# Esegue unit tests
```

### 5. Code Audit
```bash
# Cerca pattern problematici:
# - console.log (non rimossi)
# - debugger statements
# - TODO/FIXME critici
# - Secrets hardcoded
```

### 6. Git Status
```bash
git status
# Mostra file modificati non committati
```

## Output Format

```
╔══════════════════════════════════════════════════════════════╗
║                     VERIFY RESULTS                            ║
╠══════════════════════════════════════════════════════════════╣
║ ✅ Build         │ Passed                                    ║
║ ✅ TypeScript    │ No errors                                 ║
║ ⚠️  Lint         │ 2 warnings                                ║
║ ✅ Tests         │ 42 passed                                 ║
║ ⚠️  Audit        │ 3 console.log found                       ║
║ ✅ Git           │ Clean working tree                        ║
╠══════════════════════════════════════════════════════════════╣
║ Overall: PASSED with warnings                                 ║
╚══════════════════════════════════════════════════════════════╝
```

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | All checks passed |
| 1 | Build failed |
| 2 | Type errors |
| 3 | Lint errors (not warnings) |
| 4 | Tests failed |
| 5 | Security issues found |

## Key Principles

1. **Fail fast**: Primo errore blocca esecuzione
2. **Clear output**: Ogni check riporta stato
3. **Actionable**: Suggerimenti per fix
4. **CI-ready**: Exit codes per automation

## Integration

Usare prima di:
- `git commit`
- `git push`
- PR creation
- Deploy

Combina con:
- `/commit` - dopo verify passed
- `/build-fix` - se build fails
- `/tdd` - se tests fail

## Configuration

Il comando rileva automaticamente i comandi disponibili da `package.json`:

```json
{
  "scripts": {
    "build": "...",
    "typecheck": "tsc --noEmit",
    "lint": "eslint .",
    "test": "vitest"
  }
}
```

## When to Apply

- Prima di ogni commit significativo
- Prima di aprire PR
- Prima di merge su main
- Dopo refactoring esteso
- Prima di deploy
