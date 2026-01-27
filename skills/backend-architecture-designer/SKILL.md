---
name: backend-architecture-designer
description: Progetta architettura implementativa backend. Definisce layer structure, service patterns, middleware stack, error handling. Prerequisito tech-stack approvato. Output backend-architecture.md per guidare implementazione.
---

# Backend Architecture Designer

## Il Tuo Compito

Progettare l'architettura **implementativa** del backend dopo che le scelte tecnologiche sono state approvate. Focus su:
1. Layer structure e boundaries
2. Service patterns e granularità
3. Middleware stack e order
4. Error handling hierarchy
5. Testing strategy

**Prerequisito**: Checkpoint `tech_stack_choice` completato.

**Output**: `docs/architecture/backend-architecture.md`

---

## Materiali di Riferimento

**Templates**:
- `templates/backend-architecture-template.md` - Template output principale
- `templates/express-structure.md` - Struttura Express/Node.js
- `templates/fastapi-structure.md` - Struttura FastAPI/Python

**Reference**:
- `reference/error-handling.md` - Gestione errori skill
- `reference/middleware-patterns.md` - Pattern middleware per stack
- `reference/security-checklist.md` - Security OWASP checklist

---

## Workflow: 5 Fasi

```
Fase 1: Analyze Context       → Legge tech-stack, data-model
Fase 2: Service Architecture  → Layers, patterns, boundaries
Fase 3: Cross-cutting Concerns → Auth, validation, error handling, middleware
Fase 4: Draft + Testing       → Crea backend-architecture-draft.md
        >>> CHECKPOINT: BACKEND_ARCHITECTURE <<<
Fase 5: Finalization          → Approva e finalizza
```

---

## Fase 1: Analyze Context

### Obiettivo
Raccogliere input architetturali per decisioni implementative.

### Azioni

1. **Verifica prerequisito**: Tech stack approvato
   ```
   Cerca: docs/architecture/tech-stack.md
   Se non esiste: "Esegui prima /architecture-designer"
   ```

2. **Leggi documenti**:
   - `docs/architecture/tech-stack.md` - Stack scelto
   - `docs/architecture/data-model.md` - Schema entità
   - `docs/architecture/overview.md` - Componenti sistema
   - `project-config.yaml` - Configurazione progetto

3. **Identifica tech stack backend**:
   - Runtime: Node.js / Python / Go / Java
   - Framework: Express / Fastify / NestJS / FastAPI / Django
   - Database: PostgreSQL / MongoDB / MySQL
   - ORM: Prisma / TypeORM / SQLAlchemy / Django ORM

4. **Comunica sintesi**:
   ```
   Analisi completata:

   Stack Backend:
   - Runtime: Node.js 20
   - Framework: Express
   - Database: PostgreSQL
   - ORM: Prisma

   Procedo con design architettura backend.
   ```

---

## Fase 2: Service Architecture

### Obiettivo
Definire layer structure, service patterns e boundaries.

### Decisioni da Catturare

| Categoria | Opzioni | Quando Usare |
|-----------|---------|--------------|
| **Architecture Pattern** | Layered / Clean / Hexagonal | Layered per MVP, Clean per enterprise |
| **Service Granularity** | Monolith / Modular / Microservices | Monolith per MVP, Modular per scale |
| **Database Access** | Repository Pattern / Active Record | Repository per testabilità |
| **Dependency Injection** | Manual / Container (tsyringe, inversify) | Container per progetti grandi |

### Layer Structure (Standard)

```
src/
├── routes/           # HTTP routing (thin layer)
├── controllers/      # Request/Response handling
├── services/         # Business logic (core)
├── repositories/     # Data access abstraction
├── models/           # Domain entities
├── middleware/       # Cross-cutting concerns
├── utils/            # Pure utility functions
├── config/           # Configuration management
└── types/            # TypeScript types/interfaces
```

### Service Boundaries

