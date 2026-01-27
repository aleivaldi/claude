---
name: develop
description: Skill orchestratore principale per implementazione. Workflow a blocchi con review integrata per-blocco, test su interfaccia in parallelo, e parallelismo tra blocchi indipendenti.
---

# Develop Skill

## Il Tuo Compito

Orchestrare l'implementazione completa di una feature o milestone, coordinando automaticamente gli agenti specializzati. Il workflow e' **autonomo** con stop solo ai checkpoint bloccanti.

**Focus**: Implementazione codice seguendo specs approvate. NON modifica specs, solo implementa.

**Prerequisiti**: Tutti i checkpoint bloccanti completati:
- `architecture_overview`, `tech_stack_choice`, `data_model`, `user_flows`
- `frontend_architecture` (da /frontend-architecture-designer)
- `backend_architecture` (da /backend-architecture-designer)
- `api_signature`

**Output**: Codice implementato, testato, reviewed, committato.

---

## Materiali di Riferimento

**Parallelizzazione e Blocchi**:
- `dynamic-parallelization.md` - Parallelismo a due livelli: tra blocchi e dentro blocco (Track 1 + Track 2)
- `task-decomposition-logic.md` - Decomposizione milestone in blocchi funzionali coesi + dependency DAG

**Git Flow**:
- `git-flow.md` - Feature branch per blocco, merge su develop, merge su main a milestone

**Checkpoint e Errori**:
- `checkpoint-templates.md` - Template checkpoint incluso Block Decomposition Approval
- `error-handling.md` - Procedure recovery per build failure, agent failure, block failure, git conflicts

---

## Invocazione

```
/develop [scope]

Scope validi:
- all           -> Tutto il progetto (tutti i milestone)
- backend       -> Solo backend
- frontend      -> Solo frontend
- [feature]     -> Feature specifica (es: auth, orders, users)
- milestone:N   -> Milestone specifico (es: milestone:2)
```

---

## Workflow: 7 Fasi con Blocchi, Review e E2E Integration

```
Fase 1: Load Context        -> Legge config, progress, specs
Fase 2: Verify              -> Verifica prerequisiti
Fase 3: Plan & Decompose    -> Decompone milestone in blocchi funzionali
  3a: Analisi scope e identificazione blocchi
  3b: Dependency DAG + ordine esecuzione
  3c: >>> CHECKPOINT BLOCCANTE: Block Decomposition Approval <<<
Fase 4: Execute Blocks      -> Per ogni blocco (rispettando dipendenze):
        |
        |  PER BLOCCO:
        |  +--> Track 1 (impl+unit test -> commit WIP -> review -> fix)  |  PARALLELO
        |  +--> Track 2 (contract test su interfacce pubbliche)          |
        |  |      +--> SEMANTIC VALIDATION (no trivial assertions)
        |  |
        |  +--> SYNC: Track 1 OK + Track 2 OK (quality-validated)
        |  |
        |  +--> Run ALL tests -> fix -> focused review -> retest
        |  |
        |  +--> Squash commits -> sblocca dipendenti
        |
        BLOCCHI INDIPENDENTI: IN PARALLELO
Fase 4.5: Integration E2E   -> DOPO tutti blocchi completati:
        |  +--> Health checks (backend, DB, frontend)
        |  +--> Seed test data
        |  +--> Run E2E tests (critical paths @milestone-N)
        |  +--> Run smoke tests (Chrome plugin automation)
        |  +--> Fix se fail -> retest (max 2 tentativi)
        |  +--> Report E2E metrics
Fase 5: Checkpoint          -> Stop se blocking, altrimenti continua
Fase 6: Finalize            -> Update progress, report
```

**Consulta `dynamic-parallelization.md` per architettura completa.**

---

## Fase 1: Load Context

