---
name: api-signature-generator
description: Genera firma API (endpoints, metodi, dati principali) partendo da frontend specs o sitemap. Output api-signature.md come checkpoint per approvazione.
---

# API Signature Generator

## Il Tuo Compito

Generare la **firma delle API** (endpoints, metodi HTTP, dati principali) che definisce il contratto frontend-backend.

**Focus**: COSA espone il backend (endpoints), non COME lo implementa (codice).

**Prerequisito**: Architettura approvata (checkpoint `architecture_overview` completato). L'architettura definisce i protocolli (REST, WebSocket, GraphQL, MQTT).

**Output**: `docs/api-specs/api-signature.md` - documento checkpoint per approvazione prima di implementazione.

---

## Materiali di Riferimento

**Template**:
- `templates/api-signature-template.md` - Template completo api-signature con convenzioni REST, WebSocket, MQTT, error codes

**Reference**:
- `reference/error-handling.md` - Gestione errori actionable per ogni fase

---

## Workflow: 5 Fasi con Checkpoint

```
Fase 1: Analisi Prerequisiti   → Verifica architettura, legge sitemap
Fase 2: Estrazione Entità      → Identifica risorse e azioni
Fase 3: Design Endpoints       → Crea api-signature-draft.md
        >>> CHECKPOINT: API_SIGNATURE <<<
Fase 4: Schema Sintetici       → Aggiunge request/response schemas
Fase 5: Finalizzazione         → Salva versione approvata
```

---

## Fase 1: Analisi Prerequisiti

### Obiettivo
Verificare che l'architettura sia definita e raccogliere informazioni per API design.

### Azioni

1. **Verifica prerequisito**: Architettura approvata
   ```
   Cerca: docs/architecture/overview.md O docs/architecture/tech-stack.md
   Se non esiste: "Esegui prima /architecture-designer"
   ```

2. **Leggi documenti architettura**:
   - `docs/architecture/overview.md` → Componenti
   - `docs/architecture/tech-stack.md` → Protocolli scelti
   - `docs/architecture/data-model.md` → Entità (se esiste)

3. **Identifica protocolli** da architettura:
   - REST/HTTPS per CRUD
   - WebSocket per real-time (se definito)
   - GraphQL (se scelto invece di REST)
   - gRPC (se microservizi)

4. **Leggi frontend specs**:
   ```
   Cerca in ordine:
   1. docs/frontend-specs/sitemap.md
   2. docs/frontend-specs/*.md
   3. docs/user-stories.md
   4. docs/brief-structured.md
   ```

5. **Comunica sintesi**:
   ```
   Analisi completata:

   Protocolli da architettura:
   - API principale: REST/HTTPS
   - Real-time: [WebSocket/MQTT/Nessuno]

   Documenti frontend analizzati:
   - sitemap.md: X pagine identificate
   - [altri documenti]

   Procedo con design API.
   ```

---

## Fase 2: Estrazione Entità

### Obiettivo
Identificare risorse (entità), relazioni e azioni necessarie.

### Azioni

1. **Per ogni pagina in sitemap**, identifica:
   - Dati visualizzati (quali entità?)
   - Azioni possibili (CRUD + custom)
   - Relazioni con altre pagine/entità

2. **Costruisci lista entità**:

   | Entità | Fonte (pagina) | Azioni |
   |--------|----------------|--------|
   | User | Login, Profile, Settings | CRUD, auth |
   | [Entità 2] | [Pagine] | [Azioni] |
   | [Entità 3] | [Pagine] | [Azioni] |

3. **Identifica relazioni**:
   ```
   User 1:N [Entità owned]
   [Entità A] N:N [Entità B]
   ```

4. **Identifica azioni custom** (oltre CRUD):
   - Azioni specifiche del dominio
   - Operazioni batch
   - Trigger/eventi

---

## Fase 3: Design Endpoints

### Obiettivo
Creare la firma delle API con tutti gli endpoints.

### Azioni

**Consulta `templates/api-signature-template.md` per template completo.**

