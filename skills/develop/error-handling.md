# Error Handling: Recovery Procedures

## Block Failure

### Scenario
Un blocco fallisce durante l'esecuzione (implementazione, review, o test).

### Principi
1. **Isolation**: Un blocco fallito NON blocca blocchi indipendenti
2. **Propagation**: Un blocco fallito BLOCCA blocchi che dipendono da esso
3. **Continuity**: L'orchestratore continua a eseguire blocchi non impattati

### Detection
```
Block [id]: FAILED
  Reason: [Track 1 failed | Tests failed after 3 attempts | Build broken]
  Stage: [implementation | review | test_run]
```

### Recovery Actions

1. **Classifica Impatto**
   ```python
   failed_block = "auth-service"

   # Blocchi direttamente dipendenti
   blocked = [b for b in blocks if failed_block in b.dependencies]
   # -> ["user-profile", "admin-panel"]

   # Blocchi indipendenti (continuano)
   unaffected = [b for b in blocks if failed_block not in b.dependencies]
   # -> ["device-crud", "login-ui", "device-dashboard"]
   ```

2. **Marca blocchi impattati**
   ```yaml
   blocks:
     auth-service:
       status: failed
       reason: "Review fix failed after 3 attempts"
       stage: review
     user-profile:
       status: blocked_by_failure
       blocked_by: auth-service
     admin-panel:
       status: blocked_by_failure
       blocked_by: auth-service
   ```

3. **Continua blocchi indipendenti**
   - L'orchestratore procede con blocchi non impattati
   - Log chiaro di cosa continua e cosa e' bloccato

4. **Notifica utente** (alla fine del turno o quando tutti i blocchi indipendenti sono completati)
   ```
   Blocchi completati: 3/6
   Blocchi falliti: 1 (auth-service)
   Blocchi bloccati: 2 (user-profile, admin-panel)

   Dettaglio failure:
     auth-service: Review fix fallito dopo 3 tentativi
       Stage: review
       File: src/services/auth.ts:45
       Issue: [descrizione]

   Opzioni:
   - [R] Retry blocco fallito
   - [M] Modifica e retry
   - [S] Skip blocco (e dipendenti)
   - [A] Abort milestone
   ```

5. **Gestione Risposta**
   ```
   [R] Retry: Re-esegue il blocco dall'inizio (impl -> review -> test)
   [M] Modifica: Utente fix manuale, poi /develop resume
   [S] Skip: Marca blocco + dipendenti come skipped, continua
   [A] Abort: Salva stato, STOP completo
   ```

### Salvataggio Stato per Resume

```yaml
# progress.yaml
current_milestone:
  id: M1
  status: partial
  blocks:
    - id: auth-service
      status: failed
      stage: review
      last_error: "..."
    - id: device-crud
      status: completed
    - id: login-ui
      status: completed
    - id: device-dashboard
      status: completed
    - id: user-profile
      status: blocked_by_failure
    - id: admin-panel
      status: blocked_by_failure
```

### Resume dopo Fix

```
User: /develop resume

[Leggi progress.yaml]
[Identifica blocchi failed/blocked]
[Verifica se fix applicato]

Se auth-service ora compilabile:
  -> Re-esegui auth-service (impl gia' fatto, riparti da review o test)
  -> Se OK: sblocca user-profile, admin-panel
  -> Esegui blocchi sbloccati
```

---

## Build Failure

### Scenario
Build fallisce dopo modifiche implementate da agente.

### Detection
```
Bash: npm run build
Exit code: 1
Error: [messaggio errore compilazione]
File: [file:linea]
```

### Recovery Actions

1. **Analisi Errore**
   ```
   Tipo errore: [Syntax / Type / Import / Runtime]
   File coinvolto: [path]
   Linea: [numero]
   Messaggio: [dettaglio]
   ```

2. **Rollback Automatico**
   ```bash
   # Se in git repo
   git diff > /tmp/failed_changes.patch
   git checkout .

   # Verifica build funziona
   npm run build
   ```

