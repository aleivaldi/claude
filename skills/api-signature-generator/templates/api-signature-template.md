# Template: API Signature

```markdown
# API Signature - [Nome Progetto]

> Stato: DRAFT - In attesa approvazione
> Generato: [data]
> Versione: 1.0
> Base URL: `/api/v1`

## Protocolli

| Protocollo | Use Case | Note |
|------------|----------|------|
| REST/HTTPS | CRUD operations | Standard |
| [WebSocket] | [Real-time updates] | [Se previsto] |
| [MQTT] | [IoT communication] | [Se previsto] |

## Convenzioni

- Autenticazione: Bearer JWT
- Content-Type: application/json
- Pagination: `?page=1&limit=20`
- Sorting: `?sort=field&order=asc|desc`
- Filtering: `?field=value`

## Error Format

\```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human readable message",
    "details": {}
  }
}
\```

## Endpoints

### Authentication

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| POST | /auth/register | Registrazione utente | No |
| POST | /auth/login | Login utente | No |
| POST | /auth/logout | Logout | Yes |
| POST | /auth/refresh | Refresh token | Yes |
| POST | /auth/forgot-password | Richiedi reset | No |
| POST | /auth/reset-password | Esegui reset | No |

### Users

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| GET | /users/me | Profilo corrente | Yes |
| PUT | /users/me | Aggiorna profilo | Yes |
| DELETE | /users/me | Elimina account | Yes |

### [Entità Principale]

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| GET | /[resources] | Lista con pagination | Yes |
| GET | /[resources]/:id | Dettaglio | Yes |
| POST | /[resources] | Crea nuovo | Yes |
| PUT | /[resources]/:id | Aggiorna | Yes |
| DELETE | /[resources]/:id | Elimina | Yes |
| POST | /[resources]/:id/[action] | [Azione custom] | Yes |

## Endpoints Real-Time (se applicabile)

### WebSocket

| Event | Direction | Description |
|-------|-----------|-------------|
| connect | Client→Server | Connessione autenticata |
| [event_name] | Server→Client | [Descrizione] |
| [event_name] | Client→Server | [Descrizione] |

### MQTT Topics (se applicabile)

| Topic Pattern | Publisher | Subscriber | Description |
|---------------|-----------|------------|-------------|
| [topic/pattern] | [Chi] | [Chi] | [Descrizione] |

## Schemas

### [Entity]

\```
{
  id: uuid
  [field]: [type]
  [field]: [type] (optional)
  [relation]Id: uuid (FK)
  createdAt: datetime
  updatedAt: datetime
}
\```

### Request/Response Critici

#### POST /[resources]

**Request:**
\```json
{
  "[field]": "[type], required",
  "[field]": "[type], optional"
}
\```

**Response 201:**
\```json
{
  "data": {
    "id": "uuid",
    "[field]": "[value]"
  }
}
\```

**Errors:**
- 400: Validation error
- 401: Unauthorized
- 409: Conflict (duplicate)

## Error Codes

| Code | HTTP | Description |
|------|------|-------------|
| VALIDATION_ERROR | 400 | Dati non validi |
| INVALID_CREDENTIALS | 401 | Credenziali errate |
| UNAUTHORIZED | 401 | Token mancante/invalido |
| FORBIDDEN | 403 | Permessi insufficienti |
| NOT_FOUND | 404 | Risorsa non trovata |
| CONFLICT | 409 | Risorsa già esistente |
| RATE_LIMITED | 429 | Troppe richieste |
| INTERNAL_ERROR | 500 | Errore server |

## Decisioni Aperte

- [ ] Rate limiting specifici per endpoint
- [ ] Versioning strategy (v1, v2)
```