Per ogni servizio definisci:
- **Responsabilità**: Single Responsibility
- **Dipendenze**: Quali altri servizi/repos usa
- **Interface**: Metodi pubblici esposti
- **Data**: Quali entità gestisce

---

## Fase 3: Cross-cutting Concerns

### Obiettivo
Definire middleware stack, auth, validation, error handling.

### Middleware Stack Order

```
1. Request ID (tracing)      → Genera UUID per ogni request
2. Logging                   → Log request entry
3. Rate Limiting            → Protezione abuse
4. CORS                     → Cross-origin policy
5. Body Parser              → Parse JSON/form data
6. Authentication           → Verifica token/session
7. Authorization            → Verifica permessi
8. Validation               → Valida input
9. Route Handler            → Business logic
10. Error Handler (global)  → Catch-all errors
```

### Error Handling Hierarchy

```typescript
// Base error class
class AppError extends Error {
  constructor(
    public statusCode: number,
    public code: string,
    message: string,
    public isOperational = true
  ) {
    super(message);
  }
}

// Specific errors
class ValidationError extends AppError {
  constructor(message: string, public fields?: Record<string, string>) {
    super(400, 'VALIDATION_ERROR', message);
  }
}

class AuthenticationError extends AppError {
  constructor(message = 'Authentication required') {
    super(401, 'AUTHENTICATION_ERROR', message);
  }
}

class AuthorizationError extends AppError {
  constructor(message = 'Insufficient permissions') {
    super(403, 'AUTHORIZATION_ERROR', message);
  }
}

class NotFoundError extends AppError {
  constructor(resource: string) {
    super(404, 'NOT_FOUND', `${resource} not found`);
  }
}

class ConflictError extends AppError {
  constructor(message: string) {
    super(409, 'CONFLICT', message);
  }
}
```

### Error Response Format

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": {
      "email": "Invalid email format",
      "password": "Must be at least 8 characters"
    }
  },
  "requestId": "uuid-xxx"
}
```

### Validation Strategy

| Library | Runtime | Quando |
|---------|---------|--------|
| Zod | Node.js | Type-safe, TypeScript-first |
| Joi | Node.js | Mature, flexible |
| class-validator | NestJS | Decorator-based |
| Pydantic | Python | FastAPI native |

### Auth Strategy Options

| Strategy | Quando | Implementation |
|----------|--------|----------------|
| JWT Stateless | API-first, mobile | Token in header, no server state |
| JWT + Refresh | Long sessions | Access token short, refresh in httpOnly |
| Session | Web traditional | Server-side session, cookie ID |
| OAuth2 | Third-party auth | Provider delegation |

---

## Fase 4: Draft + Testing Strategy

### Obiettivo
Creare documento architettura con testing strategy definita.

### Testing Strategy Backend

```
Unit Tests (80% coverage target):
├── Services: Business logic isolation
│   - Mock repositories
│   - Test edge cases
│   - Test error paths
├── Utils: Pure function tests
│   - No mocks needed
│   - Input/output verification
└── Validators: Schema validation
    - Valid input passes
    - Invalid input fails with correct error

Integration Tests:
├── API Endpoints: HTTP request/response
│   - Supertest / httpx
│   - Real database (test instance)
│   - Authentication flows
└── Database Operations
    - Repository methods
    - Transactions
    - Migrations
```

### Comandi Automatici

```bash
# Development
npm run dev              # Development server with hot reload
npm run build            # Production build

# Quality
npm run lint             # ESLint check
npm run lint:fix         # ESLint auto-fix
npm run typecheck        # TypeScript check (tsc --noEmit)

# Testing
npm run test             # Run all tests
npm run test:unit        # Unit tests only
npm run test:integration # Integration tests only
npm run test:coverage    # Coverage report
npm run test:watch       # Watch mode

