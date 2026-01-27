# Evaluation 1: Standard Web Application

## Scenario
Progettare architettura per web app standard con autenticazione e CRUD.

## Input

**docs/frontend-specs/sitemap.md** (già approvato):
```markdown
# Sitemap

Pagine:
- /login
- /dashboard
- /users (lista + dettaglio)
- /settings
```

**docs/brief-structured.md**:
```markdown
- Utenti: < 1000 MVP
- Real-time: No
- Offline: No
- Multi-tenant: No
```

### Invocazione
```
/architecture-designer
```

## Expected Behavior

### Fase 1: Analisi Requisiti
- ✅ Verifica sitemap esiste
- ✅ Legge brief
- ✅ Identifica requisiti non-funzionali:
  - Scala: MVP (< 1000 utenti)
  - Real-time: No
  - Offline: No
- ✅ Comunica sintesi e chiede conferma

### Fase 2: Overview Componenti
- ✅ Identifica componenti:
  - Web App (React/Vue)
  - Backend API (REST)
  - Database (relazionale)
- ✅ Crea `docs/architecture/overview-draft.md` con template
- ✅ Presenta **CHECKPOINT: ARCHITECTURE_OVERVIEW**
- ✅ Usa AskUserQuestion per approvazione

### Fase 3: Tech Stack
- ✅ Proponi stack MVP-oriented:
  - Frontend: React + TypeScript
  - Backend: Node.js + Express
  - Database: PostgreSQL
  - Auth: JWT
- ✅ Crea `docs/architecture/tech-stack-draft.md`
- ✅ Presenta **CHECKPOINT: TECH_STACK_CHOICE**
- ✅ Motivazioni chiare per ogni scelta

### Fase 4: Data Model
- ✅ Identifica entità da sitemap:
  - User (per /login, /users)
  - Settings (per /settings)
- ✅ Definisce relazioni
- ✅ Crea `docs/architecture/data-model-draft.md` con ERD
- ✅ Presenta **CHECKPOINT: DATA_MODEL**
- ✅ Convenzioni UUID, timestamps, soft-delete

### Fase 5: User Flows
- ✅ Identifica flussi critici:
  - Autenticazione (login, register, token refresh)
  - User CRUD
- ✅ Crea diagrammi ASCII per ogni flow
- ✅ Crea `docs/architecture/user-flows-draft.md`
- ✅ Presenta **CHECKPOINT: USER_FLOWS**
- ✅ Error cases documentati

### Fase 6: Finalizzazione
- ✅ Rinomina tutti `-draft.md` → `.md`
- ✅ Crea `docs/architecture/README.md` index
- ✅ Comunica completamento
- ✅ Suggerisce prossimo step: `/api-signature-generator`

## Expected Output

### Files Created
```
docs/architecture/
├── README.md
├── overview.md
├── tech-stack.md
├── data-model.md
└── user-flows.md
```

### overview.md Content Check
- ✅ Componenti: Web App, Backend API, Database
- ✅ Diagramma ASCII presente
- ✅ Confini e responsabilità definiti
- ✅ Stato: APPROVATO (non DRAFT)

### tech-stack.md Content Check
- ✅ Frontend, Backend, Data sections
- ✅ Protocolli comunicazione: REST/HTTPS
- ✅ Motivazione per ogni scelta
- ✅ Alternative considerate sezione presente

### data-model.md Content Check
- ✅ ERD presente
- ✅ Tabella users con: id (UUID), email (UNIQUE), password_hash, created_at, updated_at
- ✅ Indici definiti
- ✅ Convenzioni documentate

### user-flows.md Content Check
- ✅ Flow autenticazione con diagramma ASCII
- ✅ Passaggi numerati
- ✅ Error cases con HTTP codes (401, 403, 429)

## Success Criteria

- ✅ Tutte 6 fasi completate in ordine
- ✅ 4 checkpoint presentati e approvati
- ✅ 4 file architettura creati
- ✅ README.md index con link relativi
- ✅ Suggerimento prossimo step corretto
- ✅ Stack MVP-oriented (no over-engineering)

## Pass/Fail Criteria

**PASS se**:
- 4 checkpoint presentati con AskUserQuestion
- File draft → finale dopo approvazione
- Tech stack pragmatico (no tecnologie esotiche)
- Data model con convenzioni standard
- User flows con error handling

**FAIL se**:
- Checkpoint saltati
- File finali senza approvazione
- Over-engineering (microservizi, Kubernetes per MVP)
- Data model senza convenzioni
- User flows senza error cases
