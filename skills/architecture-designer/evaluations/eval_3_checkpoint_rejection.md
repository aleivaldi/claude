# Evaluation 3: Checkpoint Rejection and Iteration

## Scenario
Utente rifiuta tech stack proposto, richiede modifiche.

## Input
- Sitemap: Standard web app
- Brief: MVP < 1000 utenti

### Invocazione
```
/architecture-designer
```

## Expected Behavior

### Fasi 1-2
- ✅ Analisi e Overview normalmente
- ✅ CHECKPOINT: ARCHITECTURE_OVERVIEW → Approvato

### Fase 3: Tech Stack (Primo Tentativo)

#### Proposta Iniziale
```markdown
## Backend
- Runtime: Node.js 20
- Framework: Express
- ORM: Prisma
```

#### Checkpoint Presentation
```
>>> CHECKPOINT: TECH_STACK_CHOICE <<<

Scelte Principali:
- Backend: Node.js + Express
- Database: PostgreSQL

Approvi questo tech stack?
```

#### User Response (via AskUserQuestion)
```
MODIFICA: "Preferisco Python + FastAPI per backend invece di Node.js"
```

#### Expected Behavior dopo MODIFICA
- ✅ Leggi `tech-stack-draft.md` (utente potrebbe averlo modificato)
- ✅ Se utente NON ha modificato file:
  - Chiedi: "Devo modificare io o vuoi modificare tu il file?"

- ✅ Se "Modifica tu":
  - Edit `tech-stack-draft.md`:
    ```markdown
    ## Backend
    - Runtime: Python 3.11
    - Framework: FastAPI
    - ORM: SQLAlchemy
    ```
  - Aggiorna motivazioni per riflettere cambio

- ✅ Re-presenta checkpoint:
  ```
  >>> CHECKPOINT: TECH_STACK_CHOICE (AGGIORNATO) <<<

  Modifiche applicate:
  - Backend: Python + FastAPI (invece di Node.js)

  Scelte Principali:
  - Backend: Python + FastAPI
  - Database: PostgreSQL

  Approvi questo tech stack aggiornato?
  ```

#### User Response (Secondo Tentativo)
```
APPROVA
```

- ✅ Procede a Fase 4 con tech stack approvato

### Fasi 4-6
- ✅ Continuano normalmente con Python nel tech stack

## Expected Output

### tech-stack.md Final
```markdown
## Backend

| Layer | Tecnologia | Motivazione |
|-------|------------|-------------|
| Runtime | Python 3.11 | Preferenza utente, ecosistema data science |
| Framework | FastAPI | Async, type hints, auto docs |
| ORM | SQLAlchemy | ORM maturo Python |
```

### Chat Interaction Log
```
[Fase 3]
Proposta tech stack: Node.js + Express

>>> CHECKPOINT: TECH_STACK_CHOICE <<<
Approvi?

User: Modifica - Preferisco Python

Devo modificare io il file o vuoi modificarlo tu?

User: Modifica tu

Modifico tech-stack-draft.md...
Applicato: Node.js → Python, Express → FastAPI

>>> CHECKPOINT: TECH_STACK_CHOICE (AGGIORNATO) <<<
Approvi?

User: Approva

Procedo a Fase 4...
```

## Success Criteria

- ✅ Checkpoint re-presentato dopo modifica
- ✅ File modificato correttamente (Python invece Node.js)
- ✅ Motivazioni aggiornate per riflettere cambio
- ✅ NON procede a Fase 4 finché checkpoint approvato
- ✅ Loop modifica → checkpoint fino ad approvazione

## Edge Cases

### Scenario 2: Multiple Iterations

**Setup**: Utente modifica 3 volte

**Expected**:
```
Checkpoint 1: MODIFICA (cambio backend)
Checkpoint 2: MODIFICA (cambio database)
Checkpoint 3: APPROVA

Loop 1 → 2 → 3 gestito correttamente
```

### Scenario 3: Rejection Totale

**Setup**: Utente risponde "RIFIUTA"

**Expected**:
```
>>> CHECKPOINT: TECH_STACK_CHOICE <<<
Approvi?

User: Rifiuta - Ricomincia da zero

Checkpoint rifiutato.

Cosa vuoi modificare?
- Tutto (ricomincio Fase 3)
- Solo alcune scelte (specifica quali)
- Annulla skill (STOP)

[Attendi input utente e agisci di conseguenza]
```

## Pass/Fail Criteria

**PASS se**:
- Loop modifica → checkpoint funziona
- File aggiornato correttamente
- NON procede senza approvazione
- Gestisce rejection totale

**FAIL se**:
- Procede a Fase 4 senza approvazione
- File non modificato dopo richiesta modifica
- Modifica sovrascrive modifiche utente al file
- Loop infinito senza exit condition
