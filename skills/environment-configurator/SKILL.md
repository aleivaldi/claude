---
name: environment-configurator
description: Configura ambienti (development, staging, production). Genera file .env, docker-compose per ambiente, e documenta setup.
---

# Environment Configurator Skill

## Obiettivo

Configurare gli ambienti di sviluppo, staging e produzione con:
- File `.env` per ogni ambiente
- Docker compose per ambiente
- Documentazione setup

## Input

Richiede:
- `project-config.yaml` (per leggere configurazione ambienti)
- `docs/architecture/tech-stack.md` (per sapere quali servizi configurare)

## Fasi

### Fase 1: Analisi Stack

1. **Identifica servizi necessari**
   - Database (PostgreSQL, MySQL, MongoDB)
   - Cache (Redis)
   - Message Broker (MQTT, RabbitMQ)
   - Altri servizi

2. **Leggi configurazione esistente**
   - `project-config.yaml` environments section
   - Repository esistenti

### Fase 2: Genera File Environment

**Consulta `templates/env-example-template.sh` per template base.**

Per ogni repository backend, genera:
- `.env.example` (committato, template con placeholders)
- `environments/.env.development` (valori locali)
- `environments/.env.staging` (riferimenti secrets manager)
- `environments/.env.production.example` (template, no secrets reali)

**Variabili per servizio**: Vedi `reference/env-variables-by-service.md`

### Fase 3: Docker Compose per Ambiente

**Consulta `templates/docker-compose-dev-template.yml` per template base.**

Genera:
- `docker-compose.yml` (development con hot reload, servizi locali)
- `docker-compose.staging.yml` (replica setup, resource limits)

Adatta servizi basandosi su tech stack (PostgreSQL, Redis, MQTT, etc.)

### Fase 4: Checkpoint

```
═══════════════════════════════════════════════════════════════
>>> CHECKPOINT: ENVIRONMENT_CONFIG <<<
═══════════════════════════════════════════════════════════════

## Configurazione Ambienti Generata

### File Creati
- environments/.env.development
- environments/.env.staging
- environments/.env.production.example
- .env.example
- docker-compose.yml
- docker-compose.staging.yml

### Servizi Configurati
- PostgreSQL 15
- Redis 7
- Mosquitto MQTT 2

### Variabili per Ambiente
| Variable | Dev | Staging | Prod |
|----------|-----|---------|------|
| NODE_ENV | development | staging | production |
| LOG_LEVEL | debug | info | warn |
| DB_HOST | localhost | staging-db | secrets |

═══════════════════════════════════════════════════════════════
Approvi questa configurazione? [S]ì / [N]o / [M]odifica
═══════════════════════════════════════════════════════════════
```

### Fase 5: Documentazione

**Consulta `templates/environments-setup-doc-template.md` per template base.**

Genera `docs/environments-setup.md` con:
- Prerequisites (Docker, Node.js)
- Quick Start per ambiente
- Environment details (Development/Staging/Production)
- Secrets management strategy

## Output Files

```
project/
├── .env.example
├── environments/
│   ├── .env.development
│   ├── .env.staging
│   └── .env.production.example
├── docker-compose.yml
├── docker-compose.staging.yml
└── docs/
    └── environments-setup.md
```

## Materiali di Riferimento

**Template**:
- `templates/env-example-template.sh` - Template base .env con tutte le variabili comuni
- `templates/docker-compose-dev-template.yml` - Template docker-compose development
- `templates/environments-setup-doc-template.md` - Template documentazione setup

**Reference**:
- `reference/env-variables-by-service.md` - Variabili per servizio (Node.js, Python, etc.), valori default per ambiente

## Principi

- **Security first**: Mai secrets in git
- **Parity**: Ambienti simili quanto possibile
- **Documented**: Ogni variabile documentata
- **Templated**: .example files per onboarding
