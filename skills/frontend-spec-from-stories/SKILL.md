---
name: frontend-spec-from-stories
description: Genera Frontend Specifications funzionali (Sitemap + Screen Inventory) da user stories o project brief. Processo interattivo in 7 fasi focalizzato su COSA fa ogni schermata (dati, azioni, input) non COME (layout, UX). Output Markdown sintetico ma esaustivo, input per UI/UX experts. Supporta iterazione via edit diretto, commenti o chat. Adatta lingua automaticamente a input ricevuto (italiano/inglese).
---

# Frontend Specifications Generator

## Il Tuo Compito

Genera un documento di **Frontend Specifications funzionali** (Sitemap + Screen Inventory) partendo da user stories o project brief. Guidi l'utente attraverso un processo interattivo in 7 fasi, focalizzandoti su **requisiti funzionali** (cosa fa ogni schermata) non su soluzioni implementative o estetiche (come è fatto). Supporti iterazione fino a soddisfazione dell'utente.

**Obiettivo finale**: Documento Markdown sintetico ma esaustivo, contenente sitemap, specifiche funzionali per ogni screen, navigation flows. Pronto per essere usato per mostrare a cliente possibile e soluzione e  da UI/UX experts come input per decisioni di design.

---

## Adattamento Lingua

**SEMPRE adatta la lingua all'input ricevuto:**
- Input in italiano → tutto l'output in italiano
- Input in inglese → tutto l'output in inglese
- Mantieni consistenza linguistica per tutta la sessione

---

## Quando Usare Questa Skill

Invoca quando l'utente:
- Ha user stories e chiede "specifiche frontend" o "screen inventory"
- Vuole "definire le pagine/schermate dell'applicazione"
- Chiede "sitemap" o "da user stories a schermate"
- Vuole generare specs anche solo da project brief (senza stories)
- Vuole modificare/iterare su frontend specs esistenti

---

## Processo Interattivo in 7 Fasi

### Fase 0: Analisi Iniziale e Scope

**Azioni**:
1. ✅ **Read** il documento input (user stories o brief) fornito dall'utente
2. Identifica:
   - Presenza di multiple applicazioni (es: web app + admin panel + mobile app)
   - Ruoli utente menzionati
   - Piattaforme target (web/mobile/both)
3. **SE multiple app identificate**: usa **AskUserQuestion** per chiedere quale generare (o proponi sequenza)
4. Conferma scope identificato brevemente all'utente

**Output fase**: Scope chiaro, app target definita.

---

### Fase 1: Chiarimenti Critici (SOLO se necessario)

**PRINCIPIO**: Chiedi SOLO per ambiguità reali. Se evidente dal documento, procedi senza chiedere.

**Usa AskUserQuestion SOLO per**:
- **App structure o funzionalità ambigua**: non è chiaro cosa vuole l'utente e ci sono diverse opzioni che potrebbero essere valide
  - Proponi opzione raccomandata + alternatives con rationale
- **Piattaforme non specificate**: manca info web/mobile/both
- **Ruoli ambigui**: ruoli mal definiti nelle stories

**NON chiedere conferma su**:
- Ruoli evidenti dal documento
- Funzionalità chiaramente descritte
- Dettagli inferibili dal contesto

**Output fase**: Chiarimenti critici risolti.

---

### Fase 2: Scelte Architetturali (SE necessario)

**SOLO se necessario, chiedi scelte architetturali macro** che impattano la struttura:

**Quando chiedere**:
- App separata per admin vs sezione integrata
- Multiple app distinte (web user + mobile + admin panel)
- Struttura macro non deducibile dal documento

**Quando NON chiedere**:
- Pattern di navigazione (lascia a UI/UX expert)
- Layout specifici o pattern UX
- Dettagli implementativi

**Usa AskUserQuestion** solo per scelte architetturali critiche.

**Output fase**: Scelte architetturali macro confermate (se necessarie).

---

