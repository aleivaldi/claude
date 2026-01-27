# Framework Automazione Software House

Framework per automatizzare lo sviluppo software con Claude Code. Supporta workflow strutturati con checkpoint, agenti specializzati, e skill per ogni fase del ciclo di sviluppo.

## Quick Start

```bash
# Per un nuovo progetto
/project-setup              # Genera project-config.yaml

# Workflow tipico (ORDINE IMPORTANTE)
/sitemap-generator               # 1. Genera sitemap (checkpoint)
/mockup-designer                 # 2. Design visivo (3 proposte, design system) - NUOVO
/architecture-designer           # 3. Progetta architettura (4 checkpoint) - PRIMA di API!
/frontend-architecture-designer  # 4a. Architettura frontend
/backend-architecture-designer   # 4b. Architettura backend
/api-signature-generator         # 5. Genera API signature (checkpoint) - DOPO architettura!
/project-scaffolder              # 6. Crea struttura repo

# Implementazione
/develop [scope]            # Implementa feature/milestone

# Quality & Verification
/verify                     # Suite verifiche (build, types, lint, test)
/tdd                        # Test-Driven Development
/code-review                # Review codice
/test-runner                # Esegue test suite
/e2e                        # Test End-to-End

# Utilities
/checkpoint [action]        # Gestione checkpoint stato
/build-fix                  # Fix automatico errori build

# Deploy
/deploy-helper [env]        # Guida deploy
```

## Struttura Framework

```
~/.claude/
├── CLAUDE.md                    # Questo file
├── settings.json                # Permessi e hooks globali
├── rules/                       # Convenzioni condivise
│   ├── git-conventions.md       # Conventional commits
│   ├── commit-policy.md         # Quando fare commit
│   ├── code-review-policy.md    # Code review con Git/PR
│   ├── code-standards.md        # Standard codice (unificato)
│   ├── environments.md          # Configurazione ambienti
│   └── checkpoint-protocol.md   # Gestione checkpoint
├── templates/
│   └── project-config.yaml      # Template configurazione
├── agents/                      # Agenti specializzati (formato wshobson)
│   ├── project-manager.md
│   ├── solution-architect.md
│   ├── backend-implementer.md
│   ├── frontend-implementer.md
│   ├── code-reviewer.md
│   ├── test-writer.md
│   ├── fixer.md
│   └── ... (20 agenti totali)
├── skills/                      # Skill invocabili
│   ├── project-setup/
│   ├── sitemap-generator/       # 4 fasi, checkpoint
│   ├── mockup-designer/         # 3 fasi, 1 checkpoint (NUOVO)
│   ├── architecture-designer/           # 6 fasi, 4 checkpoint
│   ├── frontend-architecture-designer/  # 5 fasi, 1 checkpoint
│   ├── backend-architecture-designer/   # 5 fasi, 1 checkpoint
│   ├── api-signature-generator/         # 5 fasi, checkpoint
│   ├── develop/                         # 7 fasi + E2E integration
│   ├── test-runner/
│   ├── code-review/
│   └── deploy-helper/
├── commands/                    # Comandi slash (NUOVO)
│   ├── verify.md               # Suite verifiche
│   ├── tdd.md                  # Test-Driven Development
│   ├── checkpoint.md           # Gestione stato
│   ├── e2e.md                  # Test End-to-End
│   ├── code-review.md          # Code review automatica
│   └── build-fix.md            # Fix errori build
└── hooks/                       # Hook scripts
    ├── load-project-config.sh
    ├── session-start.sh        # Memory persistence (NUOVO)
    ├── session-end.sh          # Session logging (NUOVO)
    ├── check-conventional-commit.sh
    ├── lint-file.sh
    ├── pre-edit-check.sh
    └── post-edit-check.sh      # TypeScript/console.log check (NUOVO)
```

