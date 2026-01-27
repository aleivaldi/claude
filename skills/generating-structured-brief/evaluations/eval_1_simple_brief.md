# Evaluation 1: Simple Brief

## Test Scenario

**Tipo**: Brief semplice con informazioni di base presenti
**Expected Behavior**: Fase 1 con 2-4 domande di chiarimento, poi Fase 2 genera brief-structured.md

---

## Input: brief.md

```markdown
# Expense Tracker MVP

Vogliamo creare un'app per tracciare le spese aziendali.

Attualmente i dipendenti usano Excel manualmente e ci sono errori.

Vogliamo risolvere questo problema con un'app web.

Timeline: 3 mesi
Team: 2 sviluppatori
Budget: limitato
```

---

## Expected Behavior

### Fase 1: Analisi

Claude dovrebbe:
1. **Leggere brief.md** con Read tool
2. **Valutare completezza**: Problema menzionato, piattaforma indicata (web), timeline presente
3. **Identificare gap**:
   - Chi sono gli utenti esatti? (ruoli, numero)
   - Quante spese al mese? (scala)
   - Funzionalità core necessarie?
   - Workflow principale?
4. **Generare 2-4 domande** con formato corretto:
   - Domanda + Suggerimento copiabile + Perché

### Fase 2: Creazione

Dopo risposte dell'utente, Claude dovrebbe:
1. **Leggere brief.md aggiornato**
2. **Creare brief-structured.md** con Write tool
3. **Includere sezioni**:
   - Problema (chiaro)
   - Utenti e Contesto
   - Obiettivi
   - Funzionalità Primarie (2-4)
   - Workflow Principali (1-2)
   - Scope MVP
4. **Chiedere conferma** con AskUserQuestion

---

## Success Criteria

- [ ] Fase 1 genera 2-4 domande (non più, non meno)
- [ ] Domande seguono formato: Domanda + Suggerimento + Perché
- [ ] brief-structured.md creato con Write tool
- [ ] Documento include almeno 6 sezioni obbligatorie
- [ ] Documento è stand-alone (nessun riferimento a brief.md o processo)
- [ ] Nessun marker [CONFERMATO], [AGGIUNTO], etc. nel documento
- [ ] AskUserQuestion usato per conferma finale
- [ ] Suggerisce skill generating-requirements-document al termine

---

## Common Pitfalls to Avoid

- ❌ Troppi dettagli tecnici in Fase 1 (stack, DB, framework)
- ❌ Troppe domande (>8)
- ❌ Suggerimenti non copiabili (es. "Suggerimento: Utenti")
- ❌ brief-structured.md con markers o riferimenti al processo
- ❌ Usare Write su brief.md (solo utente lo modifica)

---

## Evaluation Result

**Status**: [ ] Pass / [ ] Fail

**Notes**:
-
-
-

**Issues Found**:
-
-

**Suggested Improvements**:
-
-
