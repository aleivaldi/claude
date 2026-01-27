# Process Phases: Dettaglio 7 Fasi (File-Based Workflow)

Questo documento fornisce istruzioni dettagliate per ogni fase del processo di generazione user stories. Consulta `SKILL.md` per overview generale.

## Workflow File-Based

⚠️ **IMPORTANTE**: La skill usa un approccio file-based con file intermedi:
- **Fase 1** genera `user-stories-structure.md` (ruoli, aree, apps)
- **Fase 2** legge structure.md e chiede granularità
- **Fase 3** genera `user-stories-list.md` (solo titoli stories)
- **Fase 4** legge list.md e lo aggiorna con edge cases
- **Fase 5** genera `user-stories-draft.md` (stories complete)
- **Fase 6** legge draft.md e valida
- **Fase 7** legge draft.md e genera output finale

**Ogni file intermedio**:
- È modificabile direttamente dall'utente
- Viene letto dalla skill prima della fase successiva
- Permette iterazione controllata con progetti grandi (100+ stories)

Per dettagli file intermedi vedi `defaults.md` sezione "File Intermedi".

---

## Fase 1: Analisi Iniziale

### Obiettivo
Estrarre dal project brief la struttura del progetto: ruoli utente, aree funzionali, applicazioni separate.

### Processo Dettagliato

#### Step 1.1: Lettura e Scansione Brief

**Azioni**:
1. Leggi project brief con Read tool
2. Identifica sezioni rilevanti:
   - "Utenti" / "Users" / "User Roles"
   - "Funzionalità" / "Features" / "Functionality"
   - "Applicazioni" / "Applications" / "Frontend"
   - "Obiettivi" / "Goals"
   - "Workflow utente" / "User Workflow"

**Output**: Brief caricato in memoria.

#### Step 1.2: Estrazione Ruoli

**Cerca pattern**:
- Ruoli espliciti: "Admin", "User", "Guest", "Moderator", etc.
- Descrizioni implicite: "gli utenti possono...", "gli amministratori hanno accesso..."
- Permessi: "chi può fare X", "solo Y può fare Z"

**Regole**:
- Normalizza nomi: "Amministratore" → "Admin", "Utente finale" → "User"
- Identifica permessi per ruolo
- Se non espliciti, inferisci da funzionalità descritte

**Esempio output**:
```
Ruoli identificati:
- User: Utente registrato, può usare funzionalità base
- Admin: Amministratore, gestisce utenti e contenuti
- Guest: Visitatore non autenticato, accesso limitato
```

#### Step 1.3: Estrazione Aree Funzionali

**Criteri per identificare aree**:
- Funzionalità correlate che condividono dominio (es: login, logout, recupero password → "Autenticazione")
- Sezioni esplicite nel brief
- Entità/oggetti del dominio (Profilo, Prodotti, Ordini, etc.)

**Naming convention aree**:
- 3-6 lettere uppercase
- Descrittive e univoche
- Esempi: AUTH, PROFILE, PAYMENT, NOTIF, CONTENT, DASHBOARD

**Raggruppa funzionalità**:
```
Autenticazione (AUTH):
- Registrazione
- Login/Logout
- Recupero password
- Verifica email

Gestione Profilo (PROFILE):
- Visualizzazione dati
- Modifica informazioni
- Upload avatar
- Impostazioni privacy
```

**Stima stories per area** basandoti su granularità che sarà scelta in Fase 2.

#### Step 1.4: Identificazione Applicazioni/Frontend

**Cerca indicatori**:
- Menzione esplicita: "web app", "admin panel", "mobile app", "API pubblica"
- Separazione di contesto: "dashboard amministratore", "interfaccia utente"
- Ruoli dedicati a specifiche interfacce

**Se trovati più frontend**:
- Nota quale ruolo usa quale frontend
- Identifica se ci sono stories condivise o separate

**Esempio**:
```
Applicazioni identificate:
- Web App (User, Guest): Interfaccia utente principale
- Admin Panel (Admin): Dashboard amministrativa
- Mobile App (User): App nativa iOS/Android

Stories condivise: Autenticazione (login funziona per tutti)
Stories separate: Dashboard (diversa per User vs Admin)
```

