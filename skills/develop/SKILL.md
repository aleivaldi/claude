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
- Approvare -> Procedi a Fase 3.5 (Specs Completeness Validation)
- Modificare -> Ridecomponi secondo indicazioni, ripresenta
- Rifiutare -> STOP completo

---

## Fase 3.5: Specs Completeness Validation

### Obiettivo
Verificare che specs siano **complete** prima di implementare. Previene implementazioni incomplete per mancanza di dettagli nelle specs.

**Consulta `validation-checkpoints.md` per dettagli completi.**

### Azioni

1. **Cross-reference specs vs blocchi approvati**:
   - API endpoints in `docs/api-specs/api-signature.md`
   - Data entities in `docs/architecture/data-model.md`
   - Frontend screens in `docs/frontend-specs/sitemap.md`
   - Frontend architecture in `docs/architecture/frontend-architecture.md`
   - Backend architecture in `docs/architecture/backend-architecture.md`

2. **Verifica completeness per ogni blocco**:

   **API Specs Completeness**:
   - Request/Response schemas definiti completamente (no TBD, no optional senza default)
   - HTTP methods specificati
   - Error responses documentati (400, 401, 403, 404, 500)
   - Validation rules esplicite (regex, min/max, required fields)
   - Authentication requirements specificati

   **Data Model Completeness**:
   - Entity fields e types completi (no missing fields)
   - Relations tra entità definite (1:1, 1:N, N:M)
   - Constraints documentati (unique, not null, foreign keys)
   - Indexes suggeriti per query performance

   **Frontend Specs Completeness**:
   - Data sources specificati per ogni screen (quali API chiamare)
   - User actions documentate (buttons, forms, navigation)
   - Input validation rules (frontend-side)
   - Error handling UI (come mostrare errori API)
   - Loading states definiti

3. **Report gaps dettagliato** (se trovati):
   ```
   SPECS COMPLETENESS GAPS FOUND

   API Signature gaps:
   - POST /api/users missing response schema (solo status code definito)
   - PUT /api/devices/:id missing validation rules (quali campi required?)
   - GET /api/orders missing error responses (cosa return se 404?)

   Data Model gaps:
   - Entity "Order" missing field "createdBy" (chi ha creato?)
   - Relation User->Orders non specificata (1:N o N:M?)
   - Table "devices" missing index su "organizationId" (performance query)

   Frontend Specs gaps:
   - Screen "Dashboard" non specifica data source (quale API?)
   - Screen "LoginForm" missing error handling (come mostrare "invalid credentials"?)
   - Navigation flow da "DeviceList" a "DeviceDetail" non documentato

   Action required:
   1. Update specs con dettagli mancanti
   2. Re-run /develop (ripartirà da questa fase)

   Oppure procedi ignorando gaps (NOT RECOMMENDED - implementazione sarà incompleta)
   ```

4. **Gestione**:
   - **Se 0 gaps**: Procedi automaticamente a Fase 4 (Execute Blocks)
   - **Se gaps trovati**: **STOP** e usa AskUserQuestion con 3 opzioni:
     - [F] Fix specs ora (RECOMMENDED) → STOP completo, user aggiorna specs manualmente
     - [I] Ignora gaps e procedi (NOT RECOMMENDED) → Continua con warning
     - [C] Chiedi a Claude di colmare gaps con ipotesi ragionevoli → Genera draft specs, presenta per approvazione

### Configuration

```yaml
# project-config.yaml
develop:
  validations:
    specs_completeness:
      enabled: true           # Default: true
      blocking: true          # Default: true (STOP se gaps)
      check_api_schemas: true # Verifica request/response completi
      check_data_entities: true # Verifica entity fields completi
      check_screen_data_sources: true # Verifica frontend data sources
      check_validation_rules: true # Verifica validation esplicite
      check_error_handling: true # Verifica error cases documentati
      allow_ignore: true      # Permetti di ignorare gaps (con warning)
      allow_auto_fill: true   # Permetti a Claude di colmare gaps con ipotesi
```

**Tipo**: BLOCKING (default) - blocco NON può procedere senza specs complete (o approvazione esplicita gaps)

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

##### Ciclo di Vita Git per Blocco (Summary)

**Pattern**: Feature branch → Commit incrementali → Squash merge

