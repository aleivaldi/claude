# Glossario Framework

Terminologia standard del framework. Usa SEMPRE questi termini consistentemente.

---

## Workflow e Processi

### Brief
**Definizione**: Documento input iniziale con requisiti progetto (appunti, trascrizioni meeting).
**File**: `brief.md` (input utente), `brief-structured.md` (output strutturato)
**Skill**: generating-structured-brief

### Brief Strutturato
**Definizione**: Brief formalizzato con sezioni standard (problema, utenti, obiettivi, funzionalità, scope MVP).
**File**: `brief-structured.md`
**Quando**: Dopo generating-structured-brief, prima di user-stories o sitemap

### User Stories
**Definizione**: Requisiti funzionali dal punto di vista utente ("Come [ruolo], voglio [azione] per [beneficio]").
**File**: `user-stories-[progetto].md` o multi-file per area
**Formato ID**: `US-[AREA]-[NUM]` (es. US-AUTH-001)
**Skill**: user-stories-generator

### Sitemap
**Definizione**: Struttura navigazione applicazione (pagine, gerarchia, route).
**File**: `docs/frontend-specs/sitemap.md`
**Focus**: QUALI pagine, COME organizzate (NON dettagli UI)
**Skill**: sitemap-generator

### Architecture
**Definizione**: Design sistema (componenti, tech stack, data model, protocolli, user flows).
**File**: `docs/architecture/*.md` (overview, tech-stack, data-model, user-flows)
**Skill**: architecture-designer
**Fasi**: 6 fasi con 4 checkpoint

### API Signature
**Definizione**: Contratto API (endpoints, metodi HTTP, request/response schemas).
**File**: `docs/api-specs/api-signature.md`
**Focus**: COSA espone (NON come implementa)
**Skill**: api-signature-generator
**Prerequisito**: Architecture approvata

---

## Checkpoint

### Checkpoint
**Definizione**: Punto controllo workflow dove si richiede approvazione prima di procedere.
**Tipi**:
- **BLOCKING**: STOP, attendi approvazione esplicita
- **REVIEW**: Notifica ma continua automaticamente

### Checkpoint Bloccante (BLOCKING)
**Comportamento**: Presenta stato, usa AskUserQuestion, ATTENDI risposta, NON procedi senza approvazione.
**Esempi**: sitemap, architecture_overview, tech_stack_choice, data_model, api_signature, milestone_complete

### Checkpoint Review (REVIEW)
**Comportamento**: Notifica utente ma continua automaticamente senza attendere.
**Esempi**: frontend_style, sync_point, test_plan

### Checkpoint Standard
Lista checkpoint framework:
- `brief`: Brief strutturato completo
- `user_stories`: User stories definite
- `sitemap`: Struttura pagine approvata
- `architecture_overview`: Design componenti sistema
- `tech_stack_choice`: Tecnologie scelte
- `data_model`: Schema database approvato
- `user_flows`: Flussi utente critici
- `api_signature`: Contratto API definito
- `milestone_complete`: Milestone implementato
- `feature_complete`: Feature complete
- `e2e_complete`: Test E2E passano
- `release`: Pronto per produzione

---

## Implementazione

### Milestone
**Definizione**: Unità implementazione (raggruppamento logico feature/tasks).
**File**: `progress.yaml`
**Struttura**: id, name, status, backend/frontend/tests tasks
**Skill**: develop

### Feature
**Definizione**: Funzionalità utente specifica (può span multiple milestones).
**Scope**: Implementazione + tests + review

### Task
**Definizione**: Unit lavoro granulare dentro milestone.
**Tipi**: backend task, frontend task, test task
**Status**: pending, in_progress, completed

### Sync Point
**Definizione**: Punto sincronizzazione quando backend e frontend completano lavoro parallelo.
**Uso**: In develop skill quando modalità PARALLELO

---

## Agenti

### Agent / Agente
**Definizione**: Subprocess specializzato invocato con Task tool.
**Formato**: wshobson style (Capabilities, Behavioral Traits, Workflow Position)
**Esempi**: backend-implementer, frontend-implementer, code-reviewer, fixer, test-writer

### Orchestrator
**Definizione**: Agent che coordina altri agenti (es. develop skill, project-manager agent).

### Implementer
**Definizione**: Agent che scrive codice (backend-implementer, frontend-implementer, mobile-implementer).

### Reviewer
**Definizione**: Agent che analizza codice (code-reviewer, security-auditor).

### Fixer
**Definizione**: Agent che corregge issues trovati da reviewer (max 3 tentativi).

---

## Parallelizzazione

### Blocco (Block)
**Definizione**: Unita' funzionale coesa nel workflow develop. Ogni blocco ha il proprio ciclo: impl+unit test -> commit WIP -> review -> fix -> sync con contract test -> run ALL test -> squash -> completo.
**Esempi**: auth-service, device-crud, login-ui, admin-panel
**Skill**: develop

### Dependency DAG
**Definizione**: Grafo aciclico diretto delle dipendenze tra blocchi. Determina ordine esecuzione.
**Regola**: Blocchi senza dipendenze reciproche eseguono in parallelo.

### Track 1 (Implementazione + Unit Test + Review)
**Definizione**: Percorso dentro un blocco: implementer (codice + unit test interni) -> commit WIP -> code-reviewer -> fixer (loop max 3x) -> commit fix.
**Agenti**: backend-implementer o frontend-implementer, code-reviewer, fixer
**Unit test**: L'implementer scrive unit test per logica interna (helper, algoritmi, business logic). Possono rompersi con refactoring.