#### Step 1.5: Generazione File Structure

**Genera file `user-stories-structure.md`** con Write tool:

1. **Usa template** da `templates/user-stories-structure.md`
2. **Popola con**:
   - Ruoli identificati con descrizioni
   - Aree funzionali con funzionalità mappate
   - Applicazioni (se presenti)
   - Sezione commenti/note per utente
3. **Write** file in directory corrente

#### Step 1.6: Comunicazione e Attesa Conferma

**Comunica all'utente**:
```
"Ho generato `user-stories-structure.md` con la struttura identificata:
- [N] ruoli: [lista]
- [M] aree funzionali: [lista]
- [K] applicazioni: [lista]

Puoi modificare il file direttamente:
- Aggiungere/rimuovere ruoli o aree
- Rinominare acronimi aree
- Aggiungere commenti per guidare generazione

Quando sei pronto, conferma per procedere alla Fase 2."
```

**ATTENDI conferma esplicita** dell'utente prima di procedere.

### Output Fase 1

**File generato**: `user-stories-structure.md` contenente:
- Lista ruoli con descrizione e permessi
- Aree funzionali con funzionalità raggruppate
- Applicazioni/frontend (se presenti)
- Sezione note/commenti utente

---

## Fase 2: Definizione Granularità

### Obiettivo
Leggere structure.md modificato dall'utente e decidere il livello di dettaglio delle user stories.

### Processo Dettagliato

#### Step 2.1: Lettura Structure Modificato

**Azioni**:
1. **Leggi `user-stories-structure.md`** con Read tool
2. **Analizza modifiche** utente: ruoli aggiunti, aree rinominate, commenti/note
3. **Registra struttura** finale confermata per generazione stories

#### Step 2.2: Spiegazione Livelli

**Presenta all'utente con AskUserQuestion**:

**Epic Level (Alto Livello)**:
- 1 story per macro-funzionalità
- Esempio: "Come User, gestire il mio profilo"
- Pro: Overview veloce, alta prospettiva
- Contro: Poco dettaglio per sviluppo
- Quando usare: Concept validation, roadmap planning, pitch a stakeholder

**Feature Level (Medio - CONSIGLIATO)**:
- 3-5 stories per area funzionale
- Esempio: "Come User, modificare dati personali", "Come User, cambiare password", "Come User, eliminare account"
- Pro: Bilanciamento dettaglio/leggibilità, ideale per validazione cliente
- Contro: Potrebbe servire breakdown ulteriore per dev
- Quando usare: Validazione con clienti/partner, MVP planning, stima progetto

**Task Level (Dettagliato)**:
- 8-15 stories per area, include edge cases
- Esempio: "Come User, validare formato email in registrazione", "Come User, ricevere errore se email duplicata", "Come User, vedere progress bar durante registrazione"
- Pro: Massimo dettaglio, pronto per development
- Contro: Documentazione molto lunga, può perdere vista d'insieme
- Quando usare: Sprint planning, handoff a sviluppo, progetti complessi

#### Step 2.2: Raccomandazione

**Suggerisci basandoti su contesto**:
- Se brief menziona "validazione con cliente" → Feature
- Se brief è per "development team" → Task
- Se brief è "concept iniziale" → Epic
- **Default**: Feature (80% dei casi)

#### Step 2.3: Conferma Scelta

**Chiedi con AskUserQuestion**:
```
"Quale livello di dettaglio preferisci per le user stories?"

Opzioni:
- Epic (alta prospettiva, veloce)
- Feature (bilanciato, CONSIGLIATO per validazione)
- Task (dettaglio massimo, per sviluppo)
```

**Registra scelta** per guidare Fase 3.

### Output Fase 2

**Granularità confermata**: Epic / Feature / Task

---

## Fase 3: Generazione Lista Stories (Solo Titoli)

### Obiettivo
Creare lista completa di titoli user stories con IDs univoci, organizzati per area funzionale.

### Processo Dettagliato

#### Step 3.1: Generazione IDs e Titoli

**Per ogni area funzionale**:

1. **Crea ID sequenziali** partendo da 001
2. **Formula titolo** nel formato: `Come [ruolo], [azione breve]`
3. **Se story vale per più ruoli**: Indica tutti (User/Admin)
4. **Se story è variante**: Usa sub-numero (001.1, 001.2)