| Step | Branch | Commit | Tipo | Descrizione |
|------|--------|--------|------|-------------|
| **4b** | `feature/[block]` | `wip([scope]): implement [block-name]` | WIP | Implementazione iniziale |
| **4c** | `feature/[block]` | `fix([scope]): address review [block-name]` | FIX | Correzioni da code review (loop max 3x) |
| **4e** | `feature/[block]` | `fix([scope]): fix test failures [block-name]` | FIX | Fix test falliti (loop max 3x) |
| **4e.5** | `feature/[block]` | `fix([scope]): complete implementation (remove stub/mock)` | FIX | Rimozione stub/mock, completezza (loop max 2x) |
| **4f** | `develop` | `feat([scope]): implement [block-name]` | FEAT | Squash merge finale (tutti commit sopra collassati) |

**Benefici branch-per-blocco**:
- ✅ **Isolamento**: Ogni blocco su proprio branch, zero conflitti tra blocchi paralleli
- ✅ **Rollback facile**: `git branch -D feature/[block]` se blocco fallisce
- ✅ **Review precisa**: Reviewer vede diff esatto del blocco
- ✅ **Storia pulita**: Squash merge → 1 commit finale su develop per blocco
- ✅ **Work-in-progress salvato**: Commit WIP/fix preservano progresso durante sviluppo

**Gestione conflitti**:
- **Durante sviluppo blocco**: Impossibile (branch isolato)
- **Durante squash merge**: Possibile se due blocchi paralleli toccano stesso file
  - Risoluzione: Merge develop → feature branch, risolvi conflitto, re-test, squash
  - Dettagli: `git-flow.md`

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

3. **Se test passano**: Procedi a Fase 4e.5 (Implementation Completeness Check)

#### 4e.5 Implementation Completeness Check (PRIORITÀ MASSIMA)

**Obiettivo**: Verificare che implementazione sia **COMPLETA** - zero stub/mock/placeholder, piena aderenza alle specs.

**Consulta `validation-checkpoints.md` per dettagli completi.**

**Questo è il checkpoint PIÙ IMPORTANTE** - previene implementazioni incomplete che arrivano a "milestone complete" con funzionalità non implementate.

##### Step 1: Scan Pattern Anti-completeness

Usa Grep multi-pattern sui file implementati del blocco:

```bash
# Pattern 1: Commenti da risolvere
grep -rn "TODO|FIXME|HACK|XXX" [block-files]

# Pattern 2: Dati fittizi
grep -rni "mock|stub|placeholder|dummy|fake" [block-files]

# Pattern 3: Implementazione vuota (return early senza logica)
grep -rn "return \{\}|return \[\]|return null|return undefined" [block-files]

# Pattern 4: Dati hardcoded
grep -rni "hardcoded|hardcode" [block-files]

# Pattern 5: Debug statements
grep -rn "console\.log|console\.warn|print\(|dump\(" [block-files]
```

**Eccezioni legittime** (non considerare issue):
- `return null` in getter per optional values
- `return {}` in reducer default case
- `console.error` in error handlers (ma solo se wrappa logger)
- `// TODO` in commenti di documentazione (non codice)

##### Step 2: Verifica Aderenza Spec

Cross-reference implementazione vs specs:

**API Implementation vs API Signature**:
- ✅ Endpoint implementa TUTTI i campi di response schema (non subset)
- ✅ Request validation applica TUTTE le rules da spec (regex, min/max, required)
- ✅ Error cases da spec gestiti (400, 401, 403, 404, 500)
- ❌ Campi response mancanti rispetto a schema
- ❌ Validation rules ignorate
- ❌ Error cases non gestiti

**Frontend Implementation vs Sitemap/Architecture**:
- ✅ Screen mostra TUTTI i dati previsti
- ✅ User actions da spec implementate (buttons, forms)
- ✅ Navigation flows seguiti
- ❌ Dati previsti non mostrati
- ❌ Azioni utente mancanti
- ❌ Navigation non implementata

**Data Access vs Data Model**:
- ✅ Query usano indexes suggeriti
- ✅ Relations implementate correttamente
- ✅ Constraints rispettati
- ❌ Missing fields in entity
- ❌ Relations ignorate

##### Step 3: Report Dettagliato Issues

Se trova issues, genera report strutturato:

```
═══════════════════════════════════════════════════════════════
BLOCK IMPLEMENTATION INCOMPLETE: [block-name]
═══════════════════════════════════════════════════════════════

Stub/Mock/Placeholder Found (Pattern Scan):
- src/api/users.ts:42
  Code: return mockUsers // TODO: implement real API call
  Issue: Mock data instead of real DB query

- src/components/UserList.tsx:18
  Code: const data = [] // placeholder
  Issue: Empty placeholder instead of API call

- src/services/device.service.ts:67
  Code: console.log('Device created:', device)
  Issue: Debug statement not removed

Spec Deviation Found (Adherence Check):
- src/api/users.ts missing response field "lastLogin"
  Spec: api-signature.md line 123 requires "lastLogin: ISO8601"
  Impact: Frontend expects field, will break

- src/components/LoginForm.tsx no email validation
  Spec: frontend-architecture.md requires regex /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  Impact: Invalid emails accepted

- src/api/devices.ts missing error handling for 404
  Spec: api-signature.md defines 404 response {error: "Device not found"}
  Impact: Generic 500 returned instead

═══════════════════════════════════════════════════════════════
TOTAL ISSUES: 6 (3 stub/mock, 3 spec deviations)

Action: Fix issues automatically via fixer, re-test, re-check
═══════════════════════════════════════════════════════════════
```

##### Step 4: Auto-Fix Loop

**Gestione issues**:

1. **Se 0 issues**: Blocco COMPLETATO → Procedi a 4f (Blocco Completo)

2. **Se issues trovati**:
   - Invoca **fixer** agent per risolvere TUTTI gli issues
   - Fixer riceve: report issues + specs reference + file paths
   - Fixer applica fix:
     - Sostituisce mock con real implementation
     - Aggiunge campi mancanti
     - Implementa validation rules
     - Rimuove debug statements
   - **Commit completeness fix**:
     ```bash
     git add [fixed-files]
     git commit -m "fix([scope]): complete implementation (remove stub/mock)

     - Removed mock data placeholders
     - Implemented missing validation rules
     - Added missing response fields
     - Removed debug statements

     Co-Authored-By: Claude <model> <noreply@anthropic.com>"
     ```
   - **Re-run tests** (unit + contract)
   - **Re-check completeness** (re-scan patterns + re-check adherence)
   - **Loop max 2 volte** (fix -> commit -> test -> re-check -> fix -> commit -> test -> re-check)

3. **Se ancora issues dopo 2 fix cycles**:
   - **STOP** e presenta report all'utente
   - AskUserQuestion con 3 opzioni:
     - [F] Fix manualmente → STOP completo, user interviene
     - [C] Continua con issues (NOT RECOMMENDED) → Warning logged, procedi
     - [R] Re-attempt auto-fix (1 tentativo extra) → Loop ancora una volta

##### Step 5: Validation Completeness

Prima di dichiarare blocco completo, verifica:

```
Implementation Completeness Checklist:
✅ Zero stub/mock/placeholder in production code
✅ Zero TODO/FIXME in implementation (docs OK)
✅ Zero hardcoded data (config/constants OK)
✅ Zero debug statements (error logging OK)
✅ All response fields from spec implemented
✅ All validation rules from spec applied
✅ All error cases from spec handled
✅ All user actions from spec implemented
✅ All data sources from spec connected
```

**Solo se TUTTE le checklist ✅**: Blocco può procedere a 4f (Completo).

### Configuration

```yaml
# project-config.yaml
develop:
  validations:
    implementation_completeness:
      enabled: true               # Default: true (MANDATORY)
      blocking: true              # Default: true (CANNOT skip)
      scan_patterns:              # Pattern anti-completeness
        - "TODO|FIXME|HACK|XXX"
        - "mock|stub|placeholder|dummy|fake"
        - "return \\{\\}|return \\[\\]|return null|return undefined"
        - "hardcoded|hardcode"
        - "console\\.log|console\\.warn|print\\(|dump\\("
      check_spec_adherence: true  # Verifica vs specs
      max_fix_attempts: 2         # Auto-fix cycles
      allow_continue_with_issues: false # Default: false (STOP se issues)
      exceptions:                 # Pattern legittime da ignorare
        - "return null  # optional value"
        - "return {}    # reducer default"
        - "console.error # wrapped logger"
```

**Tipo**: BLOCKING (MANDATORY) - blocco NON può completare con stub/mock o spec deviation.

**Effort**: ~1-2 min per blocco (scan + check automatici, fix solo se needed)

**Benefits**:
- ✅ **Elimina implementazioni incomplete** (problema principale QRPay)
- ✅ **Garantisce aderenza specs** (codice fa esattamente cosa specs dicono)
- ✅ **Auto-fix automatico** (zero intervento umano per 90% casi)
- ✅ **Early detection** (trova issues PRIMA di dire "blocco completo")
- ✅ **Transparent** (report dettagliato cosa manca e perché)

#### 4f. Blocco Completo

1. **Verifica build** compila con le modifiche del blocco

#### 4f.2 Frontend Layout Checkpoint (se blocco frontend)