## Workflow Completo

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           WORKFLOW FASI                                      │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  DISCOVERY ─► SITEMAP ─► MOCKUP ─► ARCHITECTURE ─► IMPL ARCH ─► API SIG     │
│      │           │          │          │              │            │         │
│      ▼           ▼          ▼          ▼              ▼            ▼         │
│   brief     sitemap.md  design-   overview.md    frontend-    api-sig       │
│  (input)    (checkpoint) system   tech-stack     architecture (checkpoint)  │
│                         (checkpoint) data-model  backend-                   │
│                                    user-flows    architecture               │
│                                   (4 checkpoint) (2 checkpoint)             │
│                                                                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  IMPLEMENTATION (per blocco)                                                 │
│        │                                                                     │
│        ▼                                                                     │
│   /develop ──► decomposizione blocchi ──► CHECKPOINT approvazione            │
│        │                                                                     │
│   Per blocco (blocchi indipendenti in parallelo):                            │
│     Track1: impl+unit ─► review ─► fix  ║  Track2: test-writer (contracts)  │
│                                          ║    +--> SEMANTIC VALIDATION       │
│                         SYNC ────────────╝                                   │
│                    run tests ─► fix ─► BLOCCO OK ─► commit ─► sblocca deps   │
│                                                                              │
│   Tutti blocchi OK ──► E2E Integration (Fase 4.5):                           │
│                        - Health checks (backend, DB, frontend)               │
│                        - E2E tests (@milestone-N)                            │
│                        - Smoke tests (Chrome plugin automation)              │
│                        - Auto-fix se fail                                    │
│                                                                              │
│   E2E OK ─► CHECKPOINT milestone ─► /deploy (guida)                          │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

NOTA: Mockup PRIMA di Architecture per validare design visivo early.
      Architecture PRIMA di API Signature (definisce protocolli).
      E2E Integration automatica DOPO blocchi (trova integration bugs subito).