**Applica granularità scelta**:
- **Epic**: 1 story = 1 macro-area (es: "Come User, gestire autenticazione")
- **Feature**: 1 story = 1 funzionalità chiara (es: "Come User, registrarsi con email")
- **Task**: 1 story = 1 azione specifica o edge case (es: "Come User, vedere errore se email già registrata")

**Esempio output Feature level**:

```
### Autenticazione (AUTH) - 7 stories

Must Have:
- US-AUTH-001: Come User, registrarsi con email e password
- US-AUTH-002: Come User/Admin, fare login con credenziali
- US-AUTH-003: Come User/Admin, recuperare password dimenticata
- US-AUTH-004: Come User, verificare email dopo registrazione

Should Have:
- US-AUTH-005: Come User/Admin, fare logout
- US-AUTH-006: Come User, rimanere autenticato (remember me)

Nice to Have:
- US-AUTH-007: Come User, registrarsi con OAuth (Google/Facebook)

### Gestione Profilo (PROFILE) - 5 stories

Must Have:
- US-PROFILE-001: Come User, visualizzare il mio profilo
- US-PROFILE-002: Come User, modificare dati personali
- US-PROFILE-003: Come User, cambiare password

Should Have:
- US-PROFILE-004: Come User, caricare avatar
- US-PROFILE-005: Come Admin, visualizzare profili altri utenti
```

#### Step 3.2: Assegnazione Priorità

**Criteri** (da brief e buon senso):
- **Must Have**: Funzionalità core per MVP, blocker per lancio
- **Should Have**: Importanti ma non blocker, possono attendere release successive
- **Nice to Have**: Miglioramenti futuri, non critici

**Fonti per decidere**:
1. Sezione "MVP" o "Scope MVP" nel brief → Must Have
2. Sezione "Future Enhancements" → Nice to Have
3. Funzionalità di base (auth, CRUD) → Must Have
4. Funzionalità avanzate/complementari → Should/Nice to Have

**Se ambiguo**: Consulta `defaults.md` o chiedi all'utente.

#### Step 3.3: Identificazione Relazioni

**Dipendenze comuni**:
- Login REQUIRES registrazione
- Modifica profilo REQUIRES autenticazione
- Pagamento REQUIRES carrello

**Notazione**:
- `[REQUIRES: US-XXX-YYY]` - prerequisito
- `[EXTENDS: US-XXX-YYY]` - variante/estensione
- `[ALTERNATIVE TO: US-XXX-YYY]` - opzione alternativa

**Esempio**:
```
US-AUTH-002: Come User, fare login [nessuna dipendenza]
US-PROFILE-002: Come User, modificare profilo [REQUIRES: US-AUTH-002]
US-PAYMENT-005: Come User, salvare metodo pagamento [REQUIRES: US-PROFILE-002, US-PAYMENT-001]
```

#### Step 3.4: Organizzazione Output

**Mostra lista** strutturata:

```
# User Stories Lista - [Nome Progetto]

## Summary
- Total stories: X
- Must Have: Y
- Should Have: Z
- Nice to Have: W

## [Area 1] - N stories
[lista stories area 1]

## [Area 2] - M stories
[lista stories area 2]

...
```

#### Step 3.5: Validazione con Utente

**Chiedi conferma** con AskUserQuestion:

```
"Ho generato [N] user stories organizzate in [M] aree. La lista copre tutte le funzionalità?

Vuoi:
- Confermare e procedere
- Aggiungere stories mancanti
- Rimuovere stories non necessarie
- Modificare titoli o priorità
- Riorganizzare aree"
```

**Se modifiche richieste**:
1. Applica modifiche
2. Ri-mostra lista aggiornata
3. Chiedi nuova conferma
4. Ripeti fino a conferma finale

**IMPORTANTE**: Non procedere a Fase 4 senza conferma esplicita.

### Output Fase 3

**Lista titoli confermata** con:
- IDs univoci e sequenziali
- Titoli chiari e concisi
- Priorità assegnate
- Relazioni identificate
- Organizzazione per area

---