**Trigger**: Ogni N schermate implementate (config: `frequency`)

**Obiettivo**: Verifica progressiva layout frontend vs mockup/design durante implementazione. Previene scoprire layout issues solo a milestone completo.

**Consulta `validation-checkpoints.md` per dettagli completi.**

##### Quando Eseguire

- **Scope**: Solo blocchi frontend (skip se backend-only)
- **Frequency**: Ogni N schermate (config: default 3)
- **Timing**: Dopo build verification (4f.1), prima di squash merge (4f.3)

##### Step 1: Generate Screenshots

Usa Playwright per catturare screenshot automatici:

```bash
# Genera screenshot per schermate implementate in questo blocco
npx playwright test --grep="@screenshot" --project=chromium
```

**Setup** (da comunicare a frontend-implementer):
```typescript
// e2e/screenshots.spec.ts
test.describe('Screenshots @screenshot', () => {
  test('Screen A', async ({ page }) => {
    await page.goto('/screen-a');
    await page.waitForLoadState('networkidle');
    await page.screenshot({ path: 'screenshots/screen-a.png', fullPage: true });
  });

  test('Screen B', async ({ page }) => {
    await page.goto('/screen-b');
    await page.waitForLoadState('networkidle');
    await page.screenshot({ path: 'screenshots/screen-b.png', fullPage: true });
  });
});
```

**Output**: `screenshots/` directory con PNG per ogni screen implementata.

##### Step 2: Present Visual Checkpoint

Presenta checkpoint visivo all'utente:

```
═══════════════════════════════════════════════════════════════
>>> FRONTEND LAYOUT CHECKPOINT: Milestone [N] - Block [X/Y] <<<
═══════════════════════════════════════════════════════════════

Schermate implementate (ultime N):
1. [Screen Name A] (/path/to/screen-a)
   Screenshot: screenshots/screen-a.png
   Data: [Live API | Mock data | Static]
   Status: Build OK, tests passing

2. [Screen Name B] (/path/to/screen-b)
   Screenshot: screenshots/screen-b.png
   Data: [Live API | Mock data | Static]
   Status: Build OK, tests passing

3. [Screen Name C] (/path/to/screen-c)
   Screenshot: screenshots/screen-c.png
   Data: [Live API | Mock data | Static]
   Status: Build OK, tests passing

Checklist Review (manual):
- [ ] Layout matches mockup/design system
- [ ] Responsive (mobile, tablet, desktop)
- [ ] Accessibility (keyboard nav, ARIA labels)
- [ ] Branding (colors, fonts, logo)
- [ ] Loading states visible
- [ ] Error states visible

═══════════════════════════════════════════════════════════════
Action: [P]rocedi / [R]eview (STOP per ispezione)
═══════════════════════════════════════════════════════════════
```

##### Step 3: User Response

- **[P] Procedi**: Continua automaticamente a 4f.3 (Squash Merge)
- **[R] Review**: **STOP** completo
  - User ispeziona screenshots manualmente
  - User testa app in locale (se serve)
  - User comunica feedback/modifiche
  - Riprendi con fix o procedi

##### Step 4: Logging

Log checkpoint outcome in progress.yaml:

```yaml
milestones:
  - id: M1
    frontend_layout_checkpoints:
      - block_id: [block-name]
        screens_count: N
        screenshots: ["screen-a.png", "screen-b.png", "screen-c.png"]
        user_action: "proceed"  # proceed | review_stop
        timestamp: "[ISO-8601]"
```

### Configuration

```yaml
# project-config.yaml
develop:
  validations:
    frontend_layout_check:
      enabled: true              # Default: true
      blocking: false            # Default: false (REVIEW, non-blocking)
      frequency: 3               # Ogni 3 schermate
      screenshot_tool: "playwright" # playwright | puppeteer | manual
      screenshot_format: "png"   # png | jpg
      full_page: true            # Screenshot full page o viewport
      checks:                    # Checklist per user
        - responsive
        - accessibility
        - branding
        - loading_states
        - error_states
      on_review_stop:
        save_state: true         # Salva stato blocco per resume
        notify_user: true
```

**Tipo**: REVIEW (non-blocking) - notifica user ma continua automaticamente se user non richiede stop.

**Effort**: ~30s per checkpoint (screenshot generation automatico)

**Benefits**:
- ✅ **Early visual feedback** (ogni N schermate, non solo a milestone end)
- ✅ **Automatic screenshots** (zero manual effort se tutto OK)
- ✅ **Progressive validation** (layout issues trovati progressivamente)
- ✅ **Non-blocking** (continua automaticamente se user non interviene)
- ✅ **Resumable** (può fermarsi e riprendere senza perdere progresso)

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

