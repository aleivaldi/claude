# Error Handling - Backend Architecture Designer

## Errori per Fase

### Fase 1: Analyze Context

| Errore | Causa | Recovery |
|--------|-------|----------|
| Tech stack file mancante | `/architecture-designer` non eseguito | "Per procedere serve tech-stack.md. Esegui prima /architecture-designer" |
| Tech stack incompleto | File esiste ma mancano sezioni | Leggi file, identifica sezioni mancanti, chiedi all'utente |
| Stack non supportato | Runtime/framework sconosciuto | "Stack [X] non supportato. Posso proporre alternativa?" |

**Recovery steps**:
1. Verifica esistenza `docs/architecture/tech-stack.md`
2. Se manca → STOP con messaggio chiaro
3. Se esiste → Leggi e valida contenuto
4. Se incompleto → Identifica gap, chiedi chiarimenti

### Fase 2: Service Architecture

| Errore | Causa | Recovery |
|--------|-------|----------|
| Troppi layer proposti | Over-engineering | Riduci a 4 layer max (routes, controllers, services, repositories) |
| Service troppo granulari | Microservices prematura | Suggerisci consolidamento per MVP |
| Dipendenze circolari | Design flaw | Identifica ciclo, proponi ristrutturazione |

**Recovery steps**:
1. Se proponi > 6 services per MVP → Consolida
2. Se dipendenze circolari → Visualizza grafo, proponi soluzione
3. Se layer > 4 → Giustifica o riduci

### Fase 3: Cross-cutting Concerns

| Errore | Causa | Recovery |
|--------|-------|----------|
| Middleware order errato | Auth dopo route handler | Correggi ordine standard (vedi SKILL.md) |
| Error handling mancante | No global error handler | Aggiungi sempre come ultimo middleware |
| Validation inconsistente | Mix di librerie | Standardizza su una (Zod per TS, Pydantic per Python) |

**Recovery steps**:
1. Valida middleware order → Correggi se necessario
2. Verifica error handling hierarchy → Completa se mancante
3. Controlla validation approach → Una libreria sola

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

1. **Prerequisiti mancanti**: tech-stack.md non esiste
2. **Stack non supportato**: Nessuna alternativa possibile
3. **Conflitti irrisolvibili**: Decisioni incompatibili senza input utente
4. **Max retry superato**: 3 tentativi di recovery falliti

---

## Quando Continuare (AUTO-RECOVERY)

1. **Directory mancante**: Crea automaticamente
2. **Ordine middleware errato**: Correggi automaticamente
3. **Testing comandi mancanti**: Aggiungi default per stack
4. **Draft esistente**: Sovrascrivi (con backup)
