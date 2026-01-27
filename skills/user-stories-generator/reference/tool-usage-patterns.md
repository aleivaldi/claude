# Tool Usage Patterns (⚠️ CRITICO)

## Pattern Principale: File-Based Workflow

- **Fase 1**: Read(brief) → Write(structure.md) → ATTENDI conferma
- **Fase 2**: Read(structure.md) → AskUserQuestion(granularità)
- **Fase 3**: Write(list.md) → ATTENDI conferma
- **Fase 4**: Read(list.md) → Edit(list.md con edge cases) → ATTENDI conferma
- **Fase 5**: Read(list.md) → Write(draft.md) → ATTENDI conferma
- **Fase 6**: Read(draft.md) → AskUserQuestion(strategia output)
- **Fase 7**: Read(draft.md) → Write(output finali)

## Regole Tool

- **Write**: File NUOVI (structure, list, draft, output finale)
- **Edit**: File ESISTENTI (solo list.md con edge cases)
- **Read**: SEMPRE prima di processare file intermedi (utente potrebbe averli modificati)
- **AskUserQuestion**: Decisioni critiche (granularità, edge cases, output strategy)

## Gestione Path Brief

**Se utente non specifica path**:
```
1. Glob("brief-structured.md") → cerca in directory corrente
2. Se non trovato: Glob("brief.md")
3. Se ancora non trovato: AskUserQuestion per path manuale
```

## Tool da NON usare

- ❌ **NO Bash** per leggere/scrivere file (usa Read/Write)
- ❌ **NO Edit** su file non esistenti (usa Write)
- ❌ **NO assunzioni** su preferenze utente (usa AskUserQuestion)