3. **Retry con Fix**
   ```
   Task: fixer
   Prompt: |
     Build fallito con errore:
     [messaggio errore completo]

     File: [file:linea]

     Analizza errore e fixa minimalmente.
     NON modificare altro codice.

     Patch originale salvata in: /tmp/failed_changes.patch
   ```

4. **Verifica Fix**
   ```bash
   npm run build

   if success:
     Procedi
   else:
     Incrementa retry_count
     if retry_count < 3:
       Goto step 3
     else:
       Goto "Max Retry Exceeded"
   ```

### Quando Rollback

- ✅ Build funzionava prima delle modifiche
- ✅ Errore chiaramente causato da modifiche recenti
- ❌ Non rollback se build già rotto prima

---

## Max Retry Exceeded

### Scenario
Fix automatico fallito dopo 3 tentativi.

### Actions

1. **Salva Stato**
   ```yaml
   # progress.yaml
   current_milestone:
     id: M1
     status: blocked
     blocker:
       type: max_retry_exceeded
       issue: [descrizione issue]
       file: [file:linea]
       attempts: 3
       last_error: [ultimo errore]
   ```

2. **Notifica Utente**
   ```
   ⚠️ Fix automatico fallito dopo 3 tentativi.

   Issue: [descrizione]
   File: [file:linea]

   Ultimo errore:
   [messaggio errore]

   Tentativi fatti:
   1. [cosa provato]
   2. [cosa provato]
   3. [cosa provato]

   Intervento manuale richiesto.

   Dopo fix manuale, riavvia con:
   /develop resume
   ```

3. **STOP Execution**
   - Non procedere oltre
   - Stato salvato per ripresa
   - Attendi intervento umano

### Resume Workflow

```
User: /develop resume

[Leggi progress.yaml]
[Verifica issue fixato]

if build_success:
  Riprendi da checkpoint salvato
else:
  Segnala issue ancora presente
```

---

## Agent Failure

### Scenario
Agente specializzato non completa task.

### Detection
```
Task: [agent_name]
Status: failed
Output: [ultimo output agente]
Error: [se presente]
Exit: non-zero or timeout
```

### Recovery Actions

1. **Analisi Fallimento**
   ```
   Motivo: [Timeout / Error / Incomplete]

   Se Timeout:
     → Agente impiegato troppo tempo (>10min)
     → Possibile loop infinito o task troppo complesso

   Se Error:
     → Errore esplicito da agente
     → Analizza traceback/messaggio

   Se Incomplete:
     → Agente terminato senza completare deliverable atteso
   ```

2. **Retry Automatico (Attempt 1)**
   ```
   [Attendi 30 secondi]

   Task: [same_agent]
   Prompt: [stesso prompt + "Tentativo 2/3"]
   Timeout: +5min (extended)
   ```

3. **Retry con Context Extra (Attempt 2)**
   ```
   Task: [same_agent]
   Prompt: |
     [prompt originale]

     NOTA: Tentativo precedente fallito con:
     [errore/output parziale]

     Procedi considerando questo.
     Tentativo 3/3 - ultimo tentativo.
   ```

4. **Escalation (Attempt 3 Failed)**
   ```
   ⚠️ Agente [nome] fallito 3 volte.

   Task: [descrizione]
   Ultimi errori:
   1. [errore 1]
   2. [errore 2]
   3. [errore 3]

   Opzioni:
   - [M] Modifica task (semplifica scope)
   - [S] Skip questo task
   - [A] Abort milestone
   ```

### Timeout Tuning

| Agent | Default Timeout | Extended Timeout |
|-------|----------------|------------------|
| backend-implementer | 10min | 15min |
| frontend-implementer | 10min | 15min |
| test-writer | 5min | 8min |
| code-reviewer | 3min | 5min |
| fixer | 5min | 8min |

---

## Prerequisito Mancante

