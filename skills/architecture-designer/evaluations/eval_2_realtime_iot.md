# Evaluation 2: Real-Time IoT Application

## Scenario
Architettura per app IoT con real-time updates e device communication.

## Input

**docs/frontend-specs/sitemap.md**:
```markdown
# Sitemap

- /dashboard (real-time device status)
- /devices (lista dispositivi)
- /devices/:id (dettaglio + controlli)
- /analytics
```

**docs/brief-structured.md**:
```markdown
- Real-time: Sì (status dispositivi ogni 5sec)
- Devices: 100+ dispositivi connessi
- Communication: Bidirezionale (app → device commands)
- Offline: Parziale (cache ultimo stato)
```

### Invocazione
```
/architecture-designer
```

## Expected Behavior

### Fase 1: Analisi Requisiti
- ✅ Identifica requisiti critici:
  - Real-time: Sì → WebSocket o MQTT necessario
  - Bidirezionale: App invia comandi a devices
  - 100+ devices: Scalabilità moderata
  - Offline: Cache strategy

### Fase 2: Overview Componenti
- ✅ Identifica componenti EXTRA rispetto a web standard:
  - Mobile App (client)
  - Backend API (REST)
  - **Message Broker** (MQTT/RabbitMQ)
  - **WebSocket Server** (real-time push)
  - Database
  - **Cache** (Redis per ultimo stato devices)
- ✅ Diagramma include message broker
- ✅ Presenta checkpoint

### Fase 3: Tech Stack
- ✅ Propone stack real-time:
  - Mobile: Flutter
  - Backend: Node.js + Express
  - Database: PostgreSQL
  - **Message Broker: MQTT** (IoT-optimized)
  - **Cache: Redis**
  - **WebSocket: Socket.io**

- ✅ Protocolli comunicazione:
  - App → API: REST/HTTPS
  - App ← API: WebSocket
  - Device → Broker: MQTT
  - Broker → Backend: MQTT subscriber

- ✅ Motivazione scelte:
  - MQTT: lightweight, pub/sub, IoT standard
  - Redis: in-memory cache per device status
  - Socket.io: real-time push to mobile app

### Fase 4: Data Model
- ✅ Entità IoT-specific:
  ```
  User (standard)
  Device (id, name, type, status, last_seen, user_id FK)
  DeviceCommand (id, device_id FK, command, status, created_at)
  DeviceMetrics (id, device_id FK, metric_type, value, timestamp)
  ```
- ✅ Relazioni: User 1:N Device, Device 1:N DeviceCommand, Device 1:N DeviceMetrics

### Fase 5: User Flows
- ✅ Flussi IoT-specific:
  1. **Device Registration Flow**
  2. **Real-time Status Update Flow**:
     ```
     Device --MQTT--> Broker --Subscribe--> Backend
             --Update DB--> PostgreSQL
             --Cache--> Redis
             --WebSocket--> Mobile App (dashboard update)
     ```
  3. **Command Execution Flow**:
     ```
     Mobile App --REST POST /devices/:id/command--> Backend
             --Publish MQTT--> Broker
             --MQTT--> Device (execute)
             --MQTT response--> Broker --> Backend (update status)
     ```

- ✅ Error cases:
  - Device offline → 503 Service Unavailable
  - Command timeout → 408 Request Timeout
  - MQTT broker down → Fallback polling

### Fase 6: Finalizzazione
- ✅ File creati con architettura complessa
- ✅ README menziona componenti real-time

## Expected Output

### tech-stack.md Check
- ✅ Message Broker presente con motivazione IoT
- ✅ Cache layer presente con rationale (performance)
- ✅ Protocolli: REST + WebSocket + MQTT tutti documentati

### data-model.md Check
- ✅ Entità Device con fields IoT (status, last_seen, type)
- ✅ DeviceCommand per tracking comandi
- ✅ DeviceMetrics per telemetria (opzionale)

### user-flows.md Check
- ✅ Flow real-time con diagramma completo (Device → Broker → Backend → App)
- ✅ Flow bidirezionale documentato
- ✅ Error handling MQTT broker failures

## Success Criteria

- ✅ Architettura adatta a real-time (non solo REST)
- ✅ Message broker identificato e giustificato
- ✅ Cache layer per performance
- ✅ Protocolli multipli documentati (REST + WebSocket + MQTT)
- ✅ Data model include entità IoT-specific
- ✅ User flows mostrano comunicazione real-time

## Pass/Fail Criteria

**PASS se**:
- Message broker presente nell'architettura
- Protocolli real-time (WebSocket/MQTT) scelti
- Cache layer per device status
- User flows mostrano pub/sub pattern
- Error handling per device offline

**FAIL se**:
- Solo REST (no real-time)
- No message broker (bottleneck backend)
- Polling invece di push (inefficiente)
- Data model manca entità Device
- User flows non mostrano real-time flow
