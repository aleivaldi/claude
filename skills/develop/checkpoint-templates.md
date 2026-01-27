# Checkpoint Templates

## Template Checkpoint Block Decomposition Approval

```
═══════════════════════════════════════════════════════════════
>>> CHECKPOINT: BLOCK_DECOMPOSITION <<<
Stato: BLOCKING - Richiesta approvazione decomposizione
═══════════════════════════════════════════════════════════════

## Decomposizione Milestone: [Name]

### Blocchi Identificati: [N]

+-----+--------------------+----------+------------------------+-----------------+
| #   | Blocco             | Tipo     | Files                  | Dipendenze      |
+-----+--------------------+----------+------------------------+-----------------+
| B1  | [block-name]       | backend  | src/services/[name].ts | -               |
| B2  | [block-name]       | backend  | src/services/[name].ts | B1              |
| B3  | [block-name]       | frontend | lib/screens/[name]/    | -               |
| ...                                                                            |
+-----+--------------------+----------+------------------------+-----------------+

### Ordine Esecuzione

Turno 1: B1, B3           [N blocchi, M agenti]
  -> IN PARALLELO (nessuna dipendenza reciproca)
Turno 2: B2               [N blocchi, M agenti]
  -> Dopo completamento B1

### Dettaglio Test per Blocco

Block B1: [block-name]
  Scope: [scope description]
  Tests Track 1 (unit):
    - [service.method]: [descrizione 1 riga]
    - [service.method]: [descrizione 1 riga]
  Tests Track 2 (contract):
    - [METHOD /path]: [descrizione 1 riga]
    - [METHOD /path]: [descrizione 1 riga]

Block B2: [block-name]
  ...

Tests previsti: N unit + M contract = T total

### Per Ogni Blocco
- Track 1: Implementer -> Code Review -> Fix (se necessario)
- Track 2: Test Writer su contratti/interfacce (in parallelo con Track 1)
- Sync -> Run tests -> Fix failures -> Blocco completo

### Agenti Totali
- Picco concorrenza: [N] agenti (Turno [X])
- Blocchi totali: [N]

═══════════════════════════════════════════════════════════════
Approvi questa decomposizione?
[S]i / [N]o / [M]odifica (specifica cosa cambiare)
═══════════════════════════════════════════════════════════════
```

**Comportamento**: STOP, attendi risposta utente.
- **Si**: Procedi a Fase 4 (Execute Blocks)
- **No**: STOP completo, chiedi cosa modificare
- **Modifica**: Ridecomponi secondo indicazioni, ripresenta checkpoint

### AskUserQuestion Format per Block Decomposition

```
AskUserQuestion:
  questions:
    - question: "Approvi la decomposizione in blocchi?"
      header: "Blocchi"
      multiSelect: false
      options:
        - label: "Approva"
          description: "[N] blocchi, [M] turni, parallelismo max [P] agenti"
        - label: "Modifica"
          description: "Voglio cambiare raggruppamento o dipendenze"
        - label: "Rifiuta"
          description: "Stop, ripensare la decomposizione"
```

---

## Template Checkpoint Blocco Completo (Review, non-blocking)

```
═══════════════════════════════════════════════════════════════
>>> CHECKPOINT: BLOCK_COMPLETE <<<
Stato: REVIEW - Continuo automaticamente
═══════════════════════════════════════════════════════════════

## Blocco [Name] Completato

### Track 1 (Implementazione + Review)
- Implementer: [backend/frontend]-implementer
- Files: [lista files]
- Review: [N] issues trovati, [N] fixati

### Track 2 (Test su Contratti)
- Tests scritti: [N]
- Basati su: [contratti API / schemas / tipi]

### Test Report
  Unit (Track 1): X/Y passed (first attempt | N fix rounds)
  Contract (Track 2): X/Y passed (first attempt | N fix rounds)
  Total: X/Y

### Git
- Branch: feature/[block-scope] -> merged to develop
- Commit: [hash] feat([scope]): implement [block-name]

### Blocchi sbloccati: [lista o "nessuno"]

═══════════════════════════════════════════════════════════════
Procedo con prossimo blocco...
═══════════════════════════════════════════════════════════════
```