### Scenario
Utente invoca `/develop` ma checkpoint bloccanti non completati.

### Detection
```
Fase 2: Verify Prerequisites

checkpoints_required:
  - brief ✅
  - sitemap ✅
  - architecture_overview ❌ MANCANTE
  - api_signature ❌ MANCANTE
```

### Actions

1. **Identifica Mancanti**
   ```
   Prerequisiti mancanti:

   - [ ] architecture_overview - docs/architecture/overview.md non trovato
   - [ ] api_signature - docs/api-specs/api-signature.md non trovato
   ```

2. **Suggerisci Skill**
   ```
   Per completare prerequisiti, esegui:

   1. /architecture-designer
      → Crea architettura sistema (componenti, tech stack, data model)
      → Output: docs/architecture/*.md

   2. /api-signature-generator
      → Genera contratto API (endpoints, schemas)
      → Output: docs/api-specs/api-signature.md

   Poi riavvia: /develop
   ```

3. **STOP Execution**
   - Non procedere senza prerequisiti
   - Prerequisiti sono critici per implementazione corretta

### Bypass (Solo se Giustificato)

```
Se utente insiste di procedere senza prerequisiti:

AskUserQuestion:
  "Prerequisiti mancanti. Procedere comunque è rischioso.

   Conseguenze:
   - Implementazione potrebbe non seguire architettura
   - API potrebbe non essere consistente
   - Probabilità alto refactoring successivo

   Procedi comunque?"

   Options:
   - No (Consigliato) → STOP
   - Sì, a mio rischio → Procedi con warning
```

---

## Git Conflict

### Scenario
Commit fallisce per conflitti git.

### Detection
```bash
git add .
git commit -m "..."

Error: Conflict detected
Files in conflict:
  - src/file1.ts
  - src/file2.ts
```

### Recovery Actions

1. **Analisi Conflitto**
   ```bash
   git status
   git diff

   # Identifica origine conflitto
   # - Altro developer ha pushato
   # - Branch diverged
   # - File modificato esternamente
   ```

2. **Strategia Resolution**
   ```
   Se conflitto semplice (poche righe):
     → Auto-resolve preferendo modifiche locali
     → Verifica con build+tests

   Se conflitto complesso (molte righe, logic conflicts):
     → Notifica utente
     → Chiedi strategia merge
     → STOP automatic resolution
   ```

3. **Auto-Resolution (Safe Cases)**
   ```bash
   # Solo se:
   # - Conflitto su imports/formatting
   # - Modifiche non-overlapping
   # - Tests passano dopo resolution

   git checkout --ours [file]  # Prendi nostra versione
   git add [file]
   npm run test

   if tests_pass:
     git commit
   else:
     git reset --hard
     Notifica utente
   ```

4. **Manual Resolution Required**
   ```
   ⚠️ Git conflict rilevato - risoluzione manuale richiesta.

   Files in conflict:
   - [file1]: [descrizione modifiche]
   - [file2]: [descrizione modifiche]

   Risolvi conflitti e poi:
   git add .
   /develop resume
   ```

### Feature Branch Merge Conflict

Conflitto durante squash merge di feature branch su develop.

**Causa**: un altro blocco ha mergiato su develop mentre questo blocco lavorava sul proprio feature branch.

**Recovery**:
```bash
# 1. Rebase feature branch su develop aggiornato
git checkout feature/[block-scope]
git rebase develop

# 2a. Se rebase riesce:
git checkout develop
git merge --squash feature/[block-scope]
git commit -m "feat([scope]): implement [block-name] ..."
git branch -d feature/[block-scope]

# 2b. Se rebase fallisce:
git rebase --abort
# STOP blocco, notifica utente
```

**Isolamento blocchi paralleli**: blocchi paralleli lavorano su branch separati, quindi non hanno conflitti tra loro. I conflitti emergono solo al merge su develop, che e' serializzato.