Leggi:
- project-config.yaml
- progress.yaml
- docs/architecture/* (incluso frontend-architecture.md, backend-architecture.md)
- docs/api-specs/*
- docs/frontend-specs/*

Le architetture implementative (`frontend-architecture.md`, `backend-architecture.md`) guidano:
- Directory structure
- Component/Service patterns
- Middleware configuration
- Testing strategy

Determina scope da argomento (all, backend, frontend, feature, milestone:N).

Comunica stato caricato e procede automaticamente a Fase 2.

---

## Fase 2: Verify Prerequisites

Verifica checkpoint bloccanti:
- `brief`, `sitemap`
- `architecture_overview`, `tech_stack_choice`, `data_model`, `user_flows`
- `frontend_architecture`, `backend_architecture`
- `api_signature`

Se manca prerequisito: suggerisci skill necessaria:
- /architecture-designer per system architecture
- /frontend-architecture-designer per frontend implementation architecture
- /backend-architecture-designer per backend implementation architecture
- /api-signature-generator per API contract

**STOP** se manca qualsiasi prerequisito.

Verifica specs esistano per ogni endpoint/pagina/entita' da implementare.

### Setup Git Flow

Se `git_flow.enabled` in project-config.yaml (default: true):
1. Verifica/crea branch `develop` da `main`
2. `git checkout develop` come base per l'implementazione

**Consulta `git-flow.md` per dettagli setup.**

---

## Fase 3: Plan & Decompose in Blocchi

### Obiettivo
Decomporre milestone in **blocchi funzionali coesi** con dependency DAG, e ottenere approvazione utente prima dell'implementazione.

### 3a: Analisi Scope e Identificazione Blocchi

**Consulta `task-decomposition-logic.md` per algoritmo completo.**

1. **Analizza scope** (milestone, feature, o tutto)

2. **Identifica blocchi funzionali**:
   - Leggi API signature per identificare moduli/servizi
   - Raggruppa endpoints per servizio (es: auth-service, device-service)
   - Identifica UI components da sitemap
   - Ogni blocco = 1 unita' funzionale coesa (servizio, feature, modulo)

3. **Per ogni blocco definisci**:
   - ID univoco
   - Scope (cosa implementa)
   - File coinvolti (implementation + test)
   - Contratti/interfacce (API schemas, tipi, function signatures)
   - Dipendenze (altri blocchi)

### 3b: Dependency DAG e Ordine Esecuzione

1. **Costruisci dependency DAG**:
   - Analizza dipendenze logiche (es: user-profile dipende da auth-service)
   - Analizza dipendenze tecniche (shared types, migrations)
   - Identifica conflitti file (blocchi non possono scrivere stesso file)

2. **Determina ordine esecuzione**:
   - Topological sort del DAG
   - Blocchi senza dipendenze: eseguono in parallelo
   - Blocchi con dipendenze: attendono completamento dei blocchi prerequisiti
   - Rispetta max_concurrent_agents da config

3. **Valida decomposizione**:
   - No circular dependencies
   - No conflitti file tra blocchi paralleli
   - Granularita' ragionevole (blocco non troppo fine, non troppo grosso)

### 3c: CHECKPOINT BLOCCANTE - Block Decomposition Approval

**Consulta `checkpoint-templates.md` per template "Block Decomposition Approval".**

Presenta all'utente:
- Lista blocchi con scope, file, dipendenze
- **Per ogni blocco**: test previsti Track 1 (unit) e Track 2 (contract), con descrizione 1 riga per test
- Totale test previsti: `N unit + M contract = T total`
- Ordine esecuzione con parallelismo visualizzato
- Agenti assegnati per blocco

**STOP** e attendi approvazione. L'utente puo':
- Approvare -> Procedi a Fase 4
- Modificare -> Ridecomponi secondo indicazioni, ripresenta
- Rifiutare -> STOP completo

---

## Fase 4: Execute Blocks

### Obiettivo
Eseguire implementazione blocco per blocco con review integrata.

### Strategia per Blocco

**Consulta `dynamic-parallelization.md` per architettura completa.**

Per ogni blocco (rispettando ordine dipendenze):

#### 4a. Spawn Parallelo: Track 1 + Track 2

```
Track 1: Implementer (codice + unit test interni)
  -> Spawna backend-implementer o frontend-implementer
  -> Riceve: files da creare, API signature, data model, architettura
  -> Produce: codice implementativo + unit test per logica interna
     (helper functions, algoritmi, business logic privata)

Track 2: Test Writer (contract/integration test su interfacce pubbliche)
  -> Spawna test-writer
  -> Riceve: contratti API, schemas, tipi, function signatures
  -> Scrive test basandosi SOLO su interfacce pubbliche
  -> Test stabili anche se review modifica dettagli implementativi
```

Track 1 e Track 2 partono **in parallelo**.

**Divisione responsabilita' test**:

| Chi | Cosa testa | Stabilita' |
|-----|-----------|------------|
| Implementer (Track 1) | Logica interna, helper, algoritmi, edge cases implementativi | Puo' cambiare con refactoring |
| Test-writer (Track 2) | Contratti API, schemas, interfacce pubbliche, validazione | Stabile anche dopo refactoring |

Il code-reviewer (Track 1) verifica anche che gli unit test interni siano sufficienti.

#### 4b. Feature Branch + Commit WIP

Se `git_flow.enabled`: crea feature branch per il blocco, poi commit WIP.

```bash
# Crea feature branch da develop
git checkout develop
git checkout -b feature/[block-scope]

# Dopo implementazione
git add [block-impl-files]
git commit -m "wip([block-scope]): implement [block-name]

Co-Authored-By: Claude <model> <noreply@anthropic.com>"
```

**Consulta `git-flow.md` per naming convention e dettagli.**

Questo salva il lavoro dell'implementer su un branch isolato. Il reviewer lavora su un diff preciso.

#### 4c. Track 1: Review e Fix

Dopo il commit WIP:
1. **Code Review**: Invoca code-reviewer sui file del blocco
   - Verifica qualita' codice, sicurezza, patterns
   - Verifica presenza unit test interni sufficienti
2. **Fix Loop** (se review trova issue):
   - Invoca fixer per correggere
   - Commit fix: `git commit -m "fix([block-scope]): address review [block-name]"`
   - Re-review
   - Max 3 tentativi
3. **Review OK**: Track 1 completata

#### 4d. Sync Point + Track 2 Enforcement

Attendi completamento di ENTRAMBI:
- Track 1: review approvata (o fix completato)
- Track 2: contract/integration test pronti

**VALIDAZIONE Track 2** (enforcement R2 - blocco NON puo' procedere senza test):
1. Track 2 e' stato spawned (non skippato)
2. Contract test files esistono su disco
3. Conteggio test > 0

Se una qualsiasi validazione fallisce: **blocco FALLITO**. Non si puo' completare un blocco senza contract test.

#### 4e. Run Tests, Review Fix, Iterate

1. **Esegui TUTTI i test** del blocco (unit interni + contract/integration):
   ```bash
   npm run test -- --testPathPattern="[block-test-files]"
   ```

2. **Se test falliscono**:
   - Invoca fixer per correggere codice (NON test, salvo test palesemente errati)
   - Commit fix: `git commit -m "fix([block-scope]): fix test failures [block-name]"`
   - **Focused review**: invoca code-reviewer SOLO sui file toccati dal fixer
     (review leggera, non full review - verifica che il fix non introduca nuovi problemi)
   - Re-run test
   - Max 3 tentativi (ogni tentativo = fix + focused review + re-run)

3. **Se test passano**: Blocco pronto per finalizzazione

#### 4f. Blocco Completo

1. **Verifica build** compila con le modifiche del blocco
2. **Squash merge su develop** (git flow):
   ```bash
   git checkout develop
   git merge --squash feature/[block-scope]
   git commit -m "feat([block-scope]): implement [block-name]

   - Unit tests: X/Y passed
   - Contract tests: X/Y passed
   - Review issues fixed: [N]

   Co-Authored-By: Claude <model> <noreply@anthropic.com>"

   git branch -d feature/[block-scope]
   ```
   **Consulta `git-flow.md` per dettagli merge e conflict handling.**
3. **Report test outcome** per blocco:
   ```
   Unit (Track 1): X/Y passed (first attempt | N fix rounds)
   Contract (Track 2): X/Y passed (first attempt | N fix rounds)
   Total: X/Y
   ```
4. **Sblocca blocchi dipendenti** (aggiorna DAG)
5. **Log completamento** e procedi al prossimo blocco

### Parallelismo tra Blocchi

Blocchi **senza dipendenze reciproche** eseguono in parallelo:
- Ogni blocco segue il proprio ciclo completo (4a-4e)
- Max blocchi paralleli = max_concurrent_agents / agenti_per_blocco
- Quando un blocco completa, sblocca i suoi dipendenti

### Limiti Hardware

```yaml
# project-config.yaml
execution:
  max_concurrent_agents: 8  # Default, adatta a hardware
```

Agenti per blocco = 2 (implementer + test-writer) + 1 (reviewer, sequenziale).
Se N blocchi paralleli richiedono > max_concurrent_agents, accodare.

---

## Fase 4.5: Integration E2E Tests

### Obiettivo
Eseguire test integration/E2E AUTOMATICI dopo completamento di tutti i blocchi, PRIMA del checkpoint milestone. Trova integration bugs subito, non dopo approvazione.

### Quando Eseguire
- **Trigger**: Tutti blocchi del milestone completati (4f)
- **Scope**: Test E2E critical paths + smoke tests automation
- **Timing**: ~1-2 minuti overhead per milestone standard

### Pre-flight: Environment Verification

```bash
./helpers/verify-environment.sh
```

Checks automatici:
1. Backend UP (health endpoint responds)
2. Database connesso (se DATABASE_URL definito)
3. Test data seeded (se script seed disponibile)
4. Frontend/app UP (per E2E browser tests)
5. Playwright/browsers installati

**Exit codes**:
- 0 = All OK → Procedi
- 1 = Critical failure → STOP, notifica user
- 2 = Warnings → Procedi con caution

Vedi: `helpers/verify-environment.sh` per dettagli implementation.

### Step 1: Run E2E Contract Tests (Playwright)

Esegui test E2E taggati per questo milestone:

```bash
# Run tests con tag @milestone-N
npx playwright test --grep="@milestone-${MILESTONE_ID}"
```

**Tag strategy** (da comunicare a test-writer in Phase 3):
```typescript
// e2e/auth.spec.ts
test.describe('Auth @milestone-1 @critical', () => {
  test('login flow end-to-end', async ({ page }) => {
    // Test completo login -> dashboard
  });
});
```

**Scope E2E**: Solo **critical paths**, non comprehensive:
- Happy path principali (login, create entity, view list)
- Integration key (frontend + backend + DB)
- Exclude: Edge cases (coperti da unit/contract), UI details

**Parallel execution**:
```bash
npx playwright test --grep="@milestone-N" --workers=4
```

### Step 2: Run Smoke Tests (Chrome Plugin - OPTIONAL)

Se configurato in project-config.yaml:

```yaml
execution:
  smoke_test:
    enabled: true
    tool: "chrome-plugin"  # chrome-plugin | playwright | disabled
```

Esegui smoke tests automation:

```bash
./helpers/smoke-test.sh
```

**Smoke tests** coprono happy path con **browser automation real** (non mock):
- Login flow
- Dashboard loads data
- Create entity (es: device, user, order)
- Navigation works

Vedi: `helpers/smoke-test.sh` per implementation details (usa Claude Chrome plugin).

**Performance**: ~30s per 4-5 smoke tests.

### Step 3: Handle Failures

Se E2E o smoke tests falliscono:

1. **Categorize failure**:
   - Integration bug (backend + frontend mismatch)
   - Environment issue (DB down, missing seed data)
   - Flaky test (timing, race condition)

2. **Attempt auto-fix** (max 2 tentativi):
   - Invoca fixer per correggere integration bug
   - Commit fix: `fix(e2e): address integration issues [milestone]`
   - **Focused review**: Solo file toccati da fix
   - Re-run E2E tests

3. **Se ancora fail dopo 2 fix**:
   - **STOP** e presenta error a user
   - Report: quali test falliti, error messages, possibili cause
   - User decide: fix manualmente, skip E2E (con warning), continue

### Step 4: Report E2E Metrics

Includi in milestone summary (per Fase 5 checkpoint):

```markdown
Milestone [Name] completato.

| Block            | Unit  | Contract | E2E Impact | Fix Rounds |
|------------------|-------|----------|------------|------------|
| auth-service     | 5/5   | 8/8      | ✅ Pass    | 0          |
| device-crud      | 4/4   | 6/6      | ✅ Pass    | 0          |
| login-ui         | 3/3   | 5/5      | ⚠️ 1 fix   | 1          |
| device-dashboard | 4/4   | 7/7      | ✅ Pass    | 0          |
| **Total**        |**16/16**|**26/26**| **E2E: 8/8** | **1**  |

E2E Test Results (Fase 4.5):
- Critical paths: 8/8 passed ✅
- Smoke tests: 4/4 passed ✅
- Integration bugs found: 1 (login-ui + auth-service interaction)
- Fixes applied: 1
- Environment issues: 0
- Total time: 1m 23s
```

### Configuration

```yaml
# project-config.yaml
execution:
  e2e_integration:
    enabled: true                 # Run E2E in Fase 4.5 (default: true)
    scope: "critical"             # critical | milestone | all
    max_fix_attempts: 2           # Auto-fix tentativi
    environment_check: true       # Run verify-environment.sh
    seed_test_data: true          # Seed DB prima di test
    parallel_workers: 4           # Playwright workers

  smoke_test:
    enabled: true                 # Run smoke tests (default: true)
    tool: "chrome-plugin"         # chrome-plugin | playwright | disabled
    on_success: "continue"        # Continue automaticamente
    on_failure: "checkpoint"      # STOP solo se fail
    tests:
      - login_flow
      - dashboard_load
      - create_entity
      - navigation
```

### Benefits

- **Early detection**: Integration bugs trovati PRIMA di dire "milestone completo"
- **Automatic**: Zero manual intervention se tests passano
- **Fast**: ~1-2 min overhead, molto meno di debug post-approvazione
- **Confidence**: Milestone checkpoint con "E2E: 8/8 passed" = vero completed

### Error Handling

**Environment failure** (verify-environment.sh exit 1):
```
ERROR: Backend not responding at http://localhost:3000/health

Cannot proceed with E2E tests. Please:
1. Start backend: npm run dev
2. Verify DATABASE_URL is set
3. Re-run /develop or skip E2E tests (not recommended)
```

**E2E test failure** (dopo 2 fix attempts):
```
ERROR: E2E tests still failing after 2 fix attempts

Failed tests:
- Login flow: AssertionError: Expected URL to contain '/dashboard', got '/login'
- Create device: TimeoutError: Element 'button:has-text("Save")' not found

Possible causes:
1. Integration bug (frontend expects different API response)
2. Timing issue (need explicit wait)
3. Test environment setup (missing seed data)

Action required: Manual investigation or skip E2E (with warning).
```

---

## Fase 5: Checkpoint

### Obiettivo
Verificare se checkpoint bloccante richiede approvazione.

### Azioni

**Consulta `checkpoint-templates.md` per template completi e configurazione.**

1. **Verifica config** in project-config.yaml (enabled, blocking)
2. **Se blocking**: Presenta checkpoint e usa AskUserQuestion
3. **Se non-blocking**: Notifica e continua automaticamente
4. **Gestisci risposta**: Approva -> Fase 6, Modifica -> Rileggi e ripresenta, Stop -> Salva stato

---

## Fase 6: Finalize

### Obiettivo
Aggiornare stato e reportare. I commit sono gia' stati fatti per-blocco (squash in 4f).

### Azioni

1. **Aggiorna progress.yaml**:

   ```yaml
   milestones:
     - id: M1
       name: "[Feature]"
       status: completed
       completed_at: "[timestamp]"
       blocks_completed:
         - id: auth-service
           tests_passed: 15
           review_issues_fixed: 2
         - id: device-crud
           tests_passed: 12
           review_issues_fixed: 0
       metrics:
         tests_passed: X
         coverage: Y%
         issues_fixed: Z
       commits:
         - "[hash]"
   ```

3. **Merge develop -> main** (se `git_flow.merge_to_main == on_milestone`):
   ```bash
   git checkout main
   git merge develop --no-ff -m "milestone([name]): complete [milestone-name]"
   git checkout develop
   ```
   **Consulta `git-flow.md` per strategie merge_to_main.**

4. **Report finale con tabella test aggregata**:

   ```
   Milestone [Name] completato.

   | Block    | Unit  | Contract | Total  | Fix Rounds |
   |----------|-------|----------|--------|------------|
   | [B1]     | X/Y   | X/Y      | X/Y    | N          |
   | [B2]     | X/Y   | X/Y      | X/Y    | N          |
   | **Total**| X/Y   | X/Y      | X/Y    | N          |

   Modifiche:
   - [X] files backend
   - [Y] files frontend
   - [Z] files test

   Git: develop branch -> merged to main
   Commit: [hash] - [message]

   Prossimo milestone: [Nome] (se esiste)
   Oppure: Implementazione completa!
   ```

5. **Loop al prossimo milestone** se esistono altri pending.

---

## Gestione Errori

**Consulta `error-handling.md` per procedure recovery complete.**

Errori gestiti automaticamente:
- **Build Failure**: Rollback, analisi, fix con retry (max 3x)
- **Test Failure**: Categorizza (obsoleto/regressione/flaky), fix appropriato
- **Review Issues**: Fix per-blocco, max 3x, non accumula
- **Block Failure**: Non blocca blocchi indipendenti, blocca dipendenti
- **Agent Failure**: Retry automatico con timeout esteso
- **Git Conflict**: Auto-resolve se safe, altrimenti notifica utente
- **Max Retry**: Salva stato blocco, notifica utente, continua altri blocchi indipendenti

---

## Regole Tool

- **Task** per invocare agenti specializzati
- **TodoWrite** per tracking progress
- **Bash** solo per git e build
- **Read/Write/Edit** per files
- **AskUserQuestion** solo per checkpoint bloccanti

---

## Principi

- **Autonomo**: Procede senza intervento dove possibile
- **Review per-blocco**: Feedback immediato, rework limitato al blocco corrente
- **Due tipi di test**: Implementer scrive unit test interni, test-writer scrive contract test su interfacce
- **Commit early**: Commit WIP prima della review, squash a fine blocco
- **Review dopo ogni fix**: Focused review dopo fix per test failure (non solo dopo review issues)
- **Parallelo dove possibile**: Blocchi indipendenti + Track 1/Track 2 dentro blocco
- **Sequenziale dove necessario**: Review dopo impl, test run dopo sync
- **Self-healing**: Retry automatici prima di fermarsi
- **Failure isolation**: Blocco fallito non blocca indipendenti
- **Resumable**: Puo' riprendere da qualsiasi blocco
- **Transparent**: Report chiaro di ogni azione

---

## Avvio Workflow

1. Ricevi scope da utente
2. Fase 1: Load context
3. Fase 2: Verify prerequisites (STOP se mancano)
4. Fase 3: Plan & Decompose in blocchi -> **CHECKPOINT** approvazione decomposizione
5. Fase 4: Execute blocks (impl + test paralleli, review per-blocco)
6. Fase 5: Checkpoint (STOP se blocking)
7. Fase 6: Finalize e loop

**Principio**: L'utente invoca `/develop` e il sistema procede autonomamente fino al prossimo checkpoint bloccante o al completamento.