**Comportamento**: Notifica e continua automaticamente.

---

## Template Checkpoint Milestone

```
═══════════════════════════════════════════════════════════════
>>> CHECKPOINT: MILESTONE [Name] <<<
═══════════════════════════════════════════════════════════════

## Milestone Completato

### Backend
- [x] [Task 1]
- [x] [Task 2]
Files: [lista]

### Frontend
- [x] [Task 1]
- [x] [Task 2]
Files: [lista]

### Test Summary

| Block | Unit | Contract | Total | Fix Rounds |
|-------|------|----------|-------|------------|
| B1    | 5/5  | 8/8      | 13/13 | 0          |
| B2    | 3/3  | 6/6      | 9/9   | 1          |
| B3    | 4/4  | 5/5      | 9/9   | 0          |
| **Total** | **12/12** | **19/19** | **31/31** | **1** |

Coverage: Y%

### Review
- Issues trovati: Z
- Issues fixati: Z
- Issues aperti: 0

### Git Flow
- Branch: develop (N commits from N blocks)
- Merge to main: [pending | done | manual]

═══════════════════════════════════════════════════════════════
Approvi per procedere al prossimo milestone?
```

## Template Checkpoint Feature

```
═══════════════════════════════════════════════════════════════
>>> CHECKPOINT: FEATURE [Name] COMPLETE <<<
═══════════════════════════════════════════════════════════════

## Feature Implementata

### Summary
[Descrizione 1-2 frasi cosa fa la feature]

### Components Modified
- Backend: X files (Y LOC)
- Frontend: X files (Y LOC)
- Tests: X files (Y LOC)

### Test Results
- Unit: X/X passed
- Integration: X/X passed
- E2E: X/X passed (opzionale)
- Coverage: Y%

### Review Status
✅ Code review passed
✅ Security check passed
✅ Performance check passed

═══════════════════════════════════════════════════════════════
Feature pronta per merge/deploy?
```

## Template Checkpoint Bloccante vs Review

### Bloccante (Richiede Approvazione)

```
═══════════════════════════════════════════════════════════════
>>> CHECKPOINT: [NAME] <<<
Stato: BLOCKING - Richiesta approvazione
═══════════════════════════════════════════════════════════════

[Contenuto checkpoint]

═══════════════════════════════════════════════════════════════
Approvi? [S]ì / [N]o / [M]odifica
═══════════════════════════════════════════════════════════════
```

**Comportamento**: STOP, attendi risposta utente, NON procedere automaticamente.

### Review (Notifica)

```
═══════════════════════════════════════════════════════════════
>>> CHECKPOINT: [NAME] <<<
Stato: REVIEW - Continuo automaticamente
═══════════════════════════════════════════════════════════════

[Contenuto checkpoint]

═══════════════════════════════════════════════════════════════
Review consigliata per: [aspetti specifici]
Procedo automaticamente al prossimo step...
═══════════════════════════════════════════════════════════════
```

**Comportamento**: Notifica ma continua senza attendere.

## Configurazione Checkpoint

### project-config.yaml

```yaml
checkpoints:
  milestone_complete:
    enabled: true
    blocking: true    # STOP e chiedi approvazione

  feature_complete:
    enabled: true
    blocking: false   # Notifica ma continua

  sync_point:
    enabled: true
    blocking: true    # Quando backend e frontend divergono
```

## Logica Decisionale Checkpoint

