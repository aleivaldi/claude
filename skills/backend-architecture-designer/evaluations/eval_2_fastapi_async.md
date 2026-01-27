# Evaluation: FastAPI Async API

## Scenario

SaaS application con:
- Python + FastAPI
- PostgreSQL + SQLAlchemy
- OAuth2 + JWT
- Async operations

## Input

### tech-stack.md (excerpt)
```markdown
## Backend
- Runtime: Python 3.11
- Framework: FastAPI
- Database: PostgreSQL 15
- ORM: SQLAlchemy 2.0 (async)
- Auth: OAuth2 + JWT
```

### data-model.md (excerpt)
```markdown
## Entities
- Tenant: id, name, plan, settings
- User: id, tenantId, email, password, role
- Project: id, tenantId, name, description
- Task: id, projectId, title, status, assigneeId
```

## Expected Output

### backend-architecture.md (key sections)

```markdown
## Directory Structure

app/
├── main.py
├── config.py
├── api/
│   ├── deps.py
│   └── v1/
│       ├── router.py
│       ├── auth.py
│       ├── tenants.py
│       ├── users.py
│       ├── projects.py
│       └── tasks.py
├── core/
│   ├── security.py
│   └── exceptions.py
├── models/
│   ├── base.py
│   ├── tenant.py
│   ├── user.py
│   ├── project.py
│   └── task.py
├── schemas/
│   ├── tenant.py
│   ├── user.py
│   ├── project.py
│   └── task.py
├── services/
│   ├── auth.py
│   ├── tenant.py
│   ├── user.py
│   ├── project.py
│   └── task.py
├── repositories/
│   ├── base.py
│   ├── tenant.py
│   ├── user.py
│   ├── project.py
│   └── task.py
├── db/
│   ├── session.py
│   └── init_db.py
└── utils/
    └── logger.py

## Multi-tenant Pattern

- Tenant isolation via tenant_id FK
- Request-scoped tenant context
- Middleware injects current tenant

## Services

| Service | Responsabilità |
|---------|----------------|
| AuthService | OAuth2 flow, JWT tokens |
| TenantService | Tenant CRUD, settings |
| UserService | User CRUD, roles |
| ProjectService | Project CRUD |
| TaskService | Task CRUD, assignments |

## Async Patterns

- All DB operations async
- Connection pooling (asyncpg)
- Background tasks for heavy ops

## Testing

pytest                    # All tests
pytest tests/unit         # Unit
pytest tests/integration  # API tests
pytest --cov=app          # Coverage
```

## Evaluation Criteria

| Criterio | Peso | Pass |
|----------|------|------|
| Async patterns corretti | 25% | ✓ Async DB, connection pool |
| Multi-tenant consideration | 20% | ✓ Tenant isolation pattern |
| Directory structure FastAPI | 20% | ✓ Standard FastAPI layout |
| Pydantic schemas separati | 15% | ✓ Schemas in dedicated folder |
| Testing strategy async | 20% | ✓ pytest-asyncio + httpx |

## Common Mistakes to Avoid

1. **Sync in async**: Blocking calls in async functions
2. **Missing tenant isolation**: No tenant_id validation
3. **Pydantic in models**: Mixing SQLAlchemy + Pydantic
4. **No connection pooling**: Performance issue
5. **Missing background tasks**: Heavy ops in request cycle