## Fase 4: Gestione Edge Cases e Varianti

### Obiettivo
Decidere come gestire validazioni, errori, edge cases e varianti comportamentali.

### Processo Dettagliato

#### Step 4.1: Identificazione Edge Cases

**Categorie comuni**:

**Validazioni**:
- Formato email invalido
- Password troppo debole
- Campi obbligatori mancanti
- File troppo grande/formato errato

**Errori**:
- Email già registrata
- Credenziali errate
- Sessione scaduta
- Permessi insufficienti

**Casi Limite**:
- Timeout network
- Rate limiting
- Concorrenza (2 utenti modificano stesso dato)
- Quota esaurita

**Varianti Comportamentali**:
- Con/senza notifiche
- Modalità offline
- Diversi provider (OAuth Google vs Facebook)

#### Step 4.2: Proposta Gestione

**Per ogni edge case**, valuta:

**Opzione A: Acceptance Criteria nella story principale**
- Quando: Validazione semplice, comportamento standard atteso
- Esempio:
  ```
  US-AUTH-001: Come User, registrarmi con email
  Acceptance Criteria:
  - Quando email formato invalido, allora vedo errore "Email non valida"
  - Quando password < 8 caratteri, allora vedo errore "Password troppo corta"
  ```

**Opzione B: Sub-story (US-XXX-YYY.1)**
- Quando: Variante significativa dello stesso flusso, errore complesso
- Esempio:
  ```
  US-AUTH-001: Come User, registrarmi con email [happy path]
  US-AUTH-001.1: Come User, gestire errori durante registrazione [error handling]
  US-AUTH-001.2: Come User, completare registrazione via email verification [variante flusso]
  ```

**Opzione C: Story separata (US-XXX-YYY+1)**
- Quando: Caso complesso che sta in piedi da solo, funzionalità alternativa
- Esempio:
  ```
  US-AUTH-001: Come User, registrarmi con email/password
  US-AUTH-007: Come User, registrarmi con OAuth Google [alternativa completa]
  ```

#### Step 4.3: Raccomandazione

**Applica questi criteri**:
- Validazioni input → Acceptance Criteria
- Gestione errori complessa → Sub-story
- Flussi alternativi → Story separata
- Edge cases tecnici (timeout, rate limit) → Acceptance Criteria se Task level, altrimenti Sub-story

#### Step 4.4: Presentazione e Conferma

**Usa AskUserQuestion**:

```
"Ho identificato [N] edge cases e varianti (validazioni, errori, casi limite).

Come preferisci gestirli?
- Come acceptance criteria nelle stories principali (lista compatta)
- Come sub-stories numerate .1, .2 (tracciabilità media)
- Come stories separate (massima granularità)
- Mix: acceptance criteria per validazioni semplici, sub-stories per casi complessi (CONSIGLIATO)"
```

**Mostra esempi concreti** dal progetto specifico.

#### Step 4.5: Applicazione Strategia

**Se mix (consigliato)**:
1. Aggiungi acceptance criteria per validazioni semplici
2. Crea sub-stories per errori/varianti complessi
3. Crea stories separate per alternative significative

**Aggiorna lista** e ri-mostra conteggio:
```
Stories aggiornate:
- Must Have: Y (+X rispetto a prima)
- Should Have: Z (+W)
- Nice to Have: Q (+P)
```

### Output Fase 4

**Strategia edge cases confermata** e **lista stories aggiornata** con edge cases integrati.

---

## Fase 5: Espansione Stories Complete

### Obiettivo
Espandere ogni story con descrizione completa, acceptance criteria dettagliati, priorità e relazioni.

### Processo Dettagliato

#### Step 5.1: Formato Espansione

**Per ogni story**, espandi con:

```markdown
**US-[AREA]-[NUM]:** Come [ruolo/i], voglio [azione] per [beneficio]

**Acceptance Criteria:**
- Quando [precondizione/azione], allora [risultato atteso]
- Quando [altra precondizione], allora [altro risultato]
- E [validazione aggiuntiva]

**Priorità:** [Must Have / Should Have / Nice to Have]

**Relazioni:** [REQUIRES/EXTENDS/ALTERNATIVE TO: US-XXX-YYY] (se presenti)

**Note:** [Informazioni aggiuntive se necessarie] (opzionale)
```

