# Fase 5: User Flows Critici - Template

## Template File: user-flows-draft.md

```markdown
# User Flows - [Nome Progetto]

> Stato: DRAFT - In attesa approvazione

## Flow: Autenticazione

\```
┌─────────┐     ┌─────────┐     ┌─────────┐
│  Client │────▶│   API   │────▶│   DB    │
│  Login  │     │ /login  │     │ Verify  │
└─────────┘     └────┬────┘     └────┬────┘
                     │               │
                     │◄──────────────┘
                     │ Generate JWT
                     ▼
              ┌─────────────┐
              │ Return Token│
              └─────────────┘
\```

### Passaggi
1. Client invia credentials
2. API valida contro DB
3. Se valido: genera JWT
4. Ritorna token + user info

### Error Cases
- Credentials invalide → 401
- Account locked → 403
- Rate limited → 429

## Flow: [Altro flusso critico]
...
```

## Template Checkpoint Presentation

```
═══════════════════════════════════════════════════════════════
>>> CHECKPOINT: USER_FLOWS <<<
═══════════════════════════════════════════════════════════════

## User Flows Critici

File: docs/architecture/user-flows-draft.md

### Flussi Documentati
1. Autenticazione
2. [Flusso 2]
3. [Flusso 3]

═══════════════════════════════════════════════════════════════

Approvi questi flussi?
```

## Azioni Complete

1. **Identifica flussi critici** (max 3-5): Autenticazione + flussi core business
2. **Per ogni flusso** crea diagramma ASCII + passaggi + error cases
3. **Crea file** `docs/architecture/user-flows-draft.md` con Write tool
4. **Presenta checkpoint** con AskUserQuestion
5. **Gestisci risposta**: Approva → Fase 6, Modifica → Rileggi e ripresenta

## Flussi Tipici da Documentare

### Autenticazione (Quasi Sempre)
- Login
- Register
- Password reset
- Token refresh

### Business Logic Core
- Flusso principale valore applicazione
- Es. E-commerce: Checkout flow
- Es. Social: Post creation
- Es. IoT: Device pairing

### Flussi Real-Time (se applicabile)
- WebSocket handshake
- Event subscription
- Data push

### Flussi Complessi/Rischiosi
- Payment processing
- Multi-step workflows
- External integrations

## Diagrammi Best Practices

### Componenti nel Diagramma
- **Client**: Iniziatore flusso
- **API**: Endpoint specifici
- **Database**: Operazioni CRUD
- **External**: Servizi terze parti
- **Cache**: Se impatta flusso

### Frecce
- `───▶` : Request sincrona
- `◄───` : Response
- `─ ─▶` : Request asincrona
- `- - -` : Dipendenza/relationship

### Error Handling
Documenta TUTTI i possibili errori con HTTP status codes appropriati
