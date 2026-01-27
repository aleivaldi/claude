# Evaluation: Express REST API

## Scenario

Progetto e-commerce MVP con:
- Node.js + Express
- PostgreSQL + Prisma
- JWT Authentication
- REST API

## Input

### tech-stack.md (excerpt)
```markdown
## Backend
- Runtime: Node.js 20
- Framework: Express
- Database: PostgreSQL 15
- ORM: Prisma
- Auth: JWT
```

### data-model.md (excerpt)
```markdown
## Entities
- User: id, email, password, name, role
- Product: id, name, description, price, stock
- Order: id, userId, status, total
- OrderItem: id, orderId, productId, quantity, price
```

## Expected Output

### backend-architecture.md (key sections)

```markdown
## Directory Structure

src/
├── routes/
│   ├── index.ts
│   ├── auth.routes.ts
│   ├── users.routes.ts
│   ├── products.routes.ts
│   └── orders.routes.ts
├── controllers/
│   ├── auth.controller.ts
│   ├── users.controller.ts
│   ├── products.controller.ts
│   └── orders.controller.ts
├── services/
│   ├── auth.service.ts
│   ├── users.service.ts
│   ├── products.service.ts
│   └── orders.service.ts
├── repositories/
│   ├── base.repository.ts
│   ├── users.repository.ts
│   ├── products.repository.ts
│   └── orders.repository.ts
├── middleware/
│   ├── auth.middleware.ts
│   ├── validation.middleware.ts
│   ├── error.middleware.ts
│   └── logging.middleware.ts
├── validations/
│   ├── auth.schema.ts
│   ├── products.schema.ts
│   └── orders.schema.ts
├── utils/
│   ├── logger.ts
│   └── errors.ts
├── config/
│   └── index.ts
└── types/
    └── index.ts

## Services

| Service | Responsabilità |
|---------|----------------|
| AuthService | Login, register, token refresh |
| UsersService | User CRUD, profile |
| ProductsService | Product CRUD, inventory |
| OrdersService | Order creation, status, history |

## Middleware Stack

1. Request ID
2. Logging
3. Rate Limiting (100/min)
4. CORS
5. Body Parser (10kb)
6. Authentication (JWT)
7. Authorization (role-based)
8. Validation (Zod)
9. Route Handler
10. Error Handler

## Testing

npm run test:unit        # Jest
npm run test:integration # Supertest
npm run test:coverage    # 80% target
```

## Evaluation Criteria

| Criterio | Peso | Pass |
|----------|------|------|
| Directory structure corretta | 25% | ✓ 4 layer separati |
| Services identificati da data model | 25% | ✓ 4 services mappati |
| Middleware stack completo | 20% | ✓ 10 middleware ordinati |
| Error handling definito | 15% | ✓ Hierarchy + response format |
| Testing strategy completa | 15% | ✓ Comandi + coverage target |

## Common Mistakes to Avoid

1. **Mixing layers**: Controller con business logic
2. **Missing validation**: No Zod schemas
3. **Wrong middleware order**: Auth dopo route handler
4. **No error hierarchy**: Solo try/catch generico
5. **Missing rate limiting**: Security gap