### Fase 3: Sitemap Structure

**Genera sitemap gerarchica** mostrando struttura  dell'applicazione.

**Azioni**:
1. Analizza user stories/brief per identificare aree logiche
2. Raggruppa funzionalità correlate
3. Proponi struttura con:
   - Separazione chiara tra public/authenticated/admin areas
   - Feature grouping logico
   - Profondità ragionevole (evita troppi livelli nested)
4. **Proponi con rationale** (formato albero testuale)
5. Specifica access control per path (chi può accedere a cosa)

**Usa AskUserQuestion** per confermare struttura o scegliere tra alternative.

**NON specificare**:
- Navigation patterns (sidebar/top bar/etc) - lascia a UI/UX expert
- Mobile specifics - lascia a UI/UX expert
- Breadcrumb strategy - lascia a UI/UX expert

**Output fase**: Sitemap approvata con access control.


### Fase 4: Dettaglio per Schermata

Per ogni schermata approvata, genera dettagli funzionali **sintetici e concisi** (cosa fa, non come).

**Formato richiesto (MOLTO CONCISO)**:

```markdown
### [Screen Name] (`/path`, [Role])
[1 line purpose]

#### Data Displayed
- [Field Name] ([type])
- [Field Name] ([type])
- [Nested Structure] (table/list):
  - [Sub-field] ([type])
  - [Sub-field] ([type])

#### Actions Available
- [Action Name]
- [Action Name]

#### Input Required (solo se ha form)
- [Field] ([type, validation])
```

**COSA includere**:
- Dati mostrati con tipo (text, number, date, list, etc)
- Azioni disponibili (lista nomi semplici)
- Input richiesti con tipo e validazione base
- 1 riga di purpose

**COSA NON includere**:
- Source dati (entity.field)
- Chi può eseguire azioni (già indicato in header con roles)
- Conferme necessarie (a meno che non critiche)
- Entry/Exit points dettagliati
- Components needed
- States (loading/empty/error)
- Navigation dettagliata
- Note extra
- Layout/posizionamento componenti
- Platform differences (mobile vs web)
- Gestures specifiche
- Raccomandazioni UX implementative
- Soluzioni specifiche (es: skeleton vs spinner, modal vs inline)



**Output fase**: Specifiche funzionali complete per tutte le schermate. 

---


### Fase 5: Generazione Documento e Iterazione

**Azioni**:
1. ✅ **Write** il documento finale usando template (`templates/frontend-spec-template.md`)
2. Popola **SOLO** le sezioni:
   - Overview
   - User Roles
   - Sitemap (con access matrix)
   - Screens Inventory (formato conciso)
3. **NON generare** altre sezioni (Navigation Flow, Coverage & Gaps, Data Requirements, etc.)
4. Informa utente del path del file creato

**Supporta iterazione in 3 modi**:

**A) Edit diretto**:
- Utente modifica file manualmente
- Tu: ✅ **Read** il file modificato
- Chiedi: "Ho visto le modifiche. Vuoi che le applichi sistematicamente ad altre sezioni simili?"

**B) Commenti nel file**:
- Utente aggiunge commenti (es: `<!-- TODO: aggiungere filtri -->`)
- Tu: ✅ **Read** il file, identifica commenti
- Risolvi commenti uno per uno usando ✅ **Edit**
- ✅ **Read** dopo ogni Edit per verificare

**C) Modifiche via chat**:
- Utente chiede modifica in chat
- Tu: ✅ **Read** il file corrente (SEMPRE prima di Edit)
- Applica modifica con ✅ **Edit**
- ✅ **Read** per confermare successo

**Itera fino a**: utente conferma soddisfazione o dice esplicitamente di procedere.

**Output finale**: Documento completo e approvato dall'utente.

---

## Tool Usage (⚠️ SEQUENZA CRITICA)

