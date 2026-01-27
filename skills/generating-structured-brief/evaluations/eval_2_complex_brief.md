# Evaluation 2: Complex Brief with Many Gaps

## Test Scenario

**Tipo**: Brief vago con molti gap da colmare
**Expected Behavior**: Fase 1 con 6-8 domande strategiche, Fase 2 genera brief-structured.md completo con assunzioni

---

## Input: brief.md

```markdown
# Progetto Nuova Piattaforma

Vogliamo fare una piattaforma per gestire i clienti.

Ci serve qualcosa di moderno e facile da usare.

Abbiamo bisogno di tutto: gestione clienti, ordini, fatture, report.

Deve essere veloce e sicuro.
```

---

## Expected Behavior

### Fase 1: Analisi

Claude dovrebbe:
1. **Leggere brief.md** con Read tool
2. **Identificare brevità/vaghezza**: Problema non chiaro, utenti assenti, scope enorme, nessun vincolo
3. **Rilevare scope enorme**: "tutto" è red flag per MVP
4. **Generare 6-8 domande filtrate**:
   - Problema principale e pain point attuale
   - Chi sono gli utenti (ruoli specifici)
   - Scala (numero utenti, transazioni)
   - Funzionalità critiche vs nice-to-have (ridurre "tutto")
   - Timeline e vincoli
   - Priorità assoluta per MVP v1

### Fase 2: Creazione

Dopo risposte dell'utente, Claude dovrebbe:
1. **Leggere brief.md aggiornato** con tutte le risposte
2. **Creare brief-structured.md** con:
   - Problema chiaro e dettagliato
   - Utenti primari e secondari
   - Obiettivi realistici
   - **Assunzioni esplicitate** (sezione 5) con rationale
   - **Funzionalità Primarie** (2-4 must-have)
   - **Funzionalità Secondarie** (nice-to-have escluse da MVP)
   - Scope MVP **molto chiaro** su cosa è incluso/escluso
3. **Output in chat** con:
   - Riepilogo integrazioni dalle risposte
   - **Scelte tecniche da defaults.md** (piattaforma, scala, etc.)
4. **Chiedere conferma e metodo feedback**

---

## Success Criteria

- [ ] Fase 1 genera 6-8 domande strategiche (no dettagli tecnici)
- [ ] Domande aiutano a **ridurre scope** da "tutto" a MVP realistico
- [ ] brief-structured.md include sezione **Assunzioni** con rationale
- [ ] Sezione **Funzionalità Secondarie** presente (cose escluse da MVP)
- [ ] Scope MVP chiarissimo: "Incluso" vs "NON Incluso" vs "Fasi Future"
- [ ] Output in chat distingue:
   - Integrazioni dalle risposte utente
   - Scelte tecniche della skill (da defaults.md)
- [ ] Nessuna ridondanza tra sezioni (es. Funzionalità non ripetute in Scope)
- [ ] Review anti-ridondanza eseguita prima di presentare

---

## Common Pitfalls to Avoid

- ❌ Accettare scope enorme senza restringere
- ❌ Troppe funzionalità primarie (>5)
- ❌ Assunzioni tecniche (da defaults.md) scritte nel documento
- ❌ Mancanza sezione Funzionalità Secondarie (cose escluse)
- ❌ Ridondanza: funzionalità ripetute in Scope MVP
- ❌ Non comunicare scelte tecniche in chat

---

## Edge Cases to Handle

- **Scope infinito**: Claude deve aiutare a restringere con domande mirate
- **"Tutto subito"**: Claude deve proporre MVP realistico e fasi future
- **Informazioni contraddittorie**: Claude deve rilevare e chiedere chiarimento
- **Assunzioni necessarie**: Claude deve esplicitarle con rationale

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