```

## Checkpoint

I checkpoint sono punti di controllo dove serve approvazione umana:

| Checkpoint | Fase | Skill | Tipo | Descrizione |
|------------|------|-------|------|-------------|
| brief | Discovery | - | BLOCKING | Brief strutturato |
| sitemap | Specifications | /sitemap-generator | BLOCKING | Struttura pagine |
| mockup_approval | Design | /mockup-designer | BLOCKING | Design visivo approvato |
| architecture_overview | Architecture | /architecture-designer | BLOCKING | Design sistema |
| tech_stack_choice | Architecture | /architecture-designer | BLOCKING | Scelta tecnologie |
| data_model | Architecture | /architecture-designer | BLOCKING | Schema dati |
| user_flows | Architecture | /architecture-designer | BLOCKING | Flussi critici |
| frontend_architecture | Implementation Arch | /frontend-architecture-designer | BLOCKING | Architettura frontend |
| backend_architecture | Implementation Arch | /backend-architecture-designer | BLOCKING | Architettura backend |
| api_signature | API Design | /api-signature-generator | BLOCKING | Contratto API |
| milestone_complete | Implementation | /develop | BLOCKING | Milestone finito (include E2E) |
| feature_complete | Implementation | /develop | BLOCKING | Feature finite |
| e2e_complete | Testing | /test-runner | BLOCKING | Test E2E passano |
| release | Deploy | /deploy-helper | BLOCKING | Pronto produzione |

## Agenti Disponibili

Tutti gli agenti seguono il formato wshobson con:
- **Capabilities**: Cosa può fare
- **Behavioral Traits**: Come si comporta
- **Workflow Position**: Dove nel workflow

### Management
- **project-manager**: Orchestratore, milestones, coordinamento
- **product-owner**: Requisiti, priorità, acceptance criteria

### Architecture
- **solution-architect**: Design architettura, decisioni tecniche, ADR
- **database-architect**: Schema DB, query optimization, migrations
- **api-designer**: Design API, contratti OpenAPI

### Development
- **backend-implementer**: Codice backend (spec-driven, security-first)
- **frontend-implementer**: Codice frontend
- **mobile-implementer**: Codice mobile (Flutter)
- **fixer**: Corregge bug (minimal changes, max 3 attempts)

### Quality
- **code-reviewer**: Review qualità, sicurezza, best practices
- **security-auditor**: Analisi sicurezza, OWASP Top 10
- **performance-analyst**: Analisi performance, bottleneck

### Testing
- **qa-lead**: Strategia test, test plan
- **test-writer**: Unit e integration test (AAA pattern)
- **e2e-tester**: Test E2E

### DevOps
- **devops-engineer**: CI/CD, Docker, deploy configs
- **infrastructure-specialist**: Cloud, IaC, monitoring

### Documentation
- **technical-writer**: Documentazione tecnica
- **spec-updater**: Sync specs con codice

## Skill Principali

### `/sitemap-generator`
Genera sitemap da brief. **4 fasi**:
1. Analisi Input
2. Generazione Draft
3. **Checkpoint SITEMAP**
4. Finalizzazione

### `/mockup-designer` (NUOVO)
Genera design visivo da brief + sitemap. **3 fasi**:
1. Analisi context (brief + sitemap)
2. Genera 3 proposte HTML/CSS dettagliate + iterazione conversazionale
3. **Checkpoint MOCKUP_APPROVAL** + finalizzazione design system

### `/architecture-designer`
Progetta architettura progressivamente. **6 fasi, 4 checkpoint**:
1. Analisi Requisiti
2. Overview Componenti → **CHECKPOINT: ARCHITECTURE_OVERVIEW**
3. Tech Stack → **CHECKPOINT: TECH_STACK_CHOICE**
4. Data Model → **CHECKPOINT: DATA_MODEL**
5. User Flows → **CHECKPOINT: USER_FLOWS**
6. Finalizzazione

### `/frontend-architecture-designer` (NUOVO)
Progetta architettura implementativa frontend. **5 fasi, 1 checkpoint**:
1. Analyze Context (tech-stack, sitemap)
2. Component Architecture (patterns, directory structure)
3. State Management (strategy, data flow)
4. Draft + Testing → **CHECKPOINT: FRONTEND_ARCHITECTURE**
5. Finalization

### `/backend-architecture-designer` (NUOVO)
Progetta architettura implementativa backend. **5 fasi, 1 checkpoint**:
1. Analyze Context (tech-stack, data-model)
2. Service Architecture (layers, patterns, boundaries)
3. Cross-cutting Concerns (auth, validation, middleware)
4. Draft + Testing → **CHECKPOINT: BACKEND_ARCHITECTURE**
5. Finalization

### `/api-signature-generator`
Genera firma API. **5 fasi**, prerequisito: architettura approvata:
1. Analisi Prerequisiti (verifica architettura)
2. Estrazione Entità
3. Design Endpoints → **CHECKPOINT: API_SIGNATURE**
4. Schema Sintetici
5. Finalizzazione

### `/develop [scope]`
Orchestratore principale con **workflow a blocchi**. **7 fasi**:
- Decomposizione in blocchi funzionali coesi → **CHECKPOINT** approvazione
- Per blocco: impl+unit + contract test-writer (PARALLELO con semantic validation), review, run test
- Blocchi indipendenti: **PARALLELO**
- Blocchi dipendenti: **SEQUENZIALE**
- **Fase 4.5 (NUOVO)**: E2E integration automatica dopo tutti blocchi (health checks + E2E tests + smoke tests)
- Fix: per-blocco, max 3x; E2E fix max 2x

Scope: `all`, `backend`, `frontend`, `[feature]`, `milestone:N`

### `/test-runner [scope]`
Esegue test, genera report, identifica coverage gaps.

### `/code-review [scope]`
Review codice con possibilità di auto-fix tramite Fixer agent.

### `/deploy-helper [env]`
Guida deploy con checklist e verifiche per environment.

## Comandi Slash (NUOVO)

Comandi rapidi per sviluppo quotidiano:

| Comando | Descrizione |
|---------|-------------|
| `/verify` | Suite verifiche (build, types, lint, test, audit) |
| `/verify quick` | Solo build + types |
| `/verify pre-pr` | Extended + security |
| `/tdd` | Guida ciclo TDD: RED → GREEN → REFACTOR |
| `/checkpoint create [name]` | Salva stato verificato |
| `/checkpoint verify [name]` | Confronta con checkpoint |
| `/checkpoint list` | Lista checkpoint |
| `/e2e` | Esegue test E2E (Playwright) |
| `/code-review` | Code review automatica |
| `/build-fix` | Fix automatico errori build |

## Convenzioni

### Git (Conventional Commits)
```
type(scope): description

