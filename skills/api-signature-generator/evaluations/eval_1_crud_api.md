# Evaluation 1: Standard CRUD API

## Scenario
Generare API signature per app con CRUD users e posts.

## Input

**docs/architecture/tech-stack.md**:
```markdown
Protocolli: REST/HTTPS
```

**docs/frontend-specs/sitemap.md**:
```markdown
- /users (lista)
- /users/:id (dettaglio)
- /posts (lista)
- /posts/:id (dettaglio)
- /posts/new (crea post)
```

### Invocazione
```
/api-signature-generator
```

## Expected Behavior

### Fase 1: Analisi Prerequisiti
- ✅ Verifica architettura esiste (tech-stack.md)
- ✅ Identifica protocollo: REST
- ✅ Legge sitemap
- ✅ Comunica sintesi: "REST API, 2 entità (users, posts)"

### Fase 2: Estrazione Entità
- ✅ Da sitemap identifica:
  - User (da /users, /users/:id)
  - Post (da /posts, /posts/:id, /posts/new)
- ✅ Azioni:
  - User: CRUD standard
  - Post: CRUD + create form

### Fase 3: Design Endpoints
- ✅ Applica convenzioni REST:
  ```
  # Users
  GET    /api/v1/users           Lista users (paginated)
  GET    /api/v1/users/:id       Dettaglio user
  POST   /api/v1/users           Crea user
  PUT    /api/v1/users/:id       Aggiorna user
  DELETE /api/v1/users/:id       Elimina user

  # Posts
  GET    /api/v1/posts           Lista posts (paginated)
  GET    /api/v1/posts/:id       Dettaglio post
  POST   /api/v1/posts           Crea post
  PUT    /api/v1/posts/:id       Aggiorna post
  DELETE /api/v1/posts/:id       Elimina post
  ```

- ✅ Crea `docs/api-specs/api-signature-draft.md`
- ✅ Presenta **CHECKPOINT: API_SIGNATURE**

### Fase 4: Schema Sintetici
- ✅ Definisce schemas:
  ```json
  User: { id: uuid, name: string, email: string, created_at: datetime }
  Post: { id: uuid, title: string, body: string, user_id: uuid, created_at: datetime }
  ```
- ✅ Request/Response per endpoints critici (POST /users, POST /posts)
- ✅ Error codes standard (400, 401, 404, 409, 500)

### Fase 5: Finalizzazione
- ✅ Rinomina draft → finale
- ✅ Crea README.md
- ✅ Suggerisce: `/project-scaffolder`

## Expected Output

### api-signature.md Content
```markdown
# API Signature

Base URL: `/api/v1`
Auth: Bearer JWT

## Endpoints

### Users
| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | /users | Yes | Lista users |
| GET | /users/:id | Yes | Dettaglio |
| POST | /users | No | Registrazione |
| PUT | /users/:id | Yes | Aggiorna |
| DELETE | /users/:id | Yes | Elimina |

### Posts
| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | /posts | No | Lista posts pubblici |
| GET | /posts/:id | No | Dettaglio |
| POST | /posts | Yes | Crea post |
| PUT | /posts/:id | Yes | Aggiorna |
| DELETE | /posts/:id | Yes | Elimina |

## Schemas

### User
{ id: uuid, name: string, email: string, created_at: datetime }

### Post
{ id: uuid, title: string, body: string, user_id: uuid, created_at: datetime }
```

## Success Criteria
- ✅ Tutti endpoint CRUD presenti
- ✅ Auth specificato per ogni endpoint
- ✅ Schemas con types
- ✅ Base URL e convenzioni documentate
- ✅ Checkpoint presentato prima finalizzazione

## Pass/Fail

**PASS**: CRUD completo, schemas, checkpoint
**FAIL**: Endpoint mancanti, no auth specificato, no checkpoint