#### Step 5.2: Formulazione Descrizione

**Formato**: "Come [ruolo], voglio [azione] per [beneficio]"

**Componenti**:
- **Ruolo**: Chi beneficia (User, Admin, User/Admin se condiviso)
- **Azione**: Cosa vuole fare (verbo all'infinito)
- **Beneficio**: Perché vuole farlo (valore per utente)

**Esempi buoni**:
- ✅ "Come User, voglio registrarmi con email per creare un account e accedere alla piattaforma"
- ✅ "Come Admin, voglio visualizzare lista utenti per gestire gli accessi al sistema"
- ✅ "Come User/Admin, voglio recuperare la password dimenticata per riottenere accesso senza supporto"

**Esempi cattivi**:
- ❌ "Come User, voglio usare il sistema" (troppo vago)
- ❌ "Come Developer, voglio chiamare API REST" (prospettiva tecnica, non utente)
- ❌ "Implementare login" (nessun ruolo o beneficio)

#### Step 5.3: Scrittura Acceptance Criteria

**Formato**: "Quando [condizione], allora [risultato]"

**Best practices**:
- Focalizzati su **risultati verificabili** (UI, dati, notifiche)
- Includi **happy path** principale
- Aggiungi **validazioni** critiche
- Specifica **comportamento errori** se rilevante
- Usa **"E"** per validazioni aggiuntive collegate

**Esempio completo**:
```markdown
**US-AUTH-002:** Come User/Admin, voglio fare login con credenziali per accedere alle funzionalità protette

**Acceptance Criteria:**
- Quando inserisco email e password corrette, allora vengo reindirizzato alla dashboard
- Quando inserisco credenziali errate, allora vedo messaggio "Credenziali non valide"
- Quando supero 5 tentativi falliti, allora il mio account viene bloccato per 15 minuti
- E la password non viene mai mostrata in chiaro durante digitazione
- E ricevo notifica email se login da dispositivo nuovo

**Priorità:** Must Have
**Relazioni:** [REQUIRES: US-AUTH-001]
```

#### Step 5.4: Processo Incrementale per Area

**IMPORTANTE**: Non generare tutte le stories in una volta.

**Per ogni area**:
1. **Seleziona area** (es: Autenticazione)
2. **Espandi tutte stories dell'area** con formato completo
3. **Mostra output** all'utente in formato chiaro e leggibile
4. **Chiedi feedback** con AskUserQuestion:
   ```
   "Ho espanso le [N] stories per [Area]. Sono complete e corrette?

   Vuoi:
   - Confermare e procedere alla prossima area
   - Modificare acceptance criteria di alcune stories
   - Aggiungere/rimuovere criteri
   - Modificare priorità"
   ```
5. **Applica modifiche** se richieste
6. **Conferma** prima di passare a area successiva

**Ripeti** per tutte le aree.

#### Step 5.5: Validazione Cross-Area

Dopo tutte le aree espanse:
1. **Verifica coerenza** priorità (Must Have davvero critici?)
2. **Controlla dipendenze** (tutte valide e non circolari?)
3. **Identifica gap** (funzionalità menzionate nel brief ma senza story?)

**Se trovi problemi**, segnala e proponi correzioni.

### Output Fase 5

**Tutte stories espanse** con:
- Descrizione completa (ruolo, azione, beneficio)
- Acceptance criteria dettagliati e verificabili
- Priorità confermata
- Relazioni documentate
- Note aggiuntive se necessarie

---

## Fase 6: Validazione Finale

### Obiettivo
Mostrare summary complessivo, statistiche e raccogliere feedback finale prima della generazione output.

### Processo Dettagliato

#### Step 6.1: Calcolo Statistiche

**Conta**:
- Total stories (incluse sub-stories)
- Distribuzione per priorità (%, numero)
- Stories per area funzionale
- Stories multi-ruolo (condivise User/Admin/etc.)
- Catene di dipendenze (stories con 2+ prerequisiti)

#### Step 6.2: Generazione Summary

**Formato**:

```markdown
## Summary Finale

### Totale Stories: X

**Per Priorità:**
- Must Have: Y (Z% del totale)
- Should Have: W (K% del totale)
- Nice to Have: Q (P% del totale)

**Per Area Funzionale:**
- Autenticazione (AUTH): N stories
- Gestione Profilo (PROFILE): M stories
- Pagamenti (PAYMENT): L stories
- ...

**Stories Multi-Ruolo:** R stories (condivise tra più ruoli)

**Dipendenze Critiche** (catene lunghe o complesse):
- US-PAYMENT-005 REQUIRES US-PROFILE-002 REQUIRES US-AUTH-002
- US-NOTIF-003 REQUIRES US-AUTH-002, US-PROFILE-001
- ...

### Distribuzione Effort (stima indicativa)

Se livello Task:
- Quick wins (Must Have, no dependencies): X stories
- Medium effort: Y stories
- Complex (multiple dependencies): Z stories
```

#### Step 6.3: Identificazione Issues

**Controlla**:
- **Sbilanciamento priorità**: Se >70% Must Have, troppo ambizioso per MVP
- **Dipendenze circolari**: US-A REQUIRES US-B, US-B REQUIRES US-A
- **Stories orfane**: Nessuna dipendenza da/verso, forse mancano collegamenti
- **Aree squilibrate**: Un'area con 30 stories, altre con 3 (forse granularità inconsistente)

**Se trovi problemi**, segnala e proponi correzioni.

#### Step 6.4: Validazione con Utente

**Mostra summary** e chiedi con AskUserQuestion:

```
"Ecco il summary completo delle user stories generate.

[Mostra summary sopra]

Ci sono modifiche finali da fare?
- Tutto ok, procedi a generazione file
- Modificare priorità di alcune stories
- Aggiungere stories mancanti
- Rimuovere stories non necessarie
- Aggiungere documentazione aggiuntiva (glossario, note tecniche)"
```

#### Step 6.5: Applicazione Modifiche Finali

**Se richieste modifiche**:
1. Applica modifiche specifiche
2. Ricalcola statistiche
3. Ri-mostra summary aggiornato
4. Chiedi nuova conferma

**Se richiesto glossario/note**:
1. Identifica termini tecnici o di dominio
2. Crea sezione glossario da includere in output
3. Mostra preview e chiedi conferma

### Output Fase 6

**Stories finalizzate** e **summary confermato**, pronti per generazione output.

---

## Fase 7: Generazione Output

### Obiettivo
Creare file Markdown strutturati con tutte le user stories, organizzati per leggibilità e tracciabilità.

### Processo Dettagliato

#### Step 7.1: Decisione Strategia Output

**Criteri per Single vs Multi-File**:

**Single File** (`user-stories-[nome-progetto].md`):
- Quando: 1 applicazione E < 50 stories totali
- Pro: Documento unico, facile condivisione, find/search semplice
- Contro: File lungo se molte stories

**Multi-File** (overview + sezioni):
- Quando: Più applicazioni OPPURE > 50 stories
- File generati:
  - `user-stories-[nome-progetto]-overview.md` (indice + summary)
  - `user-stories-[app/area].md` (per ogni sezione)
- Pro: Navigazione modulare, file più gestibili
- Contro: Più file da mantenere sincronizzati

**Chiedi conferma** con AskUserQuestion:
```
"Il progetto ha [N] stories organizzate in [M] aree.

Preferisci:
- Single file (tutto in un documento)
- Multi-file (overview + 1 file per area/app) [CONSIGLIATO se >50 stories]"
```

#### Step 7.2: Popolamento Template

**Per Single File**:
1. Usa `templates/user-stories-single.md`
2. Sostituisci placeholder:
   - `[Nome Progetto]`
   - `[Data]`
   - `[Livello dettaglio]`
   - `[Applicazioni]`
3. Inserisci ruoli con descrizioni
4. Inserisci stories area per area, organizzate per priorità
5. Inserisci summary finale
6. Aggiungi glossario se richiesto

**Per Multi-File**:
1. Usa `templates/user-stories-overview.md` per overview
2. Usa `templates/user-stories-section.md` per ogni sezione
3. Nel overview: indice con link a sezioni, summary generale
4. In ogni sezione: stories dell'area specifica

Consulta `examples/example-format.md` per riferimento.

#### Step 7.3: Naming Convention

**Single file**:
- `user-stories-[nome-progetto].md`
- Esempio: `user-stories-booking-platform.md`

**Multi-file**:
- Overview: `user-stories-[nome-progetto]-overview.md`
- Sezioni: `user-stories-[app/area].md`
- Esempi:
  - `user-stories-booking-platform-overview.md`
  - `user-stories-web-app-auth.md`
  - `user-stories-admin-panel-users.md`

#### Step 7.4: Generazione File

**Usa Write tool** per creare file:

**Per single file**:
```
Write(user-stories-[nome].md) → contenuto completo
```

**Per multi-file**:
```
Write(user-stories-[nome]-overview.md) → overview
Write(user-stories-[sezione-1].md) → prima sezione
Write(user-stories-[sezione-2].md) → seconda sezione
...
```

**Directory**: Corrente, a meno che utente specifichi diversamente.

#### Step 7.5: Conferma Completamento

**Comunica all'utente**:

```
"User stories generate con successo!

File creati:
- [path/file-1.md]
- [path/file-2.md] (se multi-file)
- ...

Summary:
- [N] stories totali
- [M] Must Have, [L] Should Have, [K] Nice to Have
- Organizzate in [X] aree funzionali

Prossimi passi suggeriti:
1. Condividi con stakeholder per validazione
2. Usa per stima effort e planning sprint
3. Importa in tool di project management (se supportato)
4. Evolvi stories durante sviluppo basandoti su feedback"
```

### Output Fase 7

**File Markdown generati** con:
- Struttura chiara e navigabile
- Tutte stories complete di dettagli
- Summary e statistiche
- Glossario (se richiesto)
- Naming convention consistente

---

## Edge Cases Generali

### Brief Ambiguo o Incompleto

**Sintomi**:
- Ruoli non chiari
- Funzionalità descritte vagamente
- Mancano obiettivi o benefici

**Azioni**:
1. Identifica lacune specifiche
2. Chiedi chiarimenti con AskUserQuestion
3. Se impossibile procedere, segnala e suggerisci di migliorare brief prima
4. Se possibile, procedi con assunzioni esplicite e documentale

### Modifiche Sostanziali Durante Processo

**Se utente chiede cambiamenti grandi** (es: cambiare granularità, riorganizzare tutte aree):
1. Valuta se conviene ripartire da fase specifica
2. Non cercare di patchare incrementalmente se troppo complesso
3. Comunica: "Questi cambiamenti richiedono di rifare [Fase X]. Procedo?"

### Stories Molto Numerose (>100)

**Considerazioni**:
- Verifica granularità: forse Task level è troppo dettagliato per lo scope
- Proponi dividere in release: "Primo documento con Must Have, secondo con Should/Nice"
- Multi-file praticamente obbligatorio

### Dipendenze Complesse

**Se catene lunghe** (US-A → US-B → US-C → US-D):
1. Segnala all'utente nella validazione finale
2. Suggerisci di spezzare se possibile
3. Evidenzia nel documento come "Critical Path"

---

## Checklist Qualità Output

Prima di generare file finale, verifica:

- [ ] Tutti IDs sono univoci e sequenziali
- [ ] Nomenclatura consistente (US-AREA-NUM)
- [ ] Ogni story ha descrizione completa (ruolo, azione, beneficio)
- [ ] Acceptance criteria sono verificabili
- [ ] Priorità assegnate a tutte le stories
- [ ] Dipendenze documentate dove presenti
- [ ] Stories multi-ruolo indicate esplicitamente (User/Admin)
- [ ] Nessuna duplicazione (se funzione identica per più ruoli → 1 story)
- [ ] Summary con statistiche corrette
- [ ] Template popolato correttamente (no placeholder rimanenti)
- [ ] Lingua consistente con input

---

## Note Finali

Questo processo è **flessibile** e **iterativo**. L'utente può:
- Tornare indietro a fasi precedenti
- Modificare decisioni già prese
- Chiedere variazioni al processo standard

**Principio chiave**: L'utente guida, tu faciliti. Chiedi conferma ai punti critici, non assumere preferenze.
