# Error Handling - API Signature Generator

## Overview

Gestione errori actionable per generazione API signature. Processo critico che definisce contratto frontend-backend.

---

## Fase 1: Analisi Prerequisiti

### Prerequisito mancante: Architettura non trovata

**Errore**: File architettura non esistono in `docs/architecture/`.

**Recovery**:
1. Cerca varianti path:
   ```
   docs/architecture/overview.md
   docs/architecture/tech-stack.md
   docs/architecture-overview.md
   architecture.md
   ```

2. Se nessuna trovata:
   ```
   ❌ Prerequisito mancante: Architettura

   L'architettura definisce i PROTOCOLLI (REST, WebSocket, GraphQL)
   necessari per progettare API.

   Esegui prima: /architecture-designer

   Vuoi:
   A) Eseguire /architecture-designer ora
   B) Specificare path alternativo architettura
   C) Procedere con default (REST/HTTPS only)
   ```

3. Se C (default REST):
   - Assumo REST/HTTPS per tutte API
   - Documenta assunzione in api-signature.md
   - Warning: Real-time capabilities non disponibili

**Prevenzione**: Verificare checkpoint `architecture_overview` completato.

---

### Protocolli non definiti in architettura

**Errore**: Tech stack non specifica protocolli comunicazione.

**Recovery**:
1. Analizza requisiti da sitemap/brief:
   ```
   Protocolli non specificati in architettura.

   Analizzo requisiti:
   - Real-time requirements: [Rilevato da brief]
   - GraphQL mentions: [Rilevato da tech-stack]

   Propongo:
   - REST/HTTPS: CRUD operations (default)
   - WebSocket: [Se real-time requirement trovato]
   - GraphQL: [Se menzionato in tech-stack]

   Conferma o specifica protocolli: [input utente]
   ```

**Prevenzione**: Architecture Fase 3 (Tech Stack) dovrebbe sempre specificare protocolli.

---

### Sitemap non trovata

**Errore**: Sitemap mancante, quindi non so quali endpoint servono.

**Recovery**:
1. Cerca alternative:
   ```
   Sitemap non trovata.

   Fonti alternative per identificare endpoints:
   A) docs/user-stories.md (uso stories)
   B) docs/brief-structured.md (uso funzionalità)
   C) Chiedi elenco manuale entità

   Quale uso: [A/B/C]
   ```

2. Se C (manuale):
   ```
   Elenca entità principali dell'app (una per riga):

   Esempio:
   - User
   - Order
   - Product
   - ...
   ```

**Prevenzione**: Sitemap dovrebbe essere checkpoint bloccante prima di API.

---

## Fase 2: Estrazione Entità

### Pagina sitemap senza dati chiari

**Errore**: Pagina "Dashboard" identificata ma non chiaro quali dati mostra.

**Recovery**:
1. Inferisci da nome e contesto:
   ```
   Pagina "Dashboard" rilevata.

   Possibili entità (inferenza):
   - User profile data
   - Statistics/metrics
   - Recent activity

   Serve chiarimento: quali dati mostra la Dashboard?
   [input utente]
   ```

2. Se utente non risponde, usa placeholder:
   ```
   Usando placeholder per Dashboard:
   - GET /api/dashboard/summary

   Da dettagliare in implementazione.
   ```

**Prevenzione**: Sitemap dovrebbe documentare dati visualizzati per pagina.

---

### Entità duplicate con nomi diversi

**Errore**: "User" e "Account" sembrano stessa entità.

**Recovery**:
1. Identifica possibili duplicati:
   ```
   ⚠️ Possibili entità duplicate rilevate:

   - "User" (da Login page)
   - "Account" (da Settings page)

   Sono la stessa entità?
   A) Sì, usa "User"
   B) Sì, usa "Account"
   C) No, sono diverse
   ```

2. Se A o B, merge entità:
   ```
   Merging "Account" in "User".

   Endpoints:
   - GET /api/users/:id (profile + account info)
   ```

**Prevenzione**: Naming consistency nel brief e sitemap.

---

## Fase 3: Design Endpoints

### Endpoint naming conflicts

**Errore**: Due risorse vogliono stesso path (es: `/api/orders` per Orders e OrderHistory).

**Recovery**:
1. Disambigua:
   ```
   ⚠️ Conflitto path rilevato:

   /api/orders richiesto da:
   - Orders resource (CRUD orders)
   - OrderHistory resource (list storico)

   Risolvo con:
   A) /api/orders per Orders, /api/orders/history per storico
   B) /api/orders per Orders, /api/order-history per storico
   C) Naming diverso (suggerisci)

   Scelta: [A/B/C]
   ```

**Prevenzione**: Namespace chiaro per risorse nested.

---

### Action custom non mappabile a REST

**Errore**: "Send reminder" per Order non è CRUD standard.

**Recovery**:
1. Proponi pattern:
   ```
   Action custom: "Send reminder" su Order

   Opzioni REST-compliant:
   A) POST /api/orders/:id/reminders (resource nested)
   B) POST /api/orders/:id/send-reminder (action endpoint)
   C) PATCH /api/orders/:id con {"send_reminder": true}

   Consigliato: A (tratta reminder come sub-resource)

   Scelta: [A/B/C]
   ```

**Prevenzione**: Preferire resource-oriented design a action-oriented.

---

### Rate limiting non specificato

**Errore**: Nessuna indicazione rate limits per API pubbliche.