**Blocchi dipendenti**: il blocco dipendente parte da develop gia' aggiornato con il merge del blocco prerequisito, quindi non ha conflitti con esso.

---

### Feature Branch Cleanup on Block Failure

Quando un blocco fallisce, gestione del feature branch:

| Scenario | Azione branch |
|----------|---------------|
| Block failed, retry | Riusa branch esistente (`git checkout feature/[scope]`) |
| Block failed, skip | Cancella branch (`git branch -D feature/[scope]`) |
| Block failed, debug | Branch NON cancellato (utente puo' ispezionare) |
| Block failed, abort milestone | Tutti i feature branch non mergiati restano per debug |

```bash
# Su retry: riusa branch
git checkout feature/[block-scope]
# Continua dal punto di fallimento

# Su skip: cleanup
git checkout develop
git branch -D feature/[block-scope]
```

---

## Test Failure

### Scenario
Tests falliscono dopo implementazione.

### Detection
```bash
npm run test

Exit code: 1
Failed tests: 3/45
  - auth.service.spec.ts: "should validate JWT"
  - user.controller.spec.ts: "should return 404"
  - integration/api.spec.ts: "POST /users"
```

### Recovery Actions

1. **Categorizza Failures**
   ```
   Tipo 1: Test Obsoleto (modifica intenzionale comportamento)
   Tipo 2: Regressione (bug introdotto)
   Tipo 3: Test Flaky (timing/race condition)
   ```

2. **Tipo 1: Test Obsoleto**
   ```
   Task: test-writer
   Prompt: |
     Questi tests falliscono dopo implementazione feature:
     [lista tests falliti]

     Analizza se tests sono obsoleti (comportamento cambiato
     intenzionalmente) o se c'è regressione.

     Se obsoleti: aggiorna tests per riflettere nuovo comportamento.
     Se regressione: segnala per fix.
   ```

3. **Tipo 2: Regressione**
   ```
   Task: fixer
   Prompt: |
     Tests falliti indicano regressione:
     [dettaglio tests e asserzioni fallite]

     Fixa codice per far passare tests.
     NON modificare tests (il comportamento atteso è corretto).
   ```

4. **Tipo 3: Flaky**
   ```
   Retry test 3x:

   npm run test -- --testNamePattern="[test_name]"

   Se passa almeno 2/3:
     → Flaky, aggiungi a watchlist
   Se fail sempre:
     → Non flaky, vedi Tipo 2
   ```

5. **Max Attempts**
   ```
   Se dopo 3 fix attempts tests ancora falliscono:
     → Salva stato
     → Notifica utente con dettagli
     → STOP
   ```

---

## Dependency Missing

### Scenario
Codice richiede dipendenza non installata.

### Detection
```
Error: Cannot find module '@prisma/client'
Error: Package 'axios' not found
```

### Recovery Actions

1. **Install Automatico**
   ```bash
   # Identifica package manager
   if exists("package-lock.json"):
     npm install [package]
   elif exists("yarn.lock"):
     yarn add [package]
   elif exists("pnpm-lock.yaml"):
     pnpm add [package]
   ```

2. **Verifica Post-Install**
   ```bash
   npm run build

   if success:
     Procedi
   else:
     Analizza nuovo errore
   ```

3. **Se Install Fallisce**
   ```
   Package [nome] non trovato o incompatibile.

   Possibili cause:
   - Package non esiste in registry
   - Versione non disponibile
   - Conflitto dipendenze

   Segnala utente per resolution manuale.
   ```

---

## Best Practices Error Handling

1. **Fail Fast** - Rileva errori il prima possibile
2. **Rollback Safe** - Sempre possibile tornare a stato funzionante
3. **Max 3 Retry** - Non loop infiniti
4. **Salva Stato** - progress.yaml sempre aggiornato
5. **Notifica Chiara** - Utente capisce cosa è andato storto
6. **Actionable** - Indica esattamente cosa fare per risolvere
7. **No Silent Failures** - Ogni errore loggato e reportato
