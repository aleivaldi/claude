# Fase 2: Overview Componenti - Template

## Template File: architecture-overview-draft.md

```markdown
# Architecture Overview - [Nome Progetto]

> Stato: DRAFT - In attesa approvazione
> Generato: [data]

## Contesto Sistema

[Descrizione alto livello: cosa fa il sistema, chi lo usa]

## Componenti

| Componente | Responsabilità | Note |
|------------|----------------|------|
| Mobile App | UI utente, offline cache | - |
| Backend API | Business logic, auth | - |
| Database | Persistenza dati | - |
| [Altri...] | | |

## Diagramma Componenti

\```
┌─────────────────────────────────────────────────────────┐
│                       CLIENTS                            │
│  ┌─────────────┐  ┌─────────────┐                       │
│  │ Mobile App  │  │   Web App   │                       │
│  └──────┬──────┘  └──────┬──────┘                       │
└─────────┼────────────────┼──────────────────────────────┘
          │                │
          │    [Protocollo da definire]
          │                │
┌─────────┼────────────────┼──────────────────────────────┐
│         └────────┬───────┘                              │
│                  │                                      │
│           ┌──────▼──────┐                    BACKEND    │
│           │  API Server │                               │
│           └──────┬──────┘                               │
│                  │                                      │
│           ┌──────▼──────┐                               │
│           │  Database   │                               │
│           └─────────────┘                               │
└─────────────────────────────────────────────────────────┘
\```

## Confini e Responsabilità

### Mobile App
- [Responsabilità specifiche]

### Backend API
- [Responsabilità specifiche]

## Decisioni Aperte

- [ ] Scelta tech stack (Fase 3)
- [ ] Protocolli comunicazione (Fase 3)
- [ ] Schema database (Fase 4)
```

## Template Checkpoint Presentation

```
═══════════════════════════════════════════════════════════════
>>> CHECKPOINT: ARCHITECTURE_OVERVIEW <<<
═══════════════════════════════════════════════════════════════

## Overview Architettura

File: docs/architecture/overview-draft.md

### Componenti Identificati
- [Lista componenti]

### Decisioni Chiave
- [Decisioni prese]

### Da Definire
- Tech stack (prossimo checkpoint)
- Protocolli comunicazione
- Data model

═══════════════════════════════════════════════════════════════

Approvi questa architettura di base?
```

## Azioni Complete

1. **Identifica componenti** basati su requisiti (Frontend, Backend, Database, Cache, Message broker, External services)
2. **Crea file** `docs/architecture/overview-draft.md` con Write tool usando template sopra
3. **Presenta checkpoint** usando AskUserQuestion con formato sopra
4. **Gestisci risposta**: Approva → Fase 3, Modifica → Rileggi e ripresenta
