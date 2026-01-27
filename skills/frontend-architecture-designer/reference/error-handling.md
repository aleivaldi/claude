# Error Handling - Frontend Architecture Designer

## Errori per Fase

### Fase 1: Analyze Context

| Errore | Causa | Recovery |
|--------|-------|----------|
| Tech stack file mancante | `/architecture-designer` non eseguito | "Per procedere serve tech-stack.md. Esegui prima /architecture-designer" |
| Sitemap mancante | `/sitemap-generator` non eseguito | "Per procedere serve sitemap.md. Esegui prima /sitemap-generator" |
| Stack non supportato | Framework sconosciuto | "Framework [X] non supportato. Posso proporre alternativa?" |

**Recovery steps**:
1. Verifica esistenza `docs/architecture/tech-stack.md`
2. Verifica esistenza `docs/frontend-specs/sitemap.md`
3. Se mancano → STOP con messaggio chiaro
4. Se esistono → Leggi e valida contenuto

### Fase 2: Component Architecture

| Errore | Causa | Recovery |
|--------|-------|----------|
| Pattern non chiaro | Nessun pattern specificato | Proponi feature-based di default |
| Directory structure errata | Non segue framework conventions | Correggi secondo best practices del framework |
| Troppi layer | Over-engineering | Semplifica a 3 layer (components, hooks, lib) |

**Recovery steps**:
1. Se pattern non specificato → Usa feature-based
2. Se directory non standard → Proponi alternativa con giustificazione
3. Se troppo complesso → Riduci, MVP first

### Fase 3: State Management

| Errore | Causa | Recovery |
|--------|-------|----------|
| State library non specificata | Missing da tech-stack | Proponi default per framework |
| Over-fetching data | Troppi store | Consolida, usa server state |
| State non tipizzato | TypeScript ignorato | Aggiungi types obbligatori |

**Recovery steps**:
1. Se state library manca → Zustand per React, Riverpod per Flutter
2. Se troppi store → Riduci a max 3-4 global stores
3. Se types mancano → Definisci interfaces obbligatorie

### Fase 4: Draft + Testing

| Errore | Causa | Recovery |
|--------|-------|----------|
| File draft già esiste | Esecuzione precedente interrotta | Chiedi: "Draft esistente. Sovrascrivere?" |
| Directory architecture mancante | Primo run | Crea `docs/architecture/` |
| Testing strategy incompleta | Mancano comandi | Aggiungi comandi standard per stack |

**Recovery steps**:
1. Se draft esiste → Chiedi conferma sovrascrittura
2. Se directory manca → Crea con `mkdir -p`
3. Se testing incompleto → Usa comandi default per stack

### Fase 5: Finalization

| Errore | Causa | Recovery |
|--------|-------|----------|
| Checkpoint rifiutato | Utente vuole modifiche | Rileggi feedback, applica, ripresenta |
| Rinomina fallita | File locked | Riprova, se fallisce notifica utente |
| README update fallito | README non esiste | Crealo con template base |

**Recovery steps**:
1. Se rifiutato → Leggi feedback, modifica, loop checkpoint
2. Se rinomina fallisce → Log errore, notifica utente
3. Se README manca → Crea con sezione architecture

---

## Error Response Template

```
❌ Errore: [TIPO_ERRORE]

Causa: [Descrizione causa]

Recovery:
1. [Azione 1]
2. [Azione 2]

Procedo con recovery automatico? [S/N]
```

---

## Quando Fermarsi (STOP)

1. **Prerequisiti mancanti**: tech-stack.md o sitemap.md non esistono
2. **Framework non supportato**: Nessuna alternativa possibile
3. **Conflitti irrisolvibili**: Decisioni incompatibili senza input utente
4. **Max retry superato**: 3 tentativi di recovery falliti

---

## Quando Continuare (AUTO-RECOVERY)

1. **Directory mancante**: Crea automaticamente
2. **Pattern non specificato**: Usa default per framework
3. **Testing comandi mancanti**: Aggiungi default per stack
4. **Draft esistente**: Sovrascrivi (con backup)