1. Applica convenzioni REST (GET list/detail, POST create, PUT/PATCH update, DELETE remove)
2. Crea `docs/api-specs/api-signature-draft.md` usando template
3. Presenta CHECKPOINT con statistiche

```
═══════════════════════════════════════════════════════════════
>>> CHECKPOINT: API_SIGNATURE <<<
═══════════════════════════════════════════════════════════════

## API Signature Proposta

File: docs/api-specs/api-signature-draft.md

### Statistiche
- Endpoints REST totali: X
- Entità: Y
- Azioni custom: Z
- Real-time events: W (se applicabile)

### Endpoints per Categoria
[Lista sintetica categorie e conteggio]

### Protocolli Utilizzati
- REST: CRUD operations
- [WebSocket/MQTT]: [Se applicabile]

═══════════════════════════════════════════════════════════════

Approvi questa API signature?
```

4. **Usa AskUserQuestion** con opzioni:
   - **Approva**: Procedi a Fase 4
   - **Modifica**: Chiedi modifica file
   - **Rigenera**: Torna a Fase 3

---

## Fase 4: Schema Sintetici

**Consulta `templates/api-signature-template.md` per format schemas e error codes.**

1. Per ogni entità, definisci schema con fields (id, field:type, relations, timestamps)
2. Request/Response per endpoints critici (POST, PUT) con validation rules
3. Error codes standard (400 Validation, 401 Unauthorized, 403 Forbidden, 404 Not Found, 409 Conflict, 429 Rate Limited, 500 Internal)
4. Aggiorna draft con schemas

---

## Fase 5: Finalizzazione

### Obiettivo
Salvare versione approvata e preparare per implementazione.

### Azioni

1. **Leggi** `api-signature-draft.md` (versione approvata)

2. **Crea file definitivo** `docs/api-specs/api-signature.md`:
   - Rimuovi "DRAFT" dallo stato
   - Aggiungi "APPROVATO" con data

3. **Crea index** `docs/api-specs/README.md`:

```markdown
# API Specifications - [Nome Progetto]

## Documenti

| Documento | Descrizione | Stato |
|-----------|-------------|-------|
| [api-signature.md](api-signature.md) | Firma API (endpoints, metodi) | Approvato |

## Prossimi Step

1. `/project-scaffolder` - Struttura repository
2. Implementazione backend
3. (Opzionale) OpenAPI dettagliato per client generation
```

4. **Aggiorna** `progress.yaml`:
   ```yaml
   checkpoints_completed:
     - api_signature
   ```

5. **Comunica completamento**:
   ```
   API Signature approvata e salvata.

   File: docs/api-specs/api-signature.md

   Statistiche finali:
   - X endpoints REST
   - Y entità definite
   - Z schemas documentati

   Prossimo step: /project-scaffolder

   Vuoi generare OpenAPI dettagliato? (per client generation)
   → /api-specification-generator
   ```

---

## Regole Tool

- **SEMPRE** Read prima di processare
- Write per nuovi file
- AskUserQuestion per checkpoint
- **MAI** saltare checkpoint
- **MAI** procedere senza approvazione

---

## Gestione Errori

**Consulta `reference/error-handling.md` per procedure recovery complete.**

Errori gestiti per ogni fase:
- **Fase 1**: Prerequisiti mancanti (architettura, sitemap), protocolli non definiti
- **Fase 2**: Pagine senza dati chiari, entità duplicate
- **Fase 3**: Endpoint naming conflicts, actions custom non-REST, rate limiting
- **Fase 4**: Schema senza validation, nesting eccessivo, pagination mancante
- **Fase 5**: API troppo grande, versioning non definito
- **Cross-phase**: Cambio protocolli, endpoint non previsti

---

## Avvio Workflow

1. Verifica prerequisiti (architettura, sitemap)
2. Fase 1: Analisi
3. Fase 2: Estrazione entità
4. Fase 3: Design + CHECKPOINT
5. Fase 4: Schemas
6. Fase 5: Finalizzazione

**Principio**: API signature è il CONTRATTO. Frontend e Backend devono concordare su questa firma prima di implementare.