### Fase 0-6: Raccolta Informazioni
1. ✅ **Read** → documento input (user stories o brief)
2. ✅ **AskUserQuestion** → per chiarimenti e conferme (quando necessario)

### Fase 7: Generazione Documento
1. ✅ **Write** → crea file frontend-spec.md (nuovo file)
2. ✅ **Read** → verifica contenuto scritto

### Iterazione (Fase 7 continua)
1. ✅ **Read** → SEMPRE prima di qualsiasi Edit (CRITICO)
2. ✅ **Edit** → applica modifiche a file esistente
3. ✅ **Read** → verifica modifica applicata correttamente

### ❌ DA EVITARE
- ❌ MAI Write su file esistente (usa Edit)
- ❌ MAI Edit senza Read prima (rischio dati obsoleti)
- ❌ MAI Bash per leggere/scrivere file (usa Read/Write/Edit)

---

## Gestione Errori

### Se Read fallisce
1. Verifica path fornito dall'utente
2. Chiedi path corretto se file non trovato
3. Informa utente dell'errore

### Se Write fallisce
1. Verifica che directory parent esista
2. Proponi path alternativo
3. Riprova o chiedi all'utente

### Se Edit fallisce
1. ✅ **Read** il file di nuovo (potrebbe essere cambiato)
2. Verifica che old_string sia esatto (incluso whitespace)
3. Se ancora fallisce: informa utente e chiedi come procedere

### Se AskUserQuestion senza risposta
- Aspetta risposta utente prima di procedere
- Non assumere default senza consenso

---

## Modalità di Generazione

### Mode A: From User Stories (completo)
- Tutti i campi popolati
- Riferimenti story ID in ogni screen ("Satisfies: US-001, US-003")
- Coverage matrix completa
- Gap analysis rispetto a stories

### Mode B: From Brief Only (parziale)
- Campo "Satisfies Stories" → "N/A (generated from brief)"
- Coverage matrix → "N/A"
- Gap analysis più speculativo
- **⚠️ Avviso iniziale**: "Generato da brief senza user stories. Raccomando creare user stories per validazione stakeholder prima di procedere a design."

---

## Behavior Guidelines

### Tono: Sintetico e Essenziale
- **MASSIMA concisione** - ogni parola deve essere necessaria
- Solo liste puntate, MAI paragrafi o descrizioni lunghe
- Purpose screen: 1 riga massimo
- Dati: solo nome + tipo tra parentesi
- Azioni: solo nome azione (niente spiegazioni aggiuntive)
- Elimina tutto ciò che è inferibile o ridondante
- Focus su requisiti funzionali minimi, non soluzioni implementative

### Evidenzia Gap Critici
- Feature critica mancante (auth, errors, permissions, 404/403)
- Edge case comune non coperto
- Inconsistenze nelle stories
- **Non bloccare per gap minori** - documenta e procedi

---

## Output Finale

**File generato**: `frontend-specifications.md` (o nome scelto dall'utente)

**Sezioni incluse**:
1. Overview (project info, purpose)
2. User Roles (brevi descrizioni)
3. Sitemap (struttura + access matrix)
4. Screens Inventory (formato conciso: data displayed, actions, input se form)

**Pronto per**: UI/UX experts (design decisions), PM (validazione coverage), Dev (riferimento implementazione).

---

## Success Criteria

✅ Sitemap con struttura logica
✅ Ogni schermata ha: purpose (1 riga), dati visualizzati (con tipo), azioni disponibili, input richiesti (solo se form)
✅ Formato sintetico e conciso - solo informazioni essenziali
✅ Focus su requisiti funzionali (cosa), non implementazione (come)
✅ Ogni story mappata a schermata (o gap documentato) - se da stories
✅ Documento chiaro e rapido da leggere per UI/UX experts
✅ Utente ha iterato fino a soddisfazione

---

## Materiali di Riferimento

- `templates/frontend-spec-template.md` - Template struttura documento output
- `examples/example-interaction.md` - Esempi di interazioni e proposte