Types: feat, fix, refactor, docs, test, chore, style, perf, ci
```

### Commit Policy
- Commit dopo unità logica completa
- Mai commit codice che non compila
- Fix separati da feature
- Review via PR/merge request

### Code Standards (Unificato)
- **Commenti MINIMALI**: Solo WHY, TODO, HACK con riferimenti
- TypeScript: strict mode, no `any`
- Dart: null safety, immutabilità
- Python: type hints sempre
- Error handling: esplicito, mai silent
- Test: AAA pattern, coverage 80%+

## Struttura Progetto Tipo

```
project/
├── CLAUDE.md                    # Overview progetto
├── project-config.yaml          # Configurazione workflow
├── progress.yaml                # Stato milestone (auto-generato)
├── docs/
│   ├── brief-structured.md
│   ├── frontend-specs/
│   │   └── sitemap.md           # Prima
│   ├── architecture/            # Secondo
│   │   ├── overview.md
│   │   ├── tech-stack.md
│   │   ├── data-model.md
│   │   ├── user-flows.md
│   │   ├── frontend-architecture.md  # NUOVO
│   │   └── backend-architecture.md   # NUOVO
│   └── api-specs/               # Terzo (dopo architecture)
│       └── api-signature.md
├── project-app/                 # Frontend/Mobile
│   └── CLAUDE.md
├── project-backend/             # Backend
│   └── CLAUDE.md
└── environments/
    ├── .env.development
    ├── .env.staging
    └── .env.production.example
```

## Hooks Configurati

| Evento | Hook | Scopo |
|--------|------|-------|
| SessionStart | load-project-config.sh | Carica config progetto |
| SessionStart | session-start.sh | Memory persistence (NUOVO) |
| PreToolUse (Edit) | pre-edit-check.sh | Verifica file sensibili |
| PreToolUse (git commit) | check-conventional-commit.sh | Valida commit message |
| PostToolUse (Write) | lint-file.sh | Lint automatico |
| PostToolUse (Edit) | post-edit-check.sh | TypeScript/console.log check (NUOVO) |
| Stop | session-end.sh | Salva log sessione (NUOVO) |
| SubagentStop | update-progress.sh | Aggiorna progress.yaml |

## Come Iniziare un Nuovo Progetto

1. **Crea directory progetto**
   ```bash
   mkdir ~/development/MioProgetto && cd ~/development/MioProgetto
   ```

2. **Scrivi brief** (opzionale ma consigliato)
   ```bash
   mkdir -p docs && vim docs/brief.md
   ```

3. **Setup progetto**
   ```
   /project-setup
   ```

4. **Segui il workflow** (ordine importante!)
   ```
   /sitemap-generator               # 1. Sitemap → approva
   /mockup-designer                 # 2. Design visivo → approva (NUOVO)
   /architecture-designer           # 3. Architettura sistema → approva (4 checkpoint)
   /frontend-architecture-designer  # 4a. Architettura frontend → approva
   /backend-architecture-designer   # 4b. Architettura backend → approva
   /api-signature-generator         # 5. API → approva (dopo architettura!)
   /project-scaffolder              # 6. Crea repos
   /develop                         # 7. Implementa (con E2E auto)
   ```

## Principi Guida

1. **Checkpoint = Decisione critica** che influenza lavoro successivo
2. **Architecture PRIMA di API** - L'architettura definisce i protocolli
3. **Autonomous dove possibile** - Claude procede automaticamente
4. **Specs come verità** - Implementazione segue specs approvate
5. **Parallelizza dove possibile** - Backend + Frontend in parallelo se indipendenti
6. **Auto-fix prima di fermarsi** - Fixer tenta correzione (max 3x)
7. **Minimal e focused** - Niente over-engineering
8. **Commenti minimi** - Solo WHY, mai WHAT