### Track 2 (Contract/Integration Test)
**Definizione**: Percorso dentro un blocco: test-writer scrive contract/integration test basandosi su contratti/interfacce pubbliche (NOT implementazione interna). Esegue in parallelo con Track 1.
**Agenti**: test-writer
**Principio**: Test stabili anche se review modifica dettagli implementativi (spirito TDD).

### Focused Review
**Definizione**: Code review leggera eseguita SOLO sui file toccati dal fixer dopo test failure. Verifica che il fix non introduca nuovi problemi senza ripetere full review.

### Block Decomposition
**Definizione**: Fase 3 del workflow develop. Milestone viene decomposto in blocchi funzionali con dependency DAG. Soggetto a checkpoint bloccante per approvazione utente.

### Parallelismo a Due Livelli
**Definizione**: Architettura develop skill con parallelismo tra blocchi (blocchi indipendenti simultanei) e dentro blocco (Track 1 + Track 2 simultanei).

### Commit Strategy per Blocco
**Definizione**: Commit WIP dopo implementazione (prima della review), commit fix dopo ogni correzione, squash in singolo commit pulito `feat(scope)` a fine blocco.
**Vantaggio**: Lavoro salvato immediatamente, rollback facile, reviewer lavora su diff preciso.

---

## File e Struttura

### Specs
**Definizione**: Specifications approvate che guidano implementazione.
**Tipi**:
- Frontend specs (sitemap, screen inventory)
- API specs (api-signature, OpenAPI)
- Architecture specs (overview, tech-stack, data-model)

### Draft
**Definizione**: File intermedio in attesa approvazione (suffisso `-draft.md`).
**Pattern**: Genera draft → checkpoint → approva → rinomina rimuovendo `-draft`
**Esempi**: `sitemap-draft.md`, `api-signature-draft.md`, `architecture-overview-draft.md`

### Template
**Definizione**: File template con placeholder per generazione documenti.
**Location**: `templates/` directory dentro skill
**Uso**: Popolato da skill per creare output

### Reference File
**Definizione**: File dettagli referenziato da SKILL.md (progressive disclosure).
**Pattern**: SKILL.md < 500 righe, dettagli in reference files
**Esempi**: `phase_1.md`, `defaults.md`, `parallelization-logic.md`

---

## File Standard Progetto

### project-config.yaml
**Location**: Root progetto
**Contenuto**: Configurazione workflow (checkpoint attivi/bloccanti, skip phases, team)
**Skill**: project-setup

### progress.yaml
**Location**: Root progetto
**Contenuto**: Stato implementazione (milestones, checkpoint completati, commit)
**Auto-generato**: Aggiornato da develop skill

### CLAUDE.md
**Location**: Root progetto e subproject
**Contenuto**: Overview progetto, convenzioni, istruzioni per Claude
**Skill**: project-scaffolder, claudeforge-skill

---

## Best Practices

### MVP
**Definizione**: Minimum Viable Product - subset funzionalità core per validare idea.
**Filosofia**: Semplice > complesso, off-shelf > custom, no future-proofing

### Progressive Disclosure
**Definizione**: Architettura SKILL.md con overview concisa (< 500 righe) + dettagli in file reference.
**Pattern**: SKILL.md referenzia, reference files forniscono dettagli

### Assume Claude is Smart
**Principio**: NON spiegare concetti base che Claude già conosce. Focus su domain-specific info.

### Scope Boundary
**Definizione**: Definire esplicitamente cosa FA e NON FA una skill.
**Importanza**: Previene scope creep, chiarisce responsabilità

---

## Terminologia Evitare

### ❌ DA NON USARE
- "Frontend specs" quando intendi "sitemap" (ambiguo)
- "Requirements" quando intendi "user stories" (più preciso)
- "Documentation" generico - specifica tipo (API docs, architecture docs, README)
- "Story" alternato con "user story" - usa sempre "user story"
- "US" senza contesto - sempre "user story (US-XXX-YYY)" prima menzione

### ✅ USA INVECE
- **Sitemap** per struttura navigazione
- **User Stories** per requisiti funzionali
- **API Signature** per contratto API (non "API specs" generico)
- **Architecture** per design sistema
- **Checkpoint** per validation points (non "approval point", "review point")
- **Milestone** per unità implementazione (non "iteration", "sprint")

---

## Quick Reference

| Termine | File | Skill | Fase |
|---------|------|-------|------|
| Brief Strutturato | brief-structured.md | generating-structured-brief | Discovery |
| User Stories | user-stories-[progetto].md | user-stories-generator | Requirements |
| Sitemap | docs/frontend-specs/sitemap.md | sitemap-generator | Frontend Specs |
| Architecture | docs/architecture/*.md | architecture-designer | Architecture |
| API Signature | docs/api-specs/api-signature.md | api-signature-generator | API Design |
| Milestone | progress.yaml | develop | Implementation |
| Checkpoint | progress.yaml | tutti | Validation |

---

## Uso nel Codice e Documentazione

Quando scrivi docs, commenti, o comunicazioni:

✅ **CORRETTO**:
```
Dopo aver approvato la sitemap (checkpoint sitemap), procedo con
architecture-designer che genera l'architettura in 6 fasi con 4 checkpoint.
```

❌ **ERRATO** (terminologia inconsistente):
```
Dopo approval della struttura pagine, faccio il design architetturale
che crea i documenti architettura con vari review point.
```

---

## Estensioni Future

Per aggiungere termini:
1. Definizione chiara
2. File/location associati
3. Skill che lo gestisce
4. Quando usarlo vs alternative
5. Esempio uso corretto
