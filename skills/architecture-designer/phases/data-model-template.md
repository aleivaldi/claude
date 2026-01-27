# Fase 4: Data Model - Template

## Template File: data-model-draft.md

```markdown
# Data Model - [Nome Progetto]

> Stato: DRAFT - In attesa approvazione

## Entity Relationship Diagram

\```
┌──────────────┐       ┌──────────────┐
│    User      │       │   [Entity]   │
├──────────────┤       ├──────────────┤
│ id: UUID     │──────<│ id: UUID     │
│ email        │  1:N  │ userId: FK   │
│ ...          │       │ ...          │
└──────────────┘       └──────────────┘
\```

## Tabelle

### users
| Colonna | Tipo | Vincoli |
|---------|------|---------|
| id | UUID | PK, default uuid() |
| email | VARCHAR(255) | UNIQUE, NOT NULL |
| password_hash | VARCHAR(255) | NOT NULL |
| created_at | TIMESTAMP | DEFAULT now() |
| updated_at | TIMESTAMP | DEFAULT now() |

### [altre tabelle...]

## Indici

\```sql
CREATE INDEX idx_[table]_[column] ON [table]([column]);
\```

## Convenzioni

- Primary key: `id` (UUID)
- Foreign key: `[entity]_id`
- Timestamps: `created_at`, `updated_at`
- Soft delete: `deleted_at` (nullable)
```

## Template Checkpoint Presentation

```
═══════════════════════════════════════════════════════════════
>>> CHECKPOINT: DATA_MODEL <<<
═══════════════════════════════════════════════════════════════

## Data Model Proposto

File: docs/architecture/data-model-draft.md

### Entità
- [Lista entità con relazioni]

### Impatto su API
- Endpoints CRUD per ogni entità
- Relazioni determinano nested resources

═══════════════════════════════════════════════════════════════

Approvi questo data model?
```

## Azioni Complete

1. **Identifica entità** da sitemap e requisiti funzionali
2. **Definisci relazioni** (1:1, 1:N, N:N)
3. **Crea file** `docs/architecture/data-model-draft.md` con Write tool
4. **Presenta checkpoint** con AskUserQuestion
5. **Gestisci risposta**: Approva → Fase 5, Modifica → Rileggi e ripresenta

## Best Practices Data Modeling

### Entità Base (Quasi Sempre)
- **User**: Autenticazione e profilo
- **Session**: Tracking sessioni (opzionale se JWT)

### Convenzioni Standard
- **UUID** per PK (migliore per distributed systems)
- **Timestamps**: `created_at`, `updated_at` SEMPRE
- **Soft delete**: `deleted_at` se serve storico
- **Audit**: `created_by`, `updated_by` se multi-utente

### Indici Critici
- Email user (unique)
- Foreign keys (performance joins)
- Colonne filtrate frequentemente
- Colonne ordinate frequentemente

### Naming
- Tabelle: plurale snake_case (`users`, `order_items`)
- Colonne: snake_case (`user_id`, `created_at`)
- FK: `[entity_singular]_id`