# Database
npm run db:migrate       # Run migrations
npm run db:migrate:test  # Setup test database
npm run db:seed          # Seed development data
npm run db:studio        # Open Prisma Studio
```

### Azioni

1. **Crea draft** usando `templates/backend-architecture-template.md`
2. **Popola sezioni**:
   - Layer structure con directory tree
   - Service list con responsabilità
   - Middleware stack ordinato
   - Error handling hierarchy
   - Testing strategy con comandi
   - Security considerations

3. **Scrivi** `docs/architecture/backend-architecture-draft.md`

4. **Presenta CHECKPOINT**:

```
═══════════════════════════════════════════════════════════════
>>> CHECKPOINT: BACKEND_ARCHITECTURE <<<
═══════════════════════════════════════════════════════════════

## Stato: BLOCKING

## Architettura Backend Definita

### Layer Structure
[Mostra directory tree]

### Services
[Lista servizi con responsabilità]

### Middleware Stack
[Ordine middleware]

### Testing Strategy
- Unit: 80% coverage target
- Integration: API + DB tests
- Comandi: npm run test:*

## Artefatto
- `docs/architecture/backend-architecture-draft.md`

═══════════════════════════════════════════════════════════════
Approvi? [S]ì / [N]o / [M]odifica
═══════════════════════════════════════════════════════════════
```

5. **Usa AskUserQuestion** per raccogliere risposta

---

## Fase 5: Finalization

### Obiettivo
Finalizzare documento approvato.

### Azioni

1. **Rinomina** draft rimuovendo "-draft":
   ```
   backend-architecture-draft.md → backend-architecture.md
   ```

2. **Aggiorna stato** nel documento da DRAFT a APPROVATO

3. **Aggiorna README** architettura:
   ```markdown
   | [backend-architecture.md](backend-architecture.md) | Architettura backend | ✅ Approvato |
   ```

4. **Comunica completamento**:
   ```
   ✅ Backend Architecture completata.

   Output: docs/architecture/backend-architecture.md

   Contenuto:
   - Layer structure definita
   - [N] services identificati
   - Middleware stack configurato
   - Error handling standardizzato
   - Testing strategy definita

   Prossimo step: /frontend-architecture-designer (se non fatto)
                  oppure /api-signature-generator
   ```

---

## Tecnologie Supportate

### Node.js

| Framework | Caratteristiche | Use Case |
|-----------|-----------------|----------|
| Express | Minimal, flessibile | API semplici, MVP |
| Fastify | Performance, schema | API high-performance |
| NestJS | Enterprise, DI, modules | Progetti strutturati |

### Python

| Framework | Caratteristiche | Use Case |
|-----------|-----------------|----------|
| FastAPI | Async, type hints, auto-docs | Modern APIs |
| Django | Batteries included, ORM | Full-stack, admin |
| Flask | Minimal, extensible | Microservices |

---

## Regole Tool

- ✅ **SEMPRE** Read tech-stack.md prima di procedere
- ✅ Write per creare draft
- ✅ AskUserQuestion per checkpoint
- ❌ **MAI** saltare checkpoint
- ❌ **MAI** assumere stack non verificato

---

## Gestione Errori

**Consulta `reference/error-handling.md` per procedure complete.**

| Errore | Causa | Recovery |
|--------|-------|----------|
| Tech stack mancante | Prerequisito non completato | Suggerisci /architecture-designer |
| Stack non supportato | Runtime/framework sconosciuto | Chiedi chiarimenti, proponi alternativa |
| Conflitto patterns | Scelte incompatibili | Presenta trade-offs, chiedi decisione |

---

## Avvio Workflow

1. Verifica prerequisito (tech_stack_choice)
2. Fase 1: Analyze context
3. Fase 2: Service architecture
4. Fase 3: Cross-cutting concerns
5. Fase 4: Draft + CHECKPOINT
6. Fase 5: Finalization

**Principio**: L'architettura backend definisce come il codice sarà organizzato. Ogni decisione impatta implementazione e manutenibilità.
