# Parallelization Logic: Dettagli

## Logica Parallelizzazione Condizionale

```
┌─────────────────────────────────────────────────────────────────────┐
│                    PARALLELIZZAZIONE CONDIZIONALE                    │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  1. VERIFICA CONDIZIONI                                             │
│     │                                                                │
│     ├─► API signature esiste?                                       │
│     │   ├─► SI: Backend e Frontend possono procedere in parallelo   │
│     │   └─► NO: Solo Backend, Frontend aspetta                      │
│     │                                                                │
│     ├─► Shared types/contracts definiti?                            │
│     │   ├─► SI: Parallelo OK                                        │
│     │   └─► NO: Prima genera types, poi parallelo                   │
│     │                                                                │
│     └─► Dipendenze dirette?                                         │
│         ├─► FE chiama BE: Sequenziale (BE → FE)                     │
│         └─► Indipendenti: Parallelo                                 │
│                                                                      │
│  2. ESECUZIONE                                                       │
│     │                                                                │
│     ├─► [PARALLELO] Se condizioni OK:                               │
│     │   │                                                            │
│     │   │   Task(backend-implementer)  ──┬──  Task(frontend-impl)   │
│     │   │              │                 │           │               │
│     │   │              ▼                 ▼           ▼               │
│     │   │         BE done           SYNC POINT    FE done            │
│     │   │                                                            │
│     │   └─► Entrambi completati → Procedi a Tests                   │
│     │                                                                │
│     └─► [SEQUENZIALE] Se dipendenze:                                │
│         │                                                            │
│         │   Task(backend-implementer)                                │
│         │              │                                             │
│         │              ▼                                             │
│         │         BE done                                            │
│         │              │                                             │
│         │              ▼                                             │
│         │   Task(frontend-implementer)                               │
│         │              │                                             │
│         │              ▼                                             │
│         │         FE done                                            │
│         │                                                            │
│         └─► Procedi a Tests                                          │
│                                                                      │
│  3. SEMPRE SEQUENZIALE                                              │
│     │                                                                │
│     │   [Codice completo]                                           │
│     │          │                                                     │
│     │          ▼                                                     │
│     │   Task(test-writer)  ─────────────────────────────────────►   │
│     │          │                                                     │
│     │          ▼                                                     │
│     │   Task(code-reviewer) ─────────────────────────────────────►  │
│     │          │                                                     │
│     │    Issues? ──┬── NO ──► Commit                                │
│     │             │                                                  │
│     │            YES                                                 │
│     │             │                                                  │
│     │             ▼                                                  │
│     │   Task(fixer) ──► Loop max 3x ──► Re-review                   │
│     │                                                                │
└─────────────────────────────────────────────────────────────────────┘
```

## Algoritmo Decisionale

### Step 1: Analisi Prerequisiti

```
function determinaModalita(milestone):
  apiSignaturePresente = exists("docs/api-specs/api-signature.md")
  sharedTypesDefined = apiSignaturePresente && hasSchemas(apiSignature)
  frontendDependsOnBackend = analizzaDipendenze(milestone)

  if !apiSignaturePresente:
    return "SEQUENZIALE_BE_FIRST"

  if !sharedTypesDefined:
    return "SEQUENZIALE_TYPES_FIRST"

  if frontendDependsOnBackend:
    return "SEQUENZIALE_BE_THEN_FE"

  return "PARALLELO"
```

### Step 2: Esecuzione Basata su Modalità

#### Modalità PARALLELO

1. Invoca simultaneamente:
   ```
   Task(backend-implementer, prompt_backend)   // Non-blocking
   Task(frontend-implementer, prompt_frontend) // Non-blocking
   ```

2. Attendi completamento entrambi (sync point)

3. Procedi con fase sequenziale (tests/review)

#### Modalità SEQUENZIALE_BE_FIRST

1. Invoca backend:
   ```
   Task(backend-implementer, prompt_backend) // Blocking
   ```

2. Attendi completamento

3. Invoca frontend:
   ```
   Task(frontend-implementer, prompt_frontend) // Blocking
   ```

4. Procedi con fase sequenziale

#### Modalità SEQUENZIALE_TYPES_FIRST

1. Genera shared types/contracts prima

2. Poi parallelo o sequenziale basato su dipendenze