```
function presentaCheckpoint(checkpointName, config):
  checkpointConfig = config.checkpoints[checkpointName]

  if !checkpointConfig.enabled:
    // Skip completamente
    return "SKIP"

  if checkpointConfig.blocking:
    // Presenta e attendi
    displayCheckpoint(checkpointName, "BLOCKING")
    response = AskUserQuestion(...)
    return response // "APPROVE", "MODIFY", "REJECT"
  else:
    // Notifica e continua
    displayCheckpoint(checkpointName, "REVIEW")
    return "CONTINUE"
```

## Gestione Risposte

### Risposta: APPROVE

```
[Salva approvazione in progress.yaml]
checkpoints_completed:
  - name: [checkpoint_name]
    approved_at: [timestamp]
    approved_by: user

[Procedi alla fase successiva]
```

### Risposta: MODIFY

```
User: M - [descrizione modifiche]

[Attendi che utente faccia modifiche]

User: "Fatto"

[Rileggi stato, ripresenta checkpoint]
```

### Risposta: REJECT

```
User: N - Motivo rifiuto

[Salva stato in progress.yaml]
milestone_status: rejected
rejection_reason: [motivo]

[STOP completo - non procedere]

[Comunica cosa serve per riprendere]
```

## AskUserQuestion Format

```
AskUserQuestion:
  questions:
    - question: "Approvi questo milestone?"
      header: "Milestone"
      multiSelect: false
      options:
        - label: "Approva"
          description: "Milestone OK, procedi"
        - label: "Modifica"
          description: "Fammi modificare prima"
        - label: "Rifiuta"
          description: "Stop, problema critico"
```

## Contenuto Checkpoint Efficace

### ✅ Buono (Informativo, Actionable)

```
## Backend Implementato

### API Endpoints Creati
- POST /auth/login - Autenticazione JWT
- GET /users/me - Profilo utente
- PUT /users/me - Aggiorna profilo

### Database Schema
- Tabella users: 8 colonne
- Indici: email (unique), created_at

### Tests
- 15 unit tests (auth service)
- 8 integration tests (API endpoints)
- Coverage: 87%

### Files Modificati
- src/services/auth.service.ts (nuovo)
- src/routes/auth.routes.ts (nuovo)
- prisma/schema.prisma (aggiornato)
```

### ❌ Cattivo (Vago, Non Verificabile)

```
## Backend Implementato

Backend completato con tutte le funzionalità richieste.
Tests passano.
Tutto OK.
```

## Metriche da Includere

### Per Milestone

- Files modificati (conteggio + LOC)
- Tests passati/totali
- Coverage % (se disponibile)
- Issues risolti (se applicabile)
- Tempo impiegato (opzionale)

### Per Feature

- Components toccati (BE, FE, DB, etc)
- Breaking changes (se esistono)
- Migration necessarie (se DB)
- Documentation aggiornata (se applicabile)

## Progress Tracking

### progress.yaml Update

```yaml
milestones:
  - id: M1
    name: "User Authentication"
    status: completed
    completed_at: "2026-01-22T14:30:00"
    approved_at: "2026-01-22T14:35:00"
    metrics:
      files_backend: 12
      files_frontend: 8
      files_tests: 15
      tests_passed: 45
      coverage: 87
      issues_fixed: 3
    commits:
      - "a1b2c3d"
      - "e4f5g6h"
```

## Notifiche vs Blocchi

### Quando BLOCKING

- Milestone completato (decisione critica)
- Breaking changes introdotti
- Architettura modificata
- Primo milestone (validazione approccio)
- Dopo > 3 fix loop falliti

### Quando REVIEW (non-blocking)

- Feature minore completata
- Tests aggiornati
- Refactoring interno (no API changes)
- Documentation update
- Sync point intermedio

## Best Practices

1. **Checkpoint al Momento Giusto** - Non troppo frequenti, non troppo rari
2. **Info Verificabili** - Numeri concreti, non "tutto OK"
3. **Actionable** - Utente può validare facilmente
4. **Consistente** - Stesso formato per stesso tipo checkpoint
5. **Salva Stato** - progress.yaml sempre aggiornato
