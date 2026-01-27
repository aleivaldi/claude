# Evaluation 2: WebSocket + REST API

## Input

**docs/architecture/tech-stack.md**:
```markdown
Protocolli:
- REST/HTTPS: CRUD operations
- WebSocket: Real-time updates
```

**docs/frontend-specs/sitemap.md**:
```markdown
- /dashboard (real-time notifications)
- /chat/:id (real-time messaging)
```

## Expected Behavior

### Fase 3: Design Endpoints

#### REST Endpoints
```
GET  /api/v1/notifications    Lista notifiche
POST /api/v1/notifications/:id/read    Marca letto
```

#### WebSocket Events
```
Event: connect
Direction: Client → Server
Payload: { token: string }

Event: notification
Direction: Server → Client
Payload: { id: uuid, type: string, message: string, timestamp: datetime }

Event: message
Direction: Client ↔ Server
Payload: { chat_id: uuid, text: string, sender_id: uuid }
```

### Output

**api-signature.md** include sezione:
```markdown
## WebSocket Events

### Connection
- Endpoint: ws://api.example.com/ws
- Auth: JWT token in handshake

### Events

| Event | Direction | Payload | Description |
|-------|-----------|---------|-------------|
| connect | C→S | {token} | Authenticate |
| notification | S→C | {id, type, message} | Push notification |
| message | C↔S | {chat_id, text} | Chat message |
```

## Success Criteria
- ✅ REST + WebSocket sections separate
- ✅ Event direction specified (C→S, S→C, C↔S)
- ✅ Payload schemas per event
- ✅ Auth per WebSocket documentato

## Pass/Fail
**PASS**: Entrambi protocolli, directions, payloads
**FAIL**: Solo REST, WebSocket come REST endpoint, no directions
