# Backend Architecture - [Nome Progetto]

> Stato: DRAFT | Versione: 1.0 | Data: [Data]

## Overview

[Breve descrizione architettura backend e decisioni chiave]

---

## Tech Stack

| Layer | Technology | Version |
|-------|------------|---------|
| Runtime | [Node.js / Python] | [Version] |
| Framework | [Express / FastAPI] | [Version] |
| Database | [PostgreSQL / MongoDB] | [Version] |
| ORM | [Prisma / SQLAlchemy] | [Version] |
| Validation | [Zod / Pydantic] | [Version] |
| Testing | [Jest / Pytest] | [Version] |

---

## Directory Structure

```
src/
├── routes/              # HTTP routing definitions
│   ├── index.ts        # Route aggregator
│   ├── auth.routes.ts
│   └── [entity].routes.ts
├── controllers/         # Request/Response handling
│   ├── auth.controller.ts
│   └── [entity].controller.ts
├── services/            # Business logic
│   ├── auth.service.ts
│   └── [entity].service.ts
├── repositories/        # Data access layer
│   ├── base.repository.ts
│   └── [entity].repository.ts
├── models/              # Domain entities
│   └── [entity].model.ts
├── middleware/          # Cross-cutting concerns
│   ├── auth.middleware.ts
│   ├── validation.middleware.ts
│   ├── error.middleware.ts
│   └── logging.middleware.ts
├── utils/               # Utility functions
│   ├── logger.ts
│   └── helpers.ts
├── config/              # Configuration
│   ├── index.ts
│   ├── database.ts
│   └── auth.ts
├── types/               # TypeScript types
│   ├── api.types.ts
│   └── models.types.ts
└── index.ts             # Entry point
```

---

## Layer Responsibilities

### Routes
- Define HTTP endpoints
- Map to controller methods
- Apply route-specific middleware

### Controllers
- Parse request parameters
- Call service methods
- Format HTTP responses
- NO business logic

### Services
- Implement business logic
- Coordinate repository calls
- Handle transactions
- Throw business errors

### Repositories
- Database operations only
- Abstract ORM/query details
- Return domain entities

---

## Services

| Service | Responsibility | Dependencies |
|---------|----------------|--------------|
| AuthService | Authentication, tokens | UserRepository |
| UserService | User CRUD, profile | UserRepository |
| [Entity]Service | [Description] | [Repository] |

---

## Middleware Stack

```
Request
    │
    ▼
┌─────────────────────┐
│ 1. Request ID       │  Generate UUID for tracing
├─────────────────────┤
│ 2. Logging          │  Log request entry
├─────────────────────┤
│ 3. Rate Limiting    │  [X] requests per [Y] minutes
├─────────────────────┤
│ 4. CORS             │  Allowed origins: [origins]
├─────────────────────┤
│ 5. Body Parser      │  JSON limit: 10kb
├─────────────────────┤
│ 6. Authentication   │  JWT verification
├─────────────────────┤
│ 7. Authorization    │  Role/permission check
├─────────────────────┤
│ 8. Validation       │  Zod schema validation
├─────────────────────┤
│ 9. Route Handler    │  Business logic
├─────────────────────┤
│ 10. Error Handler   │  Global error catch
└─────────────────────┘
    │
    ▼
Response
```

---

## Error Handling

### Error Hierarchy

```typescript
AppError (base)
├── ValidationError (400)
├── AuthenticationError (401)
├── AuthorizationError (403)
├── NotFoundError (404)
├── ConflictError (409)
└── InternalError (500)
```

### Error Response Format

```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human readable message",
    "details": {}
  },
  "requestId": "uuid"
}
```

### Success Response Format

```json
{
  "success": true,
  "data": {},
  "meta": {
    "page": 1,
    "limit": 10,
    "total": 100
  }
}
```

---

## Authentication

### Strategy
[JWT Stateless / JWT + Refresh / Session]

### Token Configuration
- Access Token: [duration]
- Refresh Token: [duration] (if applicable)
- Storage: [header / httpOnly cookie]

### Protected Routes
```
/api/v1/* → Requires authentication
/api/v1/admin/* → Requires admin role
/api/v1/public/* → No authentication
```

---

## Validation

### Library
[Zod / Joi / Pydantic]

### Schema Location
- Request schemas: `src/validations/[entity].schema.ts`
- Shared schemas: `src/validations/common.schema.ts`

### Example
```typescript
const createUserSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8),
  name: z.string().min(2).max(100),
});
```

---

## Database

### Connection
- Pool size: [number]
- Timeout: [ms]
- SSL: [enabled/disabled]

### Migrations
```bash
npm run db:migrate      # Apply migrations
npm run db:rollback     # Rollback last migration
npm run db:seed         # Seed data
```

### Indexes
[List critical indexes]

---

## Testing Strategy

### Unit Tests
- Location: `src/**/*.test.ts`
- Coverage target: 80%
- Mock strategy: Repository mocks

### Integration Tests
- Location: `tests/integration/`
- Database: Test instance
- API client: Supertest

### Commands
```bash
npm run test             # All tests
npm run test:unit        # Unit only
npm run test:integration # Integration only
npm run test:coverage    # With coverage
```

---

## Security Considerations

- [ ] Input validation on all endpoints
- [ ] SQL injection prevention (ORM)
- [ ] Rate limiting enabled
- [ ] CORS configured
- [ ] Sensitive data encrypted
- [ ] No secrets in code
- [ ] HTTPS enforced
- [ ] Security headers set

---

## Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| NODE_ENV | Environment | Yes |
| PORT | Server port | Yes |
| DATABASE_URL | DB connection | Yes |
| JWT_SECRET | Token signing | Yes |
| [Others] | [Description] | [Yes/No] |

---

## Commands Reference

```bash
# Development
npm run dev              # Start dev server

# Build
npm run build            # Production build
npm run start            # Start production

# Quality
npm run lint             # Lint check
npm run typecheck        # Type check

# Database
npm run db:migrate       # Run migrations
npm run db:seed          # Seed data

# Testing
npm run test             # Run tests
npm run test:coverage    # Coverage report
```

---

## Prossimi Step

1. `/frontend-architecture-designer` - Architettura frontend
2. `/api-signature-generator` - Definire contratti API
3. `/develop` - Implementazione