### Pre-flight: E2E Framework Validation

**Obiettivo**: Verificare che Playwright/E2E framework funzioni PRIMA di eseguire full suite. Previene investire tempo su suite completa se framework broken.

**Consulta `validation-checkpoints.md` per dettagli completi.**

#### Step 1: Check Sample Test Exists

Verifica se sample test esiste:

```bash
# Per Playwright
test -f e2e/sample.spec.ts || test -f tests/e2e/sample.spec.ts

# Per Patrol (Flutter)
test -f integration_test/sample_test.dart
```

Se **non esiste**: Genera sample test automaticamente (vedi Step 2).

#### Step 2: Generate Sample Test (se mancante)

**Template Playwright** (Node.js/Frontend):

```typescript
// e2e/sample.spec.ts
import { test, expect } from '@playwright/test';

test.describe('E2E Framework Check @framework-check', () => {
  test('navigation works', async ({ page }) => {
    await page.goto('/');
    expect(page.url()).toContain('/');
    const title = await page.title();
    expect(title).toBeTruthy();
  });

  test('basic interaction works', async ({ page }) => {
    await page.goto('/');
    // Click first button/link found
    const button = page.locator('button, a').first();
    if (await button.count() > 0) {
      await button.click();
      // Verify page changed or action happened
      await page.waitForTimeout(500);
    }
    expect(true).toBe(true); // Framework can execute
  });
});
```

**Template Patrol/Flutter**:

```dart
// integration_test/sample_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

void main() {
  patrolTest('E2E Framework Check', ($) async {
    await $.pumpWidgetAndSettle(MyApp());

    // Navigation works
    expect(find.byType(MaterialApp), findsOneWidget);

    // Basic interaction works
    final firstButton = find.byType(ElevatedButton).first;
    if (firstButton.evaluate().isNotEmpty) {
      await $.tap(firstButton);
    }

    expect(true, true); // Framework can execute
  });
}
```

Salva sample test nel path appropriato.

#### Step 3: Run Sample Test

Esegui SOLO il sample test (non full suite):

```bash
# Playwright
npx playwright test --grep="@framework-check"

# Patrol (Flutter)
patrol test integration_test/sample_test.dart
```

**Timeout**: 30 secondi (sample test deve essere veloce).

#### Step 4: Analyze Result

**PASS** (exit code 0):
```
✅ E2E Framework Validation: PASSED

Sample tests:
- navigation works: ✅ PASS (234ms)
- basic interaction works: ✅ PASS (187ms)

E2E framework OK. Proceeding with full suite.
```

→ Procedi automaticamente a Step 1 (Environment Verification).

**FAIL** (exit code non-0):
```
❌ E2E Framework Validation: FAILED

Sample test failures:
- navigation works: FAIL - Error: page.goto: net::ERR_CONNECTION_REFUSED
- basic interaction works: SKIPPED (dependency failed)

Possible causes:
1. App not running (start dev server: npm run dev)
2. Wrong base URL in playwright.config.ts
3. Missing Playwright browsers (run: npx playwright install)
4. Port conflict (check if port already in use)

Troubleshooting steps:
1. Verify app is running: curl http://localhost:[PORT]
2. Check playwright.config.ts baseURL matches app URL
3. Install browsers if needed: npx playwright install chromium
4. Check error logs above for specific issues

Action required: Fix framework issues, then re-run /develop
```

→ **STOP** completo. User deve risolvere framework issues prima di procedere.

#### Step 5: Configuration

```yaml
# project-config.yaml
develop:
  validations:
    e2e_framework_validation:
      enabled: true                  # Default: true
      blocking: true                 # Default: true (STOP se fail)
      sample_test_path: "e2e/sample.spec.ts" # Path sample test
      auto_generate_sample: true     # Genera se mancante
      sample_test_timeout: 30000     # 30 secondi
      framework: "playwright"        # playwright | patrol | cypress
```

**Tipo**: BLOCKING - E2E suite NON può eseguire se framework broken.

**Effort**: ~5-10s (run 2 sample tests, automatico)

**Benefits**:
- ✅ **Verifica framework OK** prima di investire tempo su full suite
- ✅ **Auto-generate sample** se mancante (zero setup manuale)
- ✅ **Clear troubleshooting** (error messages con fix steps)
- ✅ **Fast feedback** (~5-10s vs 1-2 min full suite)
- ✅ **Prevents waste** (non esegue 50 test se framework broken)

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
