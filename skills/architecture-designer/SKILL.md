---
name: architecture-designer
description: Progetta architettura sistema progressivamente. Processo in 6 fasi con checkpoint multipli. Definisce tech stack, protocolli comunicazione, data model, componenti. Output architecture/*.md come base per API signature e implementazione.
---

# Architecture Designer

## Il Tuo Compito

Progettare l'architettura del sistema in modo **progressivo** con checkpoint per ogni decisione critica:
1. Overview (componenti, confini)
2. Tech Stack (linguaggi, framework, database)
3. Protocolli Comunicazione (REST/GraphQL/WebSocket/MQTT/gRPC)
4. Data Model (entità, relazioni)
5. User Flows critici

**Prerequisito**: Sitemap approvata (checkpoint `sitemap` completato).

**Output**: `docs/architecture/*.md` - documenti checkpoint per approvazione prima di API signature.

---

## Materiali di Riferimento

**Template Fasi**:
- `phases/overview-componenti-template.md` - Template Fase 2 (componenti sistema)
- `phases/tech-stack-template.md` - Template Fase 3 (scelte tecnologiche)
- `phases/data-model-template.md` - Template Fase 4 (schema database)
- `phases/user-flows-template.md` - Template Fase 5 (flussi critici)

**Reference**:
- `reference/error-handling.md` - Gestione errori actionable per ogni fase

---

## Workflow: 6 Fasi con Checkpoint Multipli

```
Fase 1: Analisi Requisiti     → Legge sitemap/brief, identifica requisiti non-funzionali
Fase 2: Overview Componenti   → Crea architecture-overview-draft.md
        >>> CHECKPOINT: ARCHITECTURE_OVERVIEW <<<
Fase 3: Tech Stack            → Crea tech-stack-draft.md
        >>> CHECKPOINT: TECH_STACK_CHOICE <<<
Fase 4: Data Model            → Crea data-model-draft.md
        >>> CHECKPOINT: DATA_MODEL <<<
Fase 5: User Flows            → Crea user-flows-draft.md
        >>> CHECKPOINT: USER_FLOWS <<<
Fase 6: Finalizzazione        → Consolida in docs/architecture/
```

---

## Fase 1: Analisi Requisiti

### Obiettivo
Raccogliere requisiti funzionali e non-funzionali per informare decisioni architetturali.

### Azioni

1. **Verifica prerequisito**: Sitemap approvata
   ```
   Cerca: docs/frontend-specs/sitemap.md
   Se non esiste: "Esegui prima /sitemap-generator"
   ```

2. **Leggi documenti**:
   - `docs/frontend-specs/sitemap.md`
   - `docs/brief-structured.md` o `brief.md`
   - `project-config.yaml` (se esiste)

3. **Identifica requisiti non-funzionali** (chiedi se non specificati):

   | Requisito | Domanda | Impatto |
   |-----------|---------|---------|
   | Scala | Quanti utenti/richieste? | Architettura, DB |
   | Real-time | Servono aggiornamenti live? | WebSocket/MQTT |
   | Offline | App deve funzionare offline? | Sync strategy |
   | Multi-tenant | Più organizzazioni? | DB schema, auth |
   | Compliance | GDPR, HIPAA, etc? | Storage, audit |

4. **Comunica sintesi**:
   ```
   Analisi completata:

   Requisiti identificati:
   - Scala: MVP (< 1000 utenti)
   - Real-time: Sì (status dispositivi)
   - Offline: Parziale (cache contenuti)

   Procedo con design architettura.
   ```

---

## Fase 2: Overview Componenti

**Consulta `phases/overview-componenti-template.md` per template completo.**

### Step 2.1: Generate Draft

1. Identifica componenti (Frontend, Backend, Database, Cache, Message broker, External services)
2. Crea `docs/architecture/overview-draft.md` con template

### Step 2.2: Expert Review PRE-checkpoint (NUOVO)

**Obiettivo**: Validazione tecnica automatica PRIMA di presentare all'utente. Riduce intervento umano.

**Consulta `reference/expert-review-protocol.md` per dettagli completi.**

3. **Invoca solution-architect agent** (reviewer DIVERSO da chi ha generato):
   ```
   Task: Rivedi overview-draft.md
   Focus:
   - Component boundaries appropriate?
   - Over-engineering detected?
   - Complexity justified?
   - Missing critical components?
   - Architecture patterns sound?

   Output verdict: APPROVED | CONCERNS | REJECTED
   ```

4. **Gestisci verdict**:
   - **APPROVED**: Procedi a Step 2.3 (Checkpoint User)
   - **CONCERNS**: AskUserQuestion [P]rocedi comunque / [M]odifica → se Modifica: applica fix, rigenera draft, re-review
   - **REJECTED**: Applica fix automatico, rigenera draft, re-review (max 2 cicli), poi escalate a user se ancora REJECTED

5. **Log review outcome** in draft:
   ```markdown
   ## Expert Review

   **Reviewer**: solution-architect
   **Verdict**: APPROVED
   **Comments**: Component boundaries clear, appropriate for MVP scope
   **Reviewed at**: 2026-01-30T10:00:00
   ```

### Step 2.3: Checkpoint User

6. Presenta **CHECKPOINT: ARCHITECTURE_OVERVIEW** con AskUserQuestion
7. Gestisci risposta: Approva → Fase 3, Modifica → Rileggi e ripresenta

---

## Fase 3: Tech Stack

**Consulta `phases/tech-stack-template.md` per template completo e decisioni comuni.**

### Step 3.1: Generate Draft

1. Proponi tech stack basato su requisiti (Frontend, Backend, Database, Protocolli)
2. Crea `docs/architecture/tech-stack-draft.md` con template

### Step 3.2: Expert Review PRE-checkpoint (NUOVO)

**Obiettivo**: Validazione security + architectural fit PRIMA di presentare all'utente.

**Consulta `reference/expert-review-protocol.md` per dettagli completi.**

3. **Invoca security-auditor + solution-architect agents in PARALLELO** (reviewer DIVERSI da chi ha generato):

   **security-auditor**:
   ```
   Task: Rivedi tech-stack-draft.md
   Focus:
   - Framework security vulnerabilities?
   - Known CVEs in proposed versions?
   - Weak authentication/authorization?
   - Insecure protocol choices?
   - Missing security libraries?

   Output verdict: APPROVED | CONCERNS | REJECTED
   ```

   **solution-architect**:
   ```
   Task: Rivedi tech-stack-draft.md
   Focus:
   - Architectural fit with components?
   - Technology maturity appropriate?
   - Team expertise considerations?
   - Integration complexity?
   - Maintenance burden?

   Output verdict: APPROVED | CONCERNS | REJECTED
   ```

4. **Gestisci verdicts** (combinati):
   - **Entrambi APPROVED**: Procedi a Step 3.3 (Checkpoint User)
   - **Uno CONCERNS**: AskUserQuestion con dettagli concerns + opzioni [P]rocedi / [M]odifica
   - **Uno REJECTED**: Applica fix automatico, rigenera draft, re-review (max 2 cicli), poi escalate a user

5. **Log review outcomes** in draft:
   ```markdown
   ## Expert Reviews

   ### Security Review
   **Reviewer**: security-auditor
   **Verdict**: APPROVED
   **Comments**: No known vulnerabilities, JWT implementation sound
   **Reviewed at**: 2026-01-30T10:00:00

   ### Architecture Review
   **Reviewer**: solution-architect
   **Verdict**: APPROVED
   **Comments**: Stack aligns with MVP goals, appropriate complexity
   **Reviewed at**: 2026-01-30T10:00:00
   ```

### Step 3.3: Checkpoint User

6. Presenta **CHECKPOINT: TECH_STACK_CHOICE** con AskUserQuestion
7. Gestisci risposta: Approva → Fase 4, Modifica → Rileggi e ripresenta

---

## Fase 4: Data Model

**Consulta `phases/data-model-template.md` per template completo e best practices.**

### Step 4.1: Generate Draft

1. Identifica entità da sitemap e requisiti, definisci relazioni
2. Crea `docs/architecture/data-model-draft.md` con template (ERD, tabelle, indici, convenzioni)

### Step 4.2: Expert Review PRE-checkpoint (NUOVO)

**Obiettivo**: Validazione database + security PRIMA di presentare all'utente.

**Consulta `reference/expert-review-protocol.md` per dettagli completi.**

3. **Invoca database-architect + security-auditor agents in PARALLELO** (reviewer DIVERSI da chi ha generato):

   **database-architect**:
   ```
   Task: Rivedi data-model-draft.md
   Focus:
   - Normalization appropriate (not over/under)?
   - Indexes defined for common queries?
   - Relations correctly modeled?
   - Missing constraints?
   - Query performance concerns?
   - Scalability issues?

   Output verdict: APPROVED | CONCERNS | REJECTED
   ```

   **security-auditor**:
   ```
   Task: Rivedi data-model-draft.md
   Focus:
   - PII fields protected (encryption)?
   - Sensitive data isolation?
   - Audit trail for critical operations?
   - Multi-tenancy isolation (if applicable)?
   - SQL injection vulnerabilities in schema?

   Output verdict: APPROVED | CONCERNS | REJECTED
   ```

4. **Gestisci verdicts** (combinati):
   - **Entrambi APPROVED**: Procedi a Step 4.3 (Checkpoint User)
   - **Uno CONCERNS**: AskUserQuestion con dettagli concerns + opzioni [P]rocedi / [M]odifica
   - **Uno REJECTED**: Applica fix automatico, rigenera draft, re-review (max 2 cicli), poi escalate a user

5. **Log review outcomes** in draft:
   ```markdown
   ## Expert Reviews

   ### Database Review
   **Reviewer**: database-architect
   **Verdict**: APPROVED
   **Comments**: Indexes cover 95% queries, normalization at 3NF appropriate
   **Reviewed at**: 2026-01-30T10:00:00

   ### Security Review
   **Reviewer**: security-auditor
   **Verdict**: APPROVED
   **Comments**: PII encrypted, audit fields present, multi-tenant isolation correct
   **Reviewed at**: 2026-01-30T10:00:00
   ```

### Step 4.3: Checkpoint User

6. Presenta **CHECKPOINT: DATA_MODEL** con AskUserQuestion
7. Gestisci risposta: Approva → Fase 5, Modifica → Rileggi e ripresenta

---

## Fase 5: User Flows Critici

**Consulta `phases/user-flows-template.md` per template completo e flussi tipici.**

### Step 5.1: Generate Draft

1. Identifica flussi critici (max 3-5): Autenticazione + core business flows
2. Crea `docs/architecture/user-flows-draft.md` con template (diagrammi ASCII, passaggi, error cases)

### Step 5.2: Expert Review PRE-checkpoint (NUOVO)

**Obiettivo**: Validazione flow complexity + error handling PRIMA di presentare all'utente.

**Consulta `reference/expert-review-protocol.md` per dettagli completi.**

3. **Invoca solution-architect agent** (reviewer DIVERSO da chi ha generato):
   ```
   Task: Rivedi user-flows-draft.md
   Focus:
   - Flow complexity reasonable?
   - Error handling comprehensive?
   - Bottlenecks detected?
   - Missing critical paths?
   - Recovery scenarios defined?
   - User experience issues?

   Output verdict: APPROVED | CONCERNS | REJECTED
   ```

4. **Gestisci verdict**:
   - **APPROVED**: Procedi a Step 5.3 (Checkpoint User)
   - **CONCERNS**: AskUserQuestion [P]rocedi / [M]odifica → se Modifica: applica fix, rigenera draft, re-review
   - **REJECTED**: Applica fix automatico, rigenera draft, re-review (max 2 cicli), poi escalate a user se ancora REJECTED

5. **Log review outcome** in draft:
   ```markdown
   ## Expert Review

   **Reviewer**: solution-architect
   **Verdict**: APPROVED
   **Comments**: Flows cover critical paths, error handling comprehensive, no bottlenecks
   **Reviewed at**: 2026-01-30T10:00:00
   ```

### Step 5.3: Checkpoint User

6. Presenta **CHECKPOINT: USER_FLOWS** con AskUserQuestion
7. Gestisci risposta: Approva → Fase 6, Modifica → Rileggi e ripresenta

---

## Fase 6: Finalizzazione

### Obiettivo
Consolidare documenti approvati in `docs/architecture/`.

### Azioni

1. **Rinomina** draft files rimuovendo "-draft"
2. **Aggiorna stato** da DRAFT a APPROVATO
3. **Crea index** `docs/architecture/README.md`:

```markdown
# Architecture - [Nome Progetto]

## Documenti

| Documento | Descrizione | Stato |
|-----------|-------------|-------|
| [overview.md](overview.md) | Componenti sistema | ✅ Approvato |
| [tech-stack.md](tech-stack.md) | Tecnologie scelte | ✅ Approvato |
| [data-model.md](data-model.md) | Schema database | ✅ Approvato |
| [user-flows.md](user-flows.md) | Flussi critici | ✅ Approvato |

## Prossimi Step

1. `/api-signature-generator` - Definire contratto API
2. `/project-scaffolder` - Creare struttura repository
```

4. **Comunica completamento**:
```
✅ Architettura completata e approvata.

Documenti in docs/architecture/:
- overview.md
- tech-stack.md
- data-model.md
- user-flows.md

Prossimo step: /api-signature-generator
```

---

## Regole Tool

- ✅ **SEMPRE** Read prima di processare
- ✅ Write per nuovi file
- ✅ AskUserQuestion per checkpoint
- ❌ **MAI** saltare checkpoint
- ❌ **MAI** procedere senza approvazione

---

## Gestione Errori

**Consulta `reference/error-handling.md` per procedure recovery complete.**

Errori gestiti per ogni fase:
- **Fase 1**: Prerequisiti mancanti (sitemap, brief), requisiti ambigui
- **Fase 2**: Architettura over-engineered, tech non standard
- **Fase 3**: Conflitti tecnologie, database choice ambigua
- **Fase 4**: Circular dependencies entità, campi sensibili non protetti
- **Fase 5**: Flow troppo complessi, error handling mancante
- **Fase 6**: File esistenti, progress.yaml locked, checkpoint re-open

---

## Avvio Workflow

1. Verifica prerequisito (sitemap)
2. Fase 1: Analisi requisiti
3. Fase 2-5: Con checkpoint per ognuna
4. Fase 6: Finalizzazione

**Principio**: Architettura determina TUTTO ciò che segue. Ogni checkpoint è critico.