**Recovery**:
1. Proponi defaults basati su tipo endpoint:
   ```
   Rate limits non specificati.

   Propongo defaults:
   - Auth endpoints: 5 req/min (brute-force protection)
   - Read endpoints: 100 req/min
   - Write endpoints: 30 req/min
   - Public endpoints: 10 req/min per IP

   Conferma o specifica custom: [input utente]
   ```

**Prevenzione**: Architecture dovrebbe definire rate limiting policy.

---

## Fase 4: Schema Sintetici

### Schema mancano validation rules

**Errore**: Schema POST /api/users non ha validation (email format, password strength).

**Recovery**:
1. Aggiungi validation standard:
   ```
   Schema POST /api/users manca validation.

   Aggiungo regole standard:

   email:
   - required: true
   - format: email (RFC 5322)
   - unique: true

   password:
   - required: true
   - min_length: 8
   - requires: uppercase, lowercase, number

   Vuoi validation custom? [S/N]
   ```

**Prevenzione**: Template schema con validation rules standard.

---

### Schema troppo annidati (> 3 livelli)

**Errore**: Response schema ha 5 livelli nesting, complica client.

**Recovery**:
1. Analizza e proponi flattening:
   ```
   ⚠️ Schema response ha 5 livelli nesting:

   user.address.country.code.iso

   Suggerisco flattening:
   - user.address_country_code (più client-friendly)

   Oppure:
   - Separate endpoint GET /api/countries/:code

   Scelta: [Flatten / Separate / Mantieni nested]
   ```

**Prevenzione**: Preferire flat schemas quando possibile.

---

### Pagination mancante per liste

**Errore**: GET /api/orders ritorna lista senza pagination spec.

**Recovery**:
1. Aggiungi pagination standard:
   ```
   GET /api/orders ritorna lista senza pagination.

   Aggiungo pagination standard:

   Query params:
   - page: int (default 1)
   - limit: int (default 20, max 100)

   Response:
   {
     "data": [...],
     "meta": {
       "page": 1,
       "limit": 20,
       "total": 150,
       "total_pages": 8
     }
   }

   OK o preferisci cursor-based? [OK / Cursor]
   ```

**Prevenzione**: Template endpoints liste con pagination inclusa.

---

## Fase 5: Finalizzazione

### API signature troppo grande (> 50 endpoints)

**Errore**: API ha 80 endpoints, probabile over-design per MVP.

**Recovery**:
1. Analizza e proponi prioritization:
   ```
   ⚠️ API signature ha 80 endpoints.

   Tipico MVP ha 15-30 endpoints.

   Analisi:
   - 30 endpoints core (auth, user, main entities)
   - 25 endpoints admin features
   - 25 endpoints nice-to-have

   Suggerisco:
   A) MVP scope: Solo 30 core (implementa il resto dopo)
   B) Mantieni tutti (più lavoro, più tempo)
   C) Phased approach (v1: core, v2: admin, v3: features)

   Scelta: [A/B/C]
   ```

**Prevenzione**: Scope control in fase requirements.

---

### Versioning API non definito

**Errore**: Nessuna strategia versioning per API.

**Recovery**:
1. Proponi strategia:
   ```
   Versioning API non definito.

   Opzioni standard:
   A) URL versioning: /api/v1/users (consigliato)
   B) Header versioning: Accept: application/vnd.api+json;version=1
   C) Query param: /api/users?version=1

   Per MVP consiglio A (più semplice, chiaro).

   Scelta: [A/B/C]
   ```

2. Aggiorna tutti endpoints con versioning scelto

**Prevenzione**: Architecture dovrebbe definire versioning strategy.

---

## Errori Cross-Phase

### Utente chiede GraphQL dopo aver generato REST

**Scenario**: API signature completa in REST, utente chiede GraphQL.

**Recovery**:
1. Valuta impatto:
   ```
   Vuoi cambiare da REST a GraphQL.

   Impatto:
   - API signature deve essere rigenerata completamente
   - Schema GraphQL diverso da REST endpoints
   - Tech stack checkpoint da aggiornare (Fase 3 architecture)

   Opzioni:
   A) Torna a architecture, approva GraphQL, rigenera API
   B) Hybrid: REST per CRUD, GraphQL per query complesse
   C) Mantieni REST per MVP, valuta GraphQL v2

   Scelta: [A/B/C]
   ```

**Prevenzione**: Protocolli chiari in architecture prima di API design.

---

### Frontend chiede endpoint non previsto

**Scenario**: Durante implementazione, frontend scopre serve endpoint non in signature.

**Recovery**:
1. Valuta se add o redesign:
   ```
   Richiesto nuovo endpoint: GET /api/users/:id/notifications

   Opzioni:
   A) Aggiungi a signature (hot-add, no re-approval)
   B) Redesign (maybe meglio /api/notifications?user_id=X)
   C) Usa endpoint esistente + client filtering

   Se A (hot-add):
   - Aggiungo a api-signature.md
   - Notifico via comment "Added post-approval"
   - Implementa direttamente

   Scelta: [A/B/C]
   ```

**Prevenzione**: Thorough analysis in Fase 2 (extract entities).

---

## Best Practices Error Handling

1. **RESTful defaults**: Quando in dubbio, seguire convenzioni REST standard

2. **Security first**: Rate limits, validation, authentication sempre inclusi

3. **Client-friendly**: Preferire flat schemas, pagination, versioning chiaro

4. **Graceful evolution**: Permettere hot-add endpoint senza invalidare signature

5. **Document assumptions**: Ogni default/assunzione va documentata in signature

6. **Validate against architecture**: API deve seguire protocolli definiti in architecture
