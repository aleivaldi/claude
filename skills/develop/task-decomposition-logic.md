# Block Decomposition Logic

## Obiettivo

Decomporre milestone in **blocchi funzionali coesi** che formano un dependency DAG. Ogni blocco e' un'unita' implementativa completa con il proprio ciclo impl -> review -> test.

## Algoritmo Decomposizione

### Input
- Milestone scope (feature/modulo da implementare)
- API signature (endpoints e schemas)
- Architecture docs (componenti, servizi, patterns)
- Frontend/Backend architecture docs (directory structure, patterns)
- Codebase esistente (per dipendenze)

### Output
- Lista blocchi con:
  - ID univoco
  - Scope (cosa implementa)
  - File implementation (da creare/modificare)
  - File unit test (scritti dall'implementer per logica interna)
  - File contract test (scritti dal test-writer per interfacce pubbliche)
  - Contratti/interfacce (API schemas, tipi, signatures usati dal test-writer)
  - Expected unit tests (Track 1): lista `[service.method: descrizione 1 riga]`
  - Expected contract tests (Track 2): lista `[METHOD /path: descrizione 1 riga]`
  - Dipendenze (altri blocchi ID)
  - Tipo implementer (backend-implementer / frontend-implementer)

## Strategia Decomposizione

### 1. Identificazione Blocchi da API Signature

Per ogni gruppo di endpoint correlati:

```
POST /api/auth/login
POST /api/auth/register
POST /api/auth/refresh
GET  /api/auth/me
->
  Blocco: auth-service (backend)
  Scope: Authentication service completo
  Files impl: src/services/auth.ts, src/routes/auth.ts, src/middleware/auth.ts
  Unit tests: tests/unit/auth.service.test.ts  (Track 1: logica interna)
  Contract tests: tests/integration/auth.api.test.ts  (Track 2: interfacce)
  Contratti: LoginDTO, RegisterDTO, AuthResponse schema, JWT token format
  Deps: [] (nessuna)
```

### 2. Criteri Decomposizione Blocco

**Un buon blocco**:
- E' un'unita' funzionale coesa (1 servizio, 1 feature, 1 modulo)
- Ha file non sovrapposti con altri blocchi paralleli
- Ha contratti/interfacce ben definiti (per il test-writer)
- Ha dipendenze esplicite e minimali
- Dimensione gestibile (1 service completo, non singole funzioni)

**Troppo granulare** (NO):
```
Blocco 1: Define User interface
Blocco 2: Implement getUser
Blocco 3: Implement createUser
-> Overhead coordinamento, file conflicts
```

**Giusto** (SI):
```
Blocco 1: User service (tutto CRUD + validazione)
  Files impl: src/services/user.ts, src/routes/user.ts
  Unit tests: tests/unit/user.service.test.ts  (Track 1: implementer)
  Contract tests: tests/integration/user.api.test.ts  (Track 2: test-writer)
  Contratti: CreateUserDTO, UpdateUserDTO, UserResponse, validation rules
  Expected unit tests (Track 1):
    - user.service.create: validates email uniqueness
    - user.service.update: merges partial fields correctly
    - user.service.delete: cascades soft-delete to related entities
  Expected contract tests (Track 2):
    - POST /users: returns 201 with safe user object
    - POST /users: returns 409 for duplicate email
    - GET /users/:id: returns 200 with user
    - GET /users/:id: returns 404 for unknown id
    - PUT /users/:id: returns 200 with updated user
    - DELETE /users/:id: returns 204
```

**Troppo grosso** (NO):
```
Blocco 1: Tutto il backend
-> Review alla fine vanifica il vantaggio dei blocchi
```

### 3. Raggruppamento per Tipo

#### Blocchi Backend
Raggruppati per servizio/dominio:
```
auth-service: login, register, refresh, JWT middleware
device-service: CRUD devices, status updates
order-service: create order, payment flow
notification-service: push, email, websocket
```

#### Blocchi Frontend
Raggruppati per screen/feature:
```
login-ui: login screen, register screen, auth state
device-dashboard: device list, device detail, status cards
admin-panel: user management, settings screens
```

#### Blocchi Shared (se necessari)
```
shared-types: DTO interfaces, enums, constants
db-migrations: database schema setup
```

### 4. Identificazione Contratti per Blocco

Per ogni blocco, identifica i **contratti** che il test-writer usera':

```yaml
block: auth-service
contracts:
  endpoints:
    - method: POST
      path: /api/auth/login
      request: { email: string, password: string }
      response: { token: string, user: { id, email, role } }
      errors: [400 invalid input, 401 wrong credentials]
    - method: POST
      path: /api/auth/register
      request: { email: string, password: string, name: string }
      response: { token: string, user: { id, email, role } }
      errors: [400 invalid input, 409 email exists]
  types:
    - LoginDTO: { email: string, password: string }
    - RegisterDTO: { email: string, password: string, name: string }
    - AuthResponse: { token: string, user: User }
  validation:
    - email: valid format
    - password: min 8 chars, 1 uppercase, 1 number
```

## Dependency DAG

### Costruzione

```python
def build_dependency_dag(blocks):
    dag = {}

    for block in blocks:
        deps = []

        # Dipendenze logiche (servizio richiede altro servizio)
        if block.imports_from(other_block):
            deps.append(other_block.id)

        # Dipendenze database (richiede tabelle create da altro blocco)
        if block.uses_table_created_by(other_block):
            deps.append(other_block.id)

        # Dipendenze middleware (richiede auth middleware)
        if block.requires_auth and "auth-service" != block.id:
            deps.append("auth-service")

        # Dipendenze shared types
        if block.uses_shared_types and "shared-types" in block_ids:
            deps.append("shared-types")

        dag[block.id] = deps

    validate_no_cycles(dag)
    return dag
```

### Regole Dipendenze

| Tipo dipendenza | Esempio | Azione |
|---|---|---|
| Logica | user-profile richiede auth | auth -> user-profile |
| Database | order richiede tabella users | user-service -> order-service |
| Shared types | entrambi usano UserDTO | shared-types -> entrambi |
| File conflict | due blocchi scrivono stesso file | Merge in 1 blocco o aggiungi dipendenza |
| Frontend -> Backend | UI chiama API backend | Nessuna (frontend usa contratto API, non backend running) |

**NOTA**: Frontend e backend sono tipicamente **indipendenti** perche' frontend usa il contratto API (non il backend running). Quindi possono eseguire in parallelo.

### Validazione DAG

```python
def validate_decomposition(blocks, dag):
    # 1. No circular dependencies
    assert no_cycles(dag), "Circular dependency detected"

    # 2. No file conflicts tra blocchi paralleli
    parallel_groups = compute_parallel_groups(dag)
    for group in parallel_groups:
        assert no_file_conflicts(group), "File conflict in parallel blocks"

    # 3. Tutte le dipendenze esistono
    all_ids = {b.id for b in blocks}
    for block_id, deps in dag.items():
        for dep in deps:
            assert dep in all_ids, f"Dependency {dep} not found"

    # 4. Granularita' ragionevole
    for block in blocks:
        assert len(block.implementation_files) >= 1, "Block too small"
        assert len(block.implementation_files) <= 15, "Block too large, consider splitting"
```

## Ordine Esecuzione

### Topological Sort

```python
def compute_execution_order(dag):
    """
    Ritorna lista di turni. Ogni turno contiene blocchi eseguibili in parallelo.
    """
    turns = []
    completed = set()
    remaining = set(dag.keys())

    while remaining:
        current_turn = [
            block_id for block_id in remaining
            if all(dep in completed for dep in dag[block_id])
        ]

        if not current_turn:
            raise Exception("Circular dependency detected!")

        turns.append(current_turn)
        completed.update(current_turn)
        remaining -= set(current_turn)

    return turns
```

### Esempio Output

```
Milestone: User Management + Device Control

Blocchi:
  1. shared-types     -> deps: []
  2. auth-service     -> deps: [shared-types]
  3. device-service   -> deps: [shared-types]
  4. user-profile     -> deps: [auth-service]
  5. login-ui         -> deps: []  (usa contratto API)
  6. device-dashboard -> deps: []  (usa contratto API)
  7. admin-panel      -> deps: [auth-service, device-service]

Ordine esecuzione:
  Turno 1: shared-types, login-ui, device-dashboard  (3 blocchi paralleli)
  Turno 2: auth-service, device-service              (2 blocchi paralleli)
  Turno 3: user-profile, admin-panel                 (2 blocchi paralleli)
```

## Edge Cases

### Shared Types/Interfaces

Se piu' blocchi usano stessi tipi:

**Opzione 1** (preferita): Blocco `shared-types` separato
```
Blocco 0: shared-types
  Files: src/types/*.ts
  Deps: []

Blocco 1, 2, 3: dipendono da shared-types
```

**Opzione 2**: Se tipi sono pochi, ogni blocco li definisce inline e reviewer consolida dopo.

### Database Migrations

Migrations sono sequenziali per natura:

```
Opzione 1: Blocco db-migrations separato (primo)
  -> Crea tutte le tabelle
  -> Tutti i service blocks dipendono da questo

Opzione 2: Ogni service block include le sue migration
  -> Assegna range migration numbers per turno
  -> Turno 1: 001-010, Turno 2: 011-020
```

### Frontend che dipende da Backend API

Frontend NON dipende dal backend block. Frontend usa il **contratto API** (api-signature.md) che e' gia' definito e approvato. Quindi frontend e backend eseguono in parallelo.

Eccezione: se frontend richiede backend **running** per integration test, aggiungi dipendenza esplicita solo per la fase di test run.

## Derivazione Test da Contratti

Le liste di test previsti vengono derivate automaticamente durante la decomposizione:

### Test Track 2 (Contract) - da API Signature

Per ogni endpoint del blocco:
- **Happy path**: 1 test per response 2xx dichiarata
- **Errori dichiarati**: 1 test per ogni codice errore nella spec (400, 401, 404, 409, etc.)

```
Endpoint: POST /api/auth/register
  Response: 201 Created
  Errors: 400 invalid input, 409 email exists
  ->
  Tests:
    - POST /auth/register: returns 201 with token and user
    - POST /auth/register: returns 400 for invalid input
    - POST /auth/register: returns 409 for existing email
```

### Test Track 1 (Unit) - da Business Logic

Per ogni service method con business logic non banale:
- 1 riga che descrive cosa valida/calcola/trasforma

```
Service: auth.service
  Methods: login, register, refreshToken, validateJwt
  ->
  Tests:
    - auth.service.login: verifies password hash match
    - auth.service.register: hashes password before save
    - auth.service.refreshToken: rejects expired tokens
    - auth.service.validateJwt: extracts user claims
```

Non elencare test per CRUD semplice senza business logic (getter/setter diretti su DB).

### Conteggio

Il checkpoint 3c include in fondo:
```
Tests previsti: N unit + M contract = T total
```

Questo conteggio serve come riferimento per validare che Track 1 e Track 2 producano test sufficienti.

---

## Output Formato per Checkpoint

```
Decomposizione Milestone [Name]:

Blocchi identificati: [N]

+-----+--------------------+----------+------------------+-----------------+
| #   | Blocco             | Tipo     | Files            | Dipendenze      |
+-----+--------------------+----------+------------------+-----------------+
| B1  | shared-types       | shared   | src/types/*.ts   | -               |
| B2  | auth-service       | backend  | src/services/... | B1              |
| B3  | device-service     | backend  | src/services/... | B1              |
| B4  | login-ui           | frontend | lib/screens/...  | -               |
| B5  | device-dashboard   | frontend | lib/screens/...  | -               |
| B6  | admin-panel        | frontend | lib/screens/...  | B2, B3          |
+-----+--------------------+----------+------------------+-----------------+

Ordine esecuzione:
  Turno 1: B1, B4, B5       (3 blocchi, 6 agenti)
  Turno 2: B2, B3           (2 blocchi, 4 agenti)
  Turno 3: B6               (1 blocco, 2 agenti)

Parallelismo massimo: 6 agenti (Turno 1)
```

Questo formato viene presentato al **checkpoint BLOCK_DECOMPOSITION** per approvazione utente.
