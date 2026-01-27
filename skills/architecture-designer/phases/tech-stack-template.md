# Fase 3: Tech Stack - Template

## Template File: tech-stack-draft.md

```markdown
# Tech Stack - [Nome Progetto]

> Stato: DRAFT - In attesa approvazione

## Frontend/Mobile

| Layer | Tecnologia | Motivazione |
|-------|------------|-------------|
| Framework | [es. Flutter] | [Perché] |
| State Mgmt | [es. Riverpod] | [Perché] |
| HTTP Client | [es. Dio] | [Perché] |

## Backend

| Layer | Tecnologia | Motivazione |
|-------|------------|-------------|
| Runtime | [es. Node.js 20] | [Perché] |
| Framework | [es. Express/Fastify] | [Perché] |
| ORM | [es. Prisma] | [Perché] |
| Validation | [es. Zod] | [Perché] |

## Data

| Tipo | Tecnologia | Motivazione |
|------|------------|-------------|
| Database | [es. PostgreSQL] | [Perché] |
| Cache | [es. Redis] | [Perché] |
| Message Broker | [es. MQTT/RabbitMQ] | [Perché - se real-time] |

## Protocolli Comunicazione

| Da → A | Protocollo | Use Case |
|--------|------------|----------|
| App → API | REST/HTTPS | CRUD operations |
| App → API | WebSocket | Real-time updates |
| App → Device | [MQTT/BLE/...] | [Se applicabile] |

## Alternative Considerate

### [Decisione X]
- **Scelta**: [Tecnologia scelta]
- **Alternative**: [Altre opzioni]
- **Rationale**: [Perché questa scelta]
```

## Template Checkpoint Presentation

```
═══════════════════════════════════════════════════════════════
>>> CHECKPOINT: TECH_STACK_CHOICE <<<
═══════════════════════════════════════════════════════════════

## Tech Stack Proposto

File: docs/architecture/tech-stack-draft.md

### Scelte Principali
- Frontend: [Tecnologia]
- Backend: [Tecnologia]
- Database: [Tecnologia]
- Comunicazione: [Protocolli]

### Impatto su API Signature
- Protocollo principale: [REST/GraphQL/gRPC]
- Real-time: [WebSocket/SSE/MQTT]

═══════════════════════════════════════════════════════════════

Approvi questo tech stack?
```

## Azioni Complete

1. **Proponi tech stack** basato su requisiti analizzati
2. **Crea file** `docs/architecture/tech-stack-draft.md` con Write tool
3. **Presenta checkpoint** con AskUserQuestion
4. **Gestisci risposta**: Approva → Fase 4, Modifica → Rileggi e ripresenta

## Decisioni Tecnologiche Comuni

### MVP-Oriented (Default)
- **Frontend Mobile**: Flutter (cross-platform)
- **Backend**: Node.js + Express/Fastify (rapido, ecosistema)
- **Database**: PostgreSQL (relazionale robusto)
- **Auth**: JWT
- **Real-time**: WebSocket (se necessario)

### Alternative per Casistiche Specifiche
- **GraphQL** se molte relazioni complesse
- **gRPC** se microservizi high-performance
- **MongoDB** se schema altamente flessibile
- **Redis** se heavy caching/sessions