### Step 3: Fase Sequenziale (Sempre)

```
1. Task(test-writer) → Attendi
2. Task(code-reviewer) → Attendi
3. Se issues:
   Loop (max 3x):
     Task(fixer) → Attendi
     Task(code-reviewer) → Verifica
     Se no issues: Break
4. Commit
```

## Scenari Comuni

### Scenario 1: API REST Standard

**Condizioni**:
- ✅ api-signature.md esiste
- ✅ Schemas definiti
- ✅ Frontend chiama API ma può usare mock

**Modalità**: PARALLELO

**Esecuzione**:
- Backend implementa API reali
- Frontend implementa UI con mock/fixtures
- Sync point: Entrambi completati
- Tests integrati verificano comunicazione

### Scenario 2: Frontend Dipende da Backend Specifico

**Condizioni**:
- ✅ api-signature.md esiste
- ❌ Frontend DEVE avere backend running per sviluppo
- ❌ Impossibile usare mock

**Modalità**: SEQUENZIALE_BE_THEN_FE

**Esecuzione**:
- Backend implementato e testato prima
- Backend deployato su dev environment
- Frontend sviluppato contro backend reale

### Scenario 3: Shared Types da Generare

**Condizioni**:
- ❌ Types non definiti in api-signature
- ✅ Necessari per entrambi i lati

**Modalità**: SEQUENZIALE_TYPES_FIRST

**Esecuzione**:
1. Genera types/contracts (TypeScript, Dart)
2. Poi parallelo backend + frontend

### Scenario 4: Monorepo con Shared Package

**Condizioni**:
- ✅ Shared package per types/utils
- ✅ Backend e Frontend dipendono da shared

**Modalità**: SEQUENZIALE_SHARED_FIRST

**Esecuzione**:
1. Implementa/aggiorna shared package
2. Parallelo backend + frontend (entrambi consumano shared)

## Metriche di Efficienza

### Guadagno Parallelizzazione

| Scenario | Tempo Sequenziale | Tempo Parallelo | Saving |
|----------|-------------------|-----------------|--------|
| Feature semplice (2h BE + 2h FE) | 4h | ~2h | 50% |
| Feature media (4h BE + 4h FE) | 8h | ~4h | 50% |
| Feature complessa (8h BE + 8h FE) | 16h | ~8h | 50% |

**Nota**: Tests/Review sempre sequenziali (1-2h addizionali)

### Quando NON Parallelizzare

- Backend e Frontend < 30min ciascuno (overhead > beneficio)
- Team singolo (impossibile vero parallelismo umano)
- Dipendenze strette che richiedono iterazioni frequenti
- Primo milestone (learning curve, setup)

## Sync Points

### Verifica Completamento Parallelo

```
function attendiCompletamento(tasks):
  while true:
    statuses = tasks.map(t => t.getStatus())

    if all(statuses == "completed"):
      return "SUCCESS"

    if any(statuses == "failed"):
      failedTask = tasks.find(t => t.status == "failed")
      handleFailure(failedTask)
      return "FAILURE"

    sleep(10s) // Poll ogni 10 secondi
```

### Gestione Fallimenti Durante Parallelo

**Se Backend fallisce**:
1. Cancella frontend task (se ancora in corso)
2. Analizza errore backend
3. Fix backend
4. Riavvia entrambi

**Se Frontend fallisce**:
1. Backend continua (può essere usato da altri)
2. Analizza errore frontend
3. Fix frontend
4. Riavvia solo frontend (backend già OK)

## Tool Usage Specifico

### Invocazione Parallela

```
# Single message con multiple Task tool calls
Message:
  Task(backend-implementer, ...)
  Task(frontend-implementer, ...)
```

**CRITICO**: Non usare await o blocking tra le chiamate.

### Invocazione Sequenziale

```
# Separate messages, attendi risposta tra uno e l'altro
Message 1:
  Task(backend-implementer, ...)

[Attendi risposta]

Message 2:
  Task(frontend-implementer, ...)
```

## Best Practices

1. **Default a Parallelo** se dubbio - Più veloce, rollback gestibile
2. **Documenta Decisione** - Spiega perché sequenziale se scelto
3. **Sync Point Esplicito** - Notifica utente quando attendi completamento
4. **Metriche** - Traccia tempo risparmiato con parallelizzazione
